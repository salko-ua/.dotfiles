{
  imports = [
    ./hardware-configuration.nix
    # Wipe-on-boot root. Desktop only -- see manual-modules/README.md.
    ../../manual-modules/impermanence
  ];

  networking.hostName = "salo-pc";

  # Fresh install on 26.05 — never change after install.
  system.stateVersion = "26.05";

  # RX 9070 XT — in-kernel amdgpu, no driver packages needed.
  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true; # early KMS

  # 1920x1080@180 is reduced-blanking: a 150us vblank, too tight to hide an MCLK
  # switch, so transitions leak on screen as garbage scanlines. Pinning costs idle
  # power, not wear -- same clock the memory runs at under load. Proper fix is a
  # custom EDID (htotal 2000 / vtotal 1190 -> 514us). Revert live with
  # `systemctl stop amdgpu-pin-mclk`.
  #
  # amdgpu.ppfeaturemask=0xfff7bffd is a no-op here: smu_v14 owns clocks in
  # firmware and never sees the legacy powerplay mask. Go through the SMU instead.
  systemd.services.amdgpu-pin-mclk = {
    description = "Pin amdgpu VRAM clock to avoid MCLK-switch display artifacts";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for d in /sys/class/drm/card*/device; do
        [ -e "$d/pp_dpm_mclk" ] || continue
        # Not hardcoded 5: the level count shifts across amdgpu releases.
        top=$(grep -o '^[0-9]\+' "$d/pp_dpm_mclk" | tail -n1)
        # Writes are rejected unless manual comes first.
        echo manual > "$d/power_dpm_force_performance_level"
        echo "$top" > "$d/pp_dpm_mclk"
      done
    '';
    preStop = ''
      for d in /sys/class/drm/card*/device; do
        [ -e "$d/power_dpm_force_performance_level" ] || continue
        echo auto > "$d/power_dpm_force_performance_level"
      done
    '';
  };

  # Resume resets the level to auto, and an active oneshot will not re-run itself.
  powerManagement.resumeCommands = "systemctl restart amdgpu-pin-mclk.service";
}
