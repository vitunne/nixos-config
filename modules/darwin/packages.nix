{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  jq
  yq
  kubectl
  kubectx
  kubernetes-helm
  dive
  minio-client
]
