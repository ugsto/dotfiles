{
  lib,
  stdenv,
  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcp-remote";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "punkpeye";
    repo = "mcp-remote";
    rev = "b529ea1356aa348b250e77f626ca3347ebae3de5"; # v${finalAttrs.version}
    hash = "sha256-pykcdEoim08npawyWOXf8PR60f+SedxEuuynWSwj5t0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-UHOtDrX3aIBilt0iw7uwZ4pB0elcMY57cvv4syZ18L4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  # Runtime needs only the production dependencies next to dist/.
  installPhase = ''
    runHook preInstall
    pnpm prune --prod --ignore-scripts
    mkdir -p $out/lib/mcp-remote $out/bin
    cp -r dist node_modules package.json $out/lib/mcp-remote/
    for b in proxy client; do
      name=mcp-remote; [ $b = client ] && name=mcp-remote-client
      printf '#!/bin/sh\nexec %s %s "$@"\n' ${lib.getExe nodejs} $out/lib/mcp-remote/dist/$b.js > $out/bin/$name
      chmod +x $out/bin/$name
    done
    runHook postInstall
  '';

  meta = {
    description = "Bridge from local stdio MCP clients to remote OAuth-protected MCP servers";
    homepage = "https://github.com/punkpeye/mcp-remote";
    license = lib.licenses.mit;
    mainProgram = "mcp-remote";
  };
})
