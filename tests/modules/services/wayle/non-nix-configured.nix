{ config, pkgs, ... }:
let
  inherit ((import ./lib.nix { inherit config pkgs; }).asserts) awwwInstalled packageInstalled;
in
{
  services.wayle = {
    enable = true;
    package = config.lib.test.mkStubPackage { name = "wayle"; };
    settings = { };
  };

  # When services.wayle.settings = {}, we expect that no config file is
  # created.
  nmt.script = ''
    assertPathNotExists "home-files/.config/wayle/config.toml"
  '';

  # When services.wayle.settings = {}, we expect that all of wayle's
  # dependencies are installed.
  assertions = [
    (awwwInstalled true)
    (packageInstalled "matugen" true)
    (packageInstalled "wallust" true)
    (packageInstalled "pywal" true)
  ];
}
