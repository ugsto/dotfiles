{
  lib,
  buildNpmPackage,
  fetchurl,
  makeWrapper,
  stdenv,
  autoPatchelfHook,
}:

let
  nodejs = stdenv.mkDerivation {
    pname = "nodejs-official";
    version = "24.21.0";
    src = fetchurl {
      url = "https://nodejs.org/dist/v24.21.0/node-v24.21.0-linux-x64.tar.xz";
      hash = "sha256-/Y5Z1aURUQ9qKYr7VI8Yx9KxvkBNi0on2U++SfVsstY=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
    dontBuild = true;
    installPhase = "install -Dm755 bin/node $out/bin/node";
    meta.platforms = [ "x86_64-linux" ];
  };
  version = "0.2.1-rc.2";
  lockfile = ./package-lock.json;
in
buildNpmPackage {
  pname = "deepseek-harness";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-${version}.tgz";
    hash = "sha512-tvY+yhfKRifthbqPe/OK0AYxM5ZkvqfYq/jMYgJcEUxiRRL1Vwra3Ti5TB6AXgSWQdiPHYh/Vp6SJa9yHwMNuw==";
  };

  dontNpmBuild = true;
  postPatch = ''
    cp ${lockfile} package-lock.json
    substituteInPlace package.json \
      --replace-fail '"@deepseek-ai/dsh-experimental-ptc-runtime-python": "0.2.1-rc.2",' ""
  '';

  npmDepsHash = "sha256-o+9n9/i4LzvW+iODfICyMV0ilbYdimDZnwR7nSC6R5Y=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    bin=$out/lib/node_modules/@deepseek-ai/dsh/lib/bin.js
    makeShellWrapper "${lib.getExe' nodejs "node"}" "$out/bin/dsh" \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
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
