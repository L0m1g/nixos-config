{lib, ...}: {
  # Ajoute dans l’initrd sans auto-référencer l’option
  boot = {
    initrd.kernelModules = lib.mkAfter [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    # Ajoute les params IOMMU proprement
    kernelParams = lib.mkAfter [
      "amd_iommu=on"
      "iommu=pt"
    ];

    # Valeur par défaut (sans référencer config.*)
    kernel.sysctl."vm.nr_hugepages" = lib.mkDefault 1024;
  };
}
