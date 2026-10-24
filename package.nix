{
  fetchFromGitHub,
  fetchgit,
  python3,
  pyproject-nix,
}:
let
  src = fetchFromGitHub {
    owner = "Evolution0";
    repo = "bandcamp-dl";
    rev = "master";
    hash = "sha256-QzZl10YHPvJPH7ufSJxF2xhNya2khgbhN93OFJAEUFg=";
  };

  unicode-slugify-src = fetchgit {
    url = "https://github.com/dnicolson/unicode-slugify";
    rev = "a18826f440d0b74e536f5e32ebdcf30e720f20d8";
    sha256 = "sha256-kxyJaHxd/cMHiycfQHJqSsecT+eMkkRqO+OMSzbtjmE=";
  };

  python = python3.override {
    packageOverrides = final: prev: {
      unicode-slugify = final.buildPythonPackage {
        pname = "unicode-slugify";
        version = "0.1.5-unstable-2024-01-27";
        src = unicode-slugify-src;
        pyproject = true;
        build-system = [ final.setuptools ];
        propagatedBuildInputs = with final; [
          six
          unidecode
        ];
      };
    };
  };

  project = pyproject-nix.lib.project.loadPyproject {
    projectRoot = src;
  };

  attrs = project.renderers.buildPythonPackage {
    python = python;
  };
in
python.pkgs.buildPythonApplication (
  attrs
  // {
    inherit src;
    postPatch = ''
      substituteInPlace pyproject.toml --replace-fail 'setuptools>=84.0.0' 'setuptools>=61.0'
      substituteInPlace pyproject.toml --replace-fail '"urllib3 >= 2.8.0"' '"urllib3 >= 2.7.0"'
    '';
    build-system = [
      python.pkgs.setuptools
      python.pkgs.wheel
    ];
    nativeBuildInputs = [
      python.pkgs.setuptools
      python.pkgs.wheel
    ];
  }
)
