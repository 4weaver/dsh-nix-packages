# @ff-labs/pi-fff (installed under "pi-fff") — FFF fuzzy-find tools for dsh
# via pi2dsh. @sinclair/typebox is promoted into deps (runtime import of a
# Pi peer); the @earendil-works peers are handled by pi2dsh at runtime.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "@ff-labs/pi-fff";
  version = "0.10.6";
  tarball = fetchurl {
    url = "https://registry.npmjs.org/%40ff-labs%2Fpi-fff/-/pi-fff-0.10.6.tgz";
    sha256 = "sha256-3GRdfqmnnFrJUe8u00yexmpIYN+xKFdlL7QQ11w9Mhw=";
  };
  npmDepsHash = "sha256-giyNyluwd7B5inRJia1oO0Dp52MpSItqi8Z0zQbQDys=";
  patchDir = ./vendor;
}