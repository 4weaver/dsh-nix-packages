# dsh-client-ui-workspace — vendor override of the official sidebar workspace
# browser, adding a fork-tree view to the grouped sidebar.
#
# WHY an override, not a plugin: upstream rc.1 flattens every session (fork
# children included) to a top-level row and the sidebar browser exposes no
# per-row slot, so the tree can only be had by replacing the
# `sidebar.workspaces` occupant package itself.
#
# HOW the replacement reaches the runtime: this derivation is a normal plugin
# entry (out/lib/node_modules/<name>) but carries the OFFICIAL name and
# version, so buildProfile's symlinkJoin — plugin paths first, core last
# (first-wins) — lifts it to the profile top-level and the official copy
# nested inside core's tree loses the leaf. Verified: symlinkJoin merges the
# shared `@deepseek-ai/` parent and the first path wins per leaf.
#
# lib/ is COMMITTED to 4weaver/dsh-client-ui-workspace (client-face tsdown
# bundle with the official module id), so no buildScript is needed. The bundle
# inlines clsx and externalizes react / react-jsx-runtime / cordis /
# dsh-client-store / dsh-client-ui-primitives (the official externals), so
# nothing is installed here → forceEmptyCache. patchDir/vendor carries a
# dep-less manifest so npm never reaches the network.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "@deepseek-ai/dsh-client-ui-workspace";
  version = "0.1.2-rc.1";
  forceEmptyCache = true;
  tarball = fetchurl {
    url = "https://codeload.github.com/4weaver/dsh-client-ui-workspace/tar.gz/856203b8769a4e450b9f7f8a6a98457fba5bb2d2";
    sha256 = "sha256-Ybo3py5q7Cx2hdyy7ADYofSvRxfcA9CJqmQiptWena8=";
  };
  npmDepsHash = "sha256-5K3NzRCy6eFkfFzScYNaPmVDSS7veQlCFrVMYnRiFgQ=";
  patchDir = ./vendor;
}
