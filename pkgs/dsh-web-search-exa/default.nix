# @deepseek-ai/dsh-web-search-exa — Exa search provider for the dsh web UI.
#
# Thin plugin: every peer (@deepseek-ai/dsh-launch-environment, dsh-web,
# dsh-invariants, cordis) AND its only dependency (@deepseek-ai/schemastery)
# resolve from the core's flat platform node_modules, so nothing is installed
# here (forceEmptyCache). No dsh.bundle → the consuming profile must mount it
# via cordis.patch.yml (function plugin injecting into ctx.web).
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "@deepseek-ai/dsh-web-search-exa";
  version = "0.1.2-rc.1";
  forceEmptyCache = true;
  tarball = fetchurl {
    url = "https://registry.npmjs.org/@deepseek-ai/dsh-web-search-exa/-/dsh-web-search-exa-0.1.2-rc.1.tgz";
    sha256 = "sha256-474DFw2hl7UV19B3mPNqkoPvEoi4ngPHexMSNjTajHk=";
  };
  npmDepsHash = "sha256-zah/aCLA27kgwCjzje0hZjeson3mDB8o4K6ttgDdONI=";
  patchDir = ./vendor;
}