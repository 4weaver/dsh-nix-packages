# dsh-session-rename — rename_session host tool: finalize the session title
# at wrap-up ([tag] [tag] summary format).
#
# Pure host plugin: all four peers (@deepseek-ai/cordis, @deepseek-ai/dsh-session,
# @deepseek-ai/dsh-session-title, @deepseek-ai/dsh-tools) resolve at runtime from
# the consuming profile's flat node_modules (the dsh core), so nothing is
# installed here (forceEmptyCache; the vendor manifest declares no deps/peers).
# lib/ is COMMITTED to the source repo (no build step needed; buildScript
# omitted). No dsh.bundle → the consuming profile must mount it via
# cordis.patch.yml.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "dsh-session-rename";
  version = "0.1.0";
  forceEmptyCache = true;
  tarball = fetchurl {
    url = "https://codeload.github.com/4weaver/dsh-session-rename/tar.gz/64b253c9e42cdcd964a1c5bea91b90738e4b0f64";
    sha256 = "sha256-z8wMv6q8i3UhON6PhssKnjjv6G5Rp4rIK3KnvT03/Uw=";
  };
  npmDepsHash = "sha256-RZkdn+cmmOVCus3cwxzIqmDdILl5r9T+HDqy6xXSplE=";
  patchDir = ./vendor;
}
