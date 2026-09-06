# dsh-llm-bifrost — bifrost-routed pi-ai LLM adapter for dsh (stamps every
# outgoing request with the x-bf-eh-x-session-id header).
#
# Pure host plugin: no client half, no dsh.bundle → the consuming profile
# mounts it via a cordis.patch.yml insert. lib/ is COMMITTED to the source
# repo (no build step needed; buildScript omitted).
#
# All ten @deepseek-ai workspace peers resolve from the core's flat platform
# node_modules, and @deepseek-ai/schemastery is a dependency of the source
# manifest that the shared top-level `schemastery` bundle already provides
# (single cosmokit instance) — both stripped in vendor/. The one real
# third-party runtime dep, @earendil-works/pi-ai, stays and is installed here.
{
  mkNpmPlugin,
  fetchurl,
}:
mkNpmPlugin {
  name = "dsh-llm-bifrost";
  version = "0.0.1";
  tarball = fetchurl {
    url = "https://codeload.github.com/4weaver/dsh-llm-bifrost/tar.gz/8b83d37805cb17c4c2fdd4df61a2590cff85b83c";
    sha256 = "sha256-RDM/c9xrUdJLYVND9fy99tdswkRQ2/w7RilpJe9x9EQ=";
  };
  npmDepsHash = "sha256-XXmdc0S7K6lJ1Wrj/3mzcTG8PsNVqrMfYT4gAgsqZMk=";
  patchDir = ./vendor;
}
