{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
}:

let
  filelock = python3.pkgs.buildPythonPackage {
    pname = "filelock";
    version = "3.29.4";
    pyproject = true;
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/e6/dc/be6cbe99670cd6e4ad387123647cb08e0c32975e223f82551e914c5568a6/filelock-3.29.4.tar.gz";
      sha256 = "10cdb3656fc44541cdf30652a93fb10ec6b05325620eb316bd26893e4201538a";
    };
    build-system = with python3.pkgs; [
      hatchling
      hatch-vcs
    ];
  };

  jupyter-mimetypes = python3.pkgs.buildPythonPackage {
    pname = "jupyter-mimetypes";
    version = "0.2.0";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/72/45/cb4671e13fed39f721066ad1a00714d4b607982b8d3e97a25f836198d1df/jupyter_mimetypes-0.2.0-py3-none-any.whl";
      sha256 = "e6dcd989258e3fc944365b656d9173191517e0e393bd878e97ce500e5b388527";
    };
    propagatedBuildInputs = with python3.pkgs; [
      pyarrow
      typing-extensions
    ];
  };

  jupyter-kernel-client = python3.pkgs.buildPythonPackage {
    pname = "jupyter-kernel-client";
    version = "unstable-2026-06-27";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "googlecolab";
      repo = "jupyter-kernel-client";
      rev = "f18e982c3265df5e923aa9def101ab3fd737e139";
      hash = "sha256-A2c78qPdY5HIdAmcr1PP3UbtMty84zrNnvZItu7Rk+E=";
    };
    build-system = with python3.pkgs; [
      hatchling
    ];
    dependencies = with python3.pkgs; [
      jupyter-core
      jupyter-client
      jupyter-mimetypes
      requests
      traitlets
      typing-extensions
      websocket-client
    ];
  };

in
python3.pkgs.buildPythonApplication {
  pname = "google-colab-cli";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlecolab";
    repo = "google-colab-cli";
    rev = "1bdb55b6dc3c6ad2300a62305140e17cb25933d6";
    hash = "sha256-IvktHN9er+VLTwKXCl+pKfwrhckJ/5xF7yOZF52Vi64=";
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "typer"
  ];

  dependencies = [
    filelock
    jupyter-kernel-client
  ]
  ++ (with python3.pkgs; [
    click
    google-auth
    google-auth-oauthlib
    html2text
    nbformat
    packaging
    prompt-toolkit
    pydantic
    pygments
    requests
    rich
    typer
    typing-extensions
    websocket-client
  ]);

  doCheck = false;

  meta = with lib; {
    description = "Official CLI for interacting with Google Colab";
    homepage = "https://github.com/googlecolab/google-colab-cli";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "colab";
  };
}
