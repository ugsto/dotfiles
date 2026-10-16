{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "affine-mcp-server";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "DAWNCR0W";
    repo = "affine-mcp-server";
    rev = "a4cc2ef87684b46326b406d572b8c2ef09f3f2ca"; # v${finalAttrs.version}
    hash = "sha256-c1tc7Ic7KeRIsUZCyVFu0PEpTw06sFm6D/Qs4UqKe98=";
  };

  npmDepsHash = "sha256-uVAMo3/+i1BXyJdv27ZUXpI5Yb4s+JfII9ev/nQKLTQ=";

  # `prepublishOnly` runs the whole test suite; only the compile step is needed.
  npmBuildScript = "build";

  meta = {
    description = "Model Context Protocol server for AFFiNE workspaces and documents";
    homepage = "https://github.com/DAWNCR0W/affine-mcp-server";
    license = lib.licenses.mit;
    mainProgram = "affine-mcp";
  };
})
