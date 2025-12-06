{
  description = "A custom build of dwm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    architectures = ["x86_64-linux" "aarch64-linux"];
  in {
    overlays.default = final: prev: {
      dwm-nk = prev.dwm.overrideAttrs (oldAttrs: {
        src = self;
      });
    };

    packages = nixpkgs.lib.genAttrs architectures (system: {
      default =
        (import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        }).dwm-nk;
    });

    devShells = nixpkgs.lib.genAttrs architectures (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [xorg.libX11 xorg.libXft xorg.libXinerama gcc bear];
      };
    });
  };
}
