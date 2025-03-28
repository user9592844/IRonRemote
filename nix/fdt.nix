{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "fdt";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gaIVkw/vKriJSRPE9HQQW7U+FPBxKf4Hy27/LV/fJtI=";
  };

  meta = with lib; {
    description = "This python module is usable for manipulation with [Device Tree Data](https://www.devicetree.org/) and primary was created for [imxsb tool](https://github.com/molejar/imxsb)";
    homepage = "https://pypi.org/project/fdt/";
    license = licenses.apsl20;
  };
}
