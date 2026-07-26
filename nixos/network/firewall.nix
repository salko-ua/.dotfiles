{
  # Fix Discord voice (DTLS error) while on the work VPN.
  # The VPN is split-tunnel, but Discord's WebRTC engine binds a media socket
  # to the VPN-assigned address (172.16.17.32/28) and tries to reach Discord's
  # public servers through it, which stalls the DTLS handshake. Reject any packet
  # using that source that isn't actually leaving via tun0 so Discord fails fast
  # and falls back to WiFi. Normal traffic (WiFi src) is untouched.
  networking.firewall.extraCommands = ''
    iptables -A OUTPUT -s 172.16.17.32/28 ! -o tun0 -j REJECT
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D OUTPUT -s 172.16.17.32/28 ! -o tun0 -j REJECT 2>/dev/null || true
  '';
}
