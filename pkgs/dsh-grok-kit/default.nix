# dsh-grok-kit — SuperGrok / X Premium OAuth route for dsh (grok-4.6 chat,
# server-side web/X search fused into the main loop, cross-turn reasoning,
# Imagine). BUNDLE plugin (dsh.bundle.patch -> cordis.patch.yml) with a client
# half. lib/ ships prebuilt in the npm tarball (no build step; buildScript
# omitted).
#
# Third-party community plugin (github:MaRi23333/dsh-grok-kit, Apache-2.0).
# All @deepseek-ai/* + @earendil-works/pi-ai + cordis + react peers resolve at
# runtime from the profile's flat top-level node_modules (single cosmokit
# instance) and are stripped in vendor/ so npm never bundles them. The one
# real third-party runtime dep, undici, stays and is installed here.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "dsh-grok-kit";
  version = "0.1.9";
  tarball = fetchurl {
    url = "https://registry.npmjs.org/dsh-grok-kit/-/dsh-grok-kit-0.1.9.tgz";
    sha256 = "sha256-4OfnpntulLLBzgLRPgLE6pLOvQ/ReIH+PNMMtggBOtc=";
  };
  npmDepsHash = "sha256-6zWpd/lyuwbYSJN3mPrs5feh+4+7MPxz0lX3h/fUtdM=";
  patchDir = ./vendor;
}
