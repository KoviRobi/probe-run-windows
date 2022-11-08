{
  description = "Probe-run cross-compiled for windows";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [ self.overlay ]; };
    in
    {
      overlay = final: prev: {
        libusb1 =
          prev.libusb1.overrideAttrs (attrs: {
            dontAddDisableDepTrack = attrs.dontAddDisableDepTrack or final.stdenv.hostPlatform.isWindows;
          });

        probe-run = prev.probe-run.overrideAttrs (attrs: {
          meta.platforms = attrs.meta.platforms or [ ] ++ [ "x86_64-windows" ];
        });
      };

      packages.x86_64-linux.default = pkgs.pkgsCross.mingwW64.probe-run;
    };
}
