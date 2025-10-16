#### do the magic
##### nix-wsl
```
sudo nixos-rebuild switch --flake github:vitunne/nixos-config/personal#x86_64-linux
```

##### mac
```
# install deps
xcode-select --install

# select no to install upstream nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# build nix darwin
nix build nix-darwin

# run flake
sudo ./result/bin/darwin-rebuild switch --flake "github:vitunne/nixos-config/personal#aarch64-darwin" && sudo rm /result/bin/darwin-rebuild
```
