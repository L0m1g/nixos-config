{lib, ...}: {
  boot.kernelModules = lib.mkAfter ["kvm-amd"];
}
