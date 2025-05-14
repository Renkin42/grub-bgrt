
# grub-bgrt theme

A theme for GRUB2 which uses your system's UEFI logo (aka BGRT).

## Installation

```sh
    sudo ./install.sh	# Fetches your BGRT, adjusts the theme to suit and installs it.
    echo GRUB_THEME=grub-bgrt | sudo tee -a /etc/default/grub
    sudo update-grub
```

## Font

To change the font in the theme, try something like:

```sh
	grub-mkfont -o dejavu_12.pf2 -a -s 12 /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
```

(-a adds antialiasing, -s 12 sets the size to 12). Don't forget to update the `theme.txt.in` as well.

## Installation on NixOS

Nix installation requires flake support. See [the NixOS Wiki](https://wiki.nixos.org/wiki/Flakes) for more 
information. Once you have enableed flake support add the following to your configuration:
```flake.nix  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    grub-bgrt.url = "github:Renkin42/grub-bgrt";
  };
  outputs = { self, nixpkgs, grub-bgrt }:
    ...
    modules = [
      grub-bgrt.nixosModules.default
      ...
    ];
```

```configuration.nix
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub-bgrt.enable = true;
  boot.loader.grub-bgrt.bgrtDir = "${./bgrt}";
  boot.loader.efi.canTouchEfiVariables = true;
```

`./bgrt` should be a local copy of `/sys/firmware/acpi/bgrt` within your flake directory. for example
you can run this command withing the directory of your `flake.nix`. Adjust the path accordingly if you
copy it elsewhere or dont have `configuration.nix` in the same directory. 

```sh
  cp -r /sys/firmware/acpi/bgrt .
```

## License

All the files in this project are distributed under the [GNU General Public License](./LICENSE).

## Author

Paul Saunders

## Forked from

https://github.com/fghibellini/arch-silence
