{
  lib,
  buildNpmPackage,
  fetchurl,
  makeWrapper,
  nodejs,
}:

let
  version = "0.1.5-rc.1";
  lockfile = ./package-lock.json;
in
buildNpmPackage {
  pname = "deepseek-harness";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-${version}.tgz";
    hash = "sha512-rmNmzQCg3oIc1z8xH7izRSOuy1TNzq+/NILyfM+7e8DKOyV+yBtg47WEsqR2SiIe1ATec3L/rUa1YhIcfQ2XEg==";
  };

  dontNpmBuild = true;
  postPatch = ''
    cp ${lockfile} package-lock.json
    substituteInPlace package.json \
      --replace-fail '"@deepseek-ai/dsh-experimental-code-runtime-python": "^0.1.5-rc.1",' ""
  '';

  npmDepsHash = "sha256-Ffmv+tV3QQ2UexvKswd0HFxLarSkMzOPOSZ00Dmf7UI=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    bin=$out/lib/node_modules/@deepseek-ai/dsh/lib/bin.js
    makeShellWrapper "${lib.getExe' nodejs "node"}" "$out/bin/dsh" \
      --add-flag "--expose-internals" \
      --add-flag "$bin"
  '';

  meta = with lib; {
    description = "DeepSeek Harness (dsh) CLI — plugin-based agent harness with browser UI";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "dsh";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
