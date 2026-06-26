{
  lib,
  python3,
}:

let
  borb = python3.pkgs.borb.overridePythonAttrs (oldAttrs: {
    doCheck = false;
    nativeCheckInputs = [ ];
    disabledTestPaths = [ ];
  });
in
python3.pkgs.buildPythonApplication rec {
  pname = "vastai";
  version = "1.1.1";
  pyproject = true;

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-9or69tQg1lim1dvtum2LhLiCfqWxfCfbnkh4TwdSdgY=";
  };

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "borb"
    "cryptography"
    "psutil"
    "pycares"
  ];

  dependencies = [
    python3.pkgs.xdg
    borb
    python3.pkgs.requests
    python3.pkgs.python-dateutil
    python3.pkgs.urllib3
    python3.pkgs.pyparsing
    python3.pkgs.aiohttp
    python3.pkgs.aiodns
    python3.pkgs.pycares
    python3.pkgs.anyio
    python3.pkgs.psutil
    python3.pkgs.pycryptodome
    python3.pkgs.argcomplete
    python3.pkgs.curlify
    python3.pkgs.rich
    python3.pkgs.cryptography
    python3.pkgs.pillow
    python3.pkgs.transformers
  ];

  doCheck = false;

  meta = with lib; {
    description = "CLI and SDK for Vast.ai GPU Cloud Service";
    homepage = "https://vast.ai";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "vastai";
  };
}
