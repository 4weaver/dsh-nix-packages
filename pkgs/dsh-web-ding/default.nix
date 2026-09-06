# dsh-web-ding — job-completion browser notifications + chime for the dsh web UI.
#
# Pure-client plugin: the host half (lib/index.js) is an empty apply, and the
# browser half (exports["./client"] -> lib/client.js) self-registers under
# window.__ModuleLoader__.load({ id: "dsh-web-ding", ... }). lib/ is COMMITTED
# to the source repo (no build step needed; buildScript omitted).
#
# The client bundle externalizes react / cordis / dsh-client-ui-slots (the
# dsh-client-runtime peer is gone in dsh 0.1.2-rc.1; the rc.1 port injects
# only dsh-client-ui-slots), which resolve at runtime from the core's flat
# platform node_modules, so nothing is installed here (forceEmptyCache, legacy peers
# irrelevant — the vendor package.json declares no deps/peers at all). No
# dsh.bundle → the consuming profile must mount it via cordis.patch.yml.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "dsh-web-ding";
  version = "0.3.1";
  forceEmptyCache = true;
  tarball = fetchurl {
    url = "https://codeload.github.com/an4nsi/dsh-web-ding/tar.gz/25323fd8069bb401eae341f10c5eab0efd43796a";
    sha256 = "sha256-Oh+AndfajAR0HAdiLyl3m2lnSsuv16iUywTVA0cqsCg=";
  };
  npmDepsHash = "sha256-GXpxs1zIMr+bMd0+UL/Fi1Emo1tz8z28W4asDISUJ34=";
  patchDir = ./vendor;
}
