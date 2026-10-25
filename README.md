# nix flake for bandcamp-dl

This flake fetches the `master` branch of [bandcamp-dl](https://github.com/Evolution0/bandcamp-dl) due to infrequent tagged releases.

## usage

### nix CLI

```shell
nix run github:AimPizza/bandcamp-dl-flake
```

### nixos configuration

add input to `flake.nix`:

```nix
inputs.bandcamp-dl.url = "github:AimPizza/bandcamp-dl-flake";
```

use as package, importing the input:

```nix
environment.systemPackages = [ inputs.bandcamp-dl.packages.${pkgs.stdenv.hostPlatform.system}.default ];
```

not shown: use overlay

## thank you

- [nolight132/photocraft-flake](https://github.com/nolight132/photocraft-flake) for the flake structure
- [4evy/nixcord](https://github.com/4evy/nixcord) for great documentation on flake usage

