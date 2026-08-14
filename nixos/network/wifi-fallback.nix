# Use wifi only as a fallback: disable it whenever a wired link is up, re-arm it
# when the cable goes away.
#
# Worth doing beyond the tidiness of one default route: on salo-pc the wifi
# (rtw89_8922ae) and the bluetooth radio are the same RTL8922 combo chip sharing
# antennas, so an idle-but-associated wifi link is pure contention against A2DP
# audio -- see nixos/devices/bluetooth.nix for the firmware resets that caused.
{pkgs, ...}: {
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "wifi-only-without-ethernet" ''
        iface="$1"
        action="$2"
        nmcli=${pkgs.networkmanager}/bin/nmcli

        case "$action" in
          up | down) ;;
          *) exit 0 ;;
        esac

        # Ignore tun0, docker0, virbr0 and friends -- only real links matter.
        iface_type=$($nmcli -t -f DEVICE,TYPE device | sed -n "s|^$iface:||p")
        case "$iface_type" in
          ethernet | wifi) ;;
          *) exit 0 ;;
        esac

        # Prefix match, NOT `connected$`: device states carry suffixes such as
        # "connected (site only)" and "connected (externally)". Anchoring on the
        # end made a transient connectivity re-check look like "no cable", which
        # flapped wifi up and down every ~90s.
        wired_up() {
          $nmcli -t -f TYPE,STATE device | grep -q '^ethernet:connected'
        }

        for dev in $($nmcli -t -f TYPE,DEVICE device | sed -n 's/^wifi://p'); do
          dev_state=$($nmcli -t -f DEVICE,STATE device | sed -n "s|^$dev:||p")

          if wired_up; then
            # Toggling the device's autoconnect is what actually keeps wifi down:
            # a bare `device disconnect` gets undone by NM's own autoconnect
            # retry a minute later.
            $nmcli device set "$dev" autoconnect no || true
            case "$dev_state" in
              disconnected | unavailable | unmanaged) ;;
              *) $nmcli -w 5 device disconnect "$dev" || true ;;
            esac
          else
            $nmcli device set "$dev" autoconnect yes || true
            # Re-arming autoconnect is not enough on its own: the earlier
            # `device disconnect` leaves NM holding a "manual disconnect" block
            # that autoconnect does not clear, so wifi would never come back
            # after unplugging. Ask for activation explicitly.
            #
            # -w 0 makes that fire-and-forget. Without it nmcli waits up to 90s
            # for the association, and dispatcher scripts are serialised, so it
            # stalls every later network event.
            case "$dev_state" in
              connected*) ;;
              *) $nmcli -w 0 device connect "$dev" || true ;;
            esac
          fi
        done
      '';
    }
  ];

  # Deliberately not `radio wifi off`: that flag lives in NetworkManager.state
  # and persists, so a later boot with no cable would come up with the radio
  # disabled and no network at all.
}
