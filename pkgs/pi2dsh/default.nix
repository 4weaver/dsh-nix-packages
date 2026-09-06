# pi2dsh — Pi Host ABI bridge for dsh.
# Built from the npm registry tarball via lib.mkNpmPlugin.
# `typescript` is a peer at runtime (pi2dsh imports it); only its own npm
# deps + typescript-promoted are installed here. The @deepseek-ai/dsh-*
# peers resolve against the profile's flat node_modules (the dsh core).
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "pi2dsh";
  version = "0.24.0";
  tarball = fetchurl {
    url = "https://registry.npmjs.org/pi2dsh/-/pi2dsh-0.24.0.tgz";
    sha256 = "sha256-e3ANu7xWR0Y6LDbywoXkVindpEF1PmfoaZpf7i70TO0=";
  };
  npmDepsHash = "sha256-tJdGvcAkN1Y8RP6/m4/5mFWFsy59sYsUiYGFUAQKhbg=";
  patchDir = ./vendor;
}