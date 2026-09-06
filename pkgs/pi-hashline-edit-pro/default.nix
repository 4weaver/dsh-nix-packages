# pi-hashline-edit-pro — hash-anchored file editing for dsh via pi2dsh.
# Ships as a TS source tarball (main: index.ts, no dist); buildNpmPackage
# installs its deps without compiling.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "pi-hashline-edit-pro";
  version = "2.8.4";
  tarball = fetchurl {
    url = "https://registry.npmjs.org/pi-hashline-edit-pro/-/pi-hashline-edit-pro-2.8.4.tgz";
    sha256 = "sha256-muyNLDSRAXRy95161r9GrK+jat5FC+DxyprBJtPwF7Y=";
  };
  npmDepsHash = "sha256-XXTSCLjvb5UbVqgA00Hr//WQ7KG6puedOpFy+vXh2I4=";
  patchDir = ./vendor;
}