# dsh-web-ding — job-completion browser notifications + chime for the dsh web UI.
#
# WHY this package BUILDS FROM SOURCE while it used to ship the committed lib/:
# a committed bundle is a second, unreproducible source of truth. This repo is a
# standalone build unit (no monorepo, no monorepo paths in the sources), so lib/
# is an artifact of `npm run build`, not an input. The repo stopped committing it
# (commit 5bcbdcd) and this derivation regenerates it from src/ on every build.
#
# ONE-STEP BUILD — forkspace's two-step rationale does NOT apply here:
#   be careful before copying pkgs/dsh-client-ui-forkspace's `build:types` then
#   `tsdown` ordering. That repo bundles from a lib/types/*.js that its own tsc
#   pass has to emit first (`tsdown` alone dies there with [UNRESOLVED_ENTRY]).
#   dsh-web-ding has NO tsconfig.types.json, NO `build:types` script, and sets
#   `dts: false` on BOTH tsdown entries: the host half is plain TS and the client
#   half is bundled straight from src/client/index.ts. Verified on a clean
#   checkout of this rev with lib/ deleted — `npm run build` (= bare `tsdown`)
#   emitted lib/index.js AND lib/client.js from scratch, exit 0. So package.json's
#   single `build` script is the whole build; there is nothing to order.
#
# WHY THE SOURCE HAD TO BE PATCHED FOR THIS TO BE PACKAGEABLE AT ALL:
# lib/client.js was NOT byte-reproducible, even locally on one machine. Three
# consecutive `npm run build` runs gave three different md5s (all 13635 B).
# Root cause: lightningcss's transform() returns its `exports` object with a
# nondeterministic key order (5 direct transform() calls on one .module.css gave
# 5 different orders), and tsdown.config.ts's inlined dsh-css-modules plugin
# copied that order into the emitted class-map JSON. Only the JSON key order
# shuffled — class names, hashes and CSS text were identical. A build that
# shuffles bytes run to run cannot pass `nix-build --check`, which compares
# output hashes, so the plugin now sorts the map keys (4/4 identical builds at
# md5 139b2dc1e96c71b08586254a85cfc92e, and the emitted class names/hashes are
# byte-for-byte the same as the committed bundle's). That is the only reason
# this derivation is deterministic; it is a source fix, not a Nix workaround.
#
# ---------------------------------------------------------------------------
# THE BUILD LOCK
# ---------------------------------------------------------------------------
# The repo DOES commit package-lock.json (53 KiB, lockfileVersion 3, 99 packages
# entries, 98 resolved URLs — all on registry.npmjs.org, zero `link` entries,
# zero absolute host paths), so this package does not need to invent one the way
# forkspace had to. vendor/package-lock.json is a copy of the repo's lock at the
# pinned rev, byte-identical to it (md5 46e1fd9bc036d48b97f243c106a8957d), and
# is what npmDeps is keyed off. The OLD vendor/ held a dep-less lock plus a
# stub package.json for the previous mkNpmPlugin prebuilt-bundle package; both
# are gone, since shipping the bundle is exactly what this change removes.
#
# It is copied over the source's own lock in postPatch so there is ONE lock the
# derivation depends on (the vendored, hash-pinned one) rather than trusting
# whatever a future revision of the source happens to carry.
#
# npmDepsHash below is the REAL hash of THAT file, produced by
# prefetch-npm-deps (not guessed, not read off a fakeHash failure) and
# reproduced identically on three runs:
#   sha256-S35vrhejvWZyBnLE1Vq+2bLcYxu6CqB1cyL8S6oyc0A=
#
# ---------------------------------------------------------------------------
# --legacy-peer-deps IS MANDATORY, INCLUDING AT `npm ci` TIME
# ---------------------------------------------------------------------------
# Plain npm 10.9.8 crashes in arborist on tsdown's optional peer
# @vitejs/devtools-vitest. The flag is set as npmFlags (reaching both `npm ci`
# and `npm rebuild`) rather than npmInstallFlags alone, matching forkspace.
# `npm ci --legacy-peer-deps` against this lock on a clean checkout: exit 0,
# 51 packages, lock unchanged.
#
# ---------------------------------------------------------------------------
# SOURCE PINNING
# ---------------------------------------------------------------------------
# Reviewed commit 4weaver/dsh-web-ding@5bcbdcd, pinned by rev so the derivation
# never tracks a moving branch. This rev is the one that removes lib/ and sorts
# the class map; the fetchFromGitHub tarball was confirmed to contain NO lib/.
# (If this package is ever pinned back to 25323fd, the build is no longer
# reproducible and --check will fail — that is the point of pinning 5bcbdcd.)
#
# Output layout: buildNpmPackage installs via `npm pack` to
# $out/lib/node_modules/<name from package.json> — the bare-name layout the dsh
# profile peers expect. package.json's `files` includes lib/, so the freshly
# built lib/index.js and lib/client.js are what land in the store.
#
# No dsh.bundle → the consuming profile must mount it via cordis.patch.yml
# (see dsh-flake: `- id: web-ding / name: 'dsh-web-ding'`).
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "dsh-web-ding";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "4weaver";
    repo = "dsh-web-ding";
    rev = "5bcbdcda8de03cf0591af81044bff8ccb6aca190";
    hash = "sha256-BZ3gKE93WTvBa3KNchclg5hJpgMs+dDPJwVrVtIeErQ=";
  };

  # The vendored lock is the single lock this derivation trusts; overwrite the
  # source's copy so npmDeps and `npm ci` cannot disagree.
  postPatch = ''
    cp ${./vendor/package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-S35vrhejvWZyBnLE1Vq+2bLcYxu6CqB1cyL8S6oyc0A=";

  # Reaches `npm ci` AND `npm rebuild`; mandatory, see header.
  npmFlags = [ "--legacy-peer-deps" ];

  # `build` = bare `tsdown` (both halves in one pass; see header).
  #
  # NOTE, verified by a negative control — this packages the repo's OWN build
  # faithfully, and that build does NOT typecheck. tsdown/rolldown strips types
  # without checking them, so source with a TYPE error builds and ships here
  # (exit 0). A source with a SYNTAX error does fail the derivation (exit 1,
  # `ERROR: npm run build [...] failed`), as does a bad npmDepsHash/lock. So this
  # is a real gate for unparseable/unresolvable input, not a type gate.
  #
  # This is the same defect forkspace's header calls out (its Non-obvious Fact:
  # swallowed type errors), but the fix there does not transfer: forkspace's
  # `build:types` step exists because its bundler CONSUMES emitted lib/types JS,
  # which is absent here. Package.json does carry `typecheck` = `tsc --noEmit`
  # and it currently passes clean (strict: true), so wiring it in here would be a
  # one-line addition if a type gate is wanted — deliberately NOT done, to keep
  # this derivation an exact reproduction of `npm run build` with no extra gate
  # the repo itself does not apply. Nothing shipped depends on the types at
  # runtime (the exports' `types` paths point at lib/types/*.d.ts, which this
  # package never emitted even before this change — pre-existing, not a
  # regression); they only affect downstream TypeScript consumers.
  npmBuildScript = "build";

  # tsdown/lightningcss/typescript live in devDependencies and npm ci installs
  # them (dev deps are not omitted by default). Nothing reaches the network:
  # npmConfigHook sets npm_config_offline=true and every tarball comes from the
  # npmDeps cache. No prune: npmInstallFlags is untouched here, and pruning with
  # the peer flags absent would re-resolve the lock and try to fetch peers offline.
  dontNpmPrune = true;

  # The bundle inlines everything except four externals — react,
  # react/jsx-runtime, cordis (all three as bare specifiers, which resolve from
  # the profile's flat platform node_modules) and @deepseek-ai/dsh-client-ui-slots
  # (a real runtime peer here — it is in `dsh.client.inject` and in
  # peerDependencies). Those are DEV dependencies in this package: they exist to
  # typecheck and bundle, not to ship. Leaving them installed would nest a second
  # copy of react/cordis inside this package and risk shadowing the shared
  # singletons the profile relies on. So strip node_modules after
  # buildNpmPackage has packed the output — npmInstallHook has already run, and
  # `files` in package.json ships only lib/ plus src/docs, so nothing the runtime
  # needs is lost. (Same rationale and mechanism as the forkspace package.)
  postInstall = ''
    rm -rf $out/lib/node_modules/dsh-web-ding/node_modules
  '';

  meta = {
    description = "dsh web plugin: browser notification + two-note chime on turn completion";
    homepage = "https://github.com/4weaver/dsh-web-ding";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
