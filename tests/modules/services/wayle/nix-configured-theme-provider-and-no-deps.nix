{ config, pkgs, ... }:
let
  inherit ((import ./lib.nix { inherit config pkgs; }).asserts) awwwInstalled packageInstalled;
in
{
  services.wayle = {
    enable = true;
    package = config.lib.test.mkStubPackage { name = "wayle"; };
    settings = {
      styling.theme-provider = "matugen";
    };
    autoInstallDependencies = false;
  };

  nmt.script = ''
    assertFileContent \
      "home-files/.config/wayle/config.toml" \
      ${./nix-configured-theme-provider-config.toml}
  '';

  assertions = [
    (awwwInstalled false)
    (packageInstalled "matugen" false)
    (packageInstalled "wallust" false)
    (packageInstalled "pywal" false)
  ];
}
