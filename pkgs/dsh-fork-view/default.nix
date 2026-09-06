# dsh-fork-view — pi-web-style nested fork/subagent process tree in the dsh
# web sidebar. BUNDLE plugin (dsh.bundle.patch → cordis.patch.yml) with a
# client half.
#
# lib/ is a gitignored esbuild artifact, so the codeload tarball has no lib/:
# buildScript re-runs the exact build.mjs invocations against src/ using the
# esbuild CLI provided on PATH by mkNpmPlugin. schemastery is a KEPT peer:
# stripped from the nix-build view (vendor/), so npm never bundles it — it
# resolves at runtime from the profile's shared top-level `schemastery` bundle
# (single cosmokit instance). esbuild devDep is stripped too, so nothing is
# installed here (forceEmptyCache; the vendor manifest declares no deps/peers).
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "dsh-fork-view";
  version = "0.1.1";
  forceEmptyCache = true;
  tarball = fetchurl {
    url = "https://codeload.github.com/an4nsi/dsh-fork-view/tar.gz/d0be2986ed7ece4f5f42987016ea0b1d7ccffb9e";
    sha256 = "sha256-DHyUyjRP7utQKmKhpKzm9frPrOadut5VHUZMB2swAZM=";
  };
  buildScript = ''
    # mirror of build.mjs: lib/client.js (CJS, react external) + lib/index.js (ESM, schemastery external)
    esbuild src/client/index.jsx --bundle --format=cjs --outfile=lib/client.js --external:react --external:react/jsx-runtime --jsx=transform --jsx-factory=jsx --jsx-fragment=Fragment
    esbuild src/index.js --bundle --format=esm --outfile=lib/index.js --external:schemastery
  '';
  npmDepsHash = "sha256-b3J1EXG8wBKDFwwzxb6W+9rrPJzoeV9myZotiT8mnNc=";
  patchDir = ./vendor;
}
