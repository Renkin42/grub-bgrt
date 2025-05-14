{
  description = "A simple flake to add the GRUB 2 BGRT theme on NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
     let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    with nixpkgs.lib;
    rec {
      nixosModules.default = { config, ... }:
        let
	  cfg = config.boot.loader.grub-bgrt;
	  grub-bgrt = pkgs.stdenv.mkDerivation {
	    name = "grub-bgrt";
	    src = "${self}";
	    buildInputs = [ pkgs.imagemagick ];
	    installPhase = "bash ./install.sh -b ${/sys/firmware/acpi/bgrt} -d $out";
	  };
	in
	rec {
	  options = {
	    boot.loader.grub-bgrt = {
	      enable = mkOption {
	        default = true;
		example = true;
		type = types.bool;
		description = "Enable grub bgrt theme";
	      };
	    };
	  };
	  config = mkIf cfg.enable (mkMerge [{
	    environment.systemPackages = [ grub-bgrt ];
	    boot.loader.grub.theme = "${grub-bgrt}/grub-brgt/";
	  }]);
	};
    };
}
