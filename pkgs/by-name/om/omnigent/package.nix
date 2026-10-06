{
  lib,
  python3,
  fetchurl,
}:

let
  version = "0.16.0";

  cel-python = python3.pkgs.buildPythonPackage {
    pname = "cel-python";
    version = "0.5.0";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/1e/f8/38812adc3f787c2c2e8ba56f524185ed379656c10b40347a32796ba61c08/cel_python-0.5.0-py3-none-any.whl";
      hash = "sha256-0PhQCLiWVcK7GNeX0vo/lvLtgPSjtDsOgTjGZGWB5fY=";
    };
    dependencies = with python3.pkgs; [
      google-re2
      jmespath
      lark
      pendulum
      pyyaml
    ];
    doCheck = false;
  };

  omnigent-client = python3.pkgs.buildPythonPackage {
    pname = "omnigent-client";
    inherit version;
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d9/d9/98ae235e2d64d533f7a0ea1effbfcf82bf16ba4ade1be69e8fa37ed9eba5/omnigent_client-0.16.0-py3-none-any.whl";
      hash = "sha256-d9Xy1/6Y04jk/HVt+eJgj+6hWXHoOetZri+lphtJCFo=";
    };
    nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];
    pythonRemoveDeps = [ "omnigent" ];
    dependencies = with python3.pkgs; [
      httpx
      pydantic
    ];
    doCheck = false;
  };

  omnigent-ui-sdk = python3.pkgs.buildPythonPackage {
    pname = "omnigent-ui-sdk";
    inherit version;
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/29/03/85f53f5aac2a9ae9bc3713fbadbd26b1c0f93d6c8ba914ce671b911ed821/omnigent_ui_sdk-0.16.0-py3-none-any.whl";
      hash = "sha256-XllBHaOwZfjf4HqfBvpRzX/ICj6W2DrBdzUyrbbYg+0=";
    };
    dependencies = [
      omnigent-client
    ]
    ++ (with python3.pkgs; [
      prompt-toolkit
      pyyaml
      rich
    ]);
    doCheck = false;
  };
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "omnigent";
  inherit version;
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/14/58/c674758c5a93eac2af24f3326cf200fce8a8dffb95696a0181c9a24127a6/omnigent-${version}-py3-none-any.whl";
    hash = "sha256-8P1IHvV/Dn4KUzJQ5FDLlUpuNbwBc+imhb7FibWjP/c=";
  };

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];

  pythonRelaxDeps = true;

  dependencies = [
    cel-python
    omnigent-client
    omnigent-ui-sdk
  ]
  ++ (with python3.pkgs; [
    alembic
    anyio
    argon2-cffi
    cachetools
    certifi
    claude-agent-sdk
    click
    fastapi
    filelock
    ftfy
    httpx
    json5
    keyring
    mcp
    openai
    openai-agents
    opentelemetry-api
    packaging
    pexpect
    pillow
    protobuf
    prompt-toolkit
    psutil
    pydantic
    pyjwt
    pyte
    python-dateutil
    pyyaml
    rich
    sqlalchemy
    starlette
    tiktoken
    tomlkit
    uvicorn
    websockets
    zstandard
  ]);

  doCheck = false;

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "${python3.pkgs.makePythonPath finalAttrs.propagatedBuildInputs}:${placeholder "out"}/${python3.sitePackages}"
  ];

  meta = with lib; {
    description = "Open-source AI agent framework and meta-harness for orchestrating Claude Code, Codex, Cursor and custom agents";
    homepage = "https://omnigent.ai";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "omnigent";
  };
})
