{
  # Mic/output DSP on PipeWire. GUI: `easyeffects`, runs as background service.
  # Mic preset "mic-clean" (RNNoise): select once in GUI Input tab, it sticks.
  services.easyeffects = {
    enable = true;
    extraPresets = {
      mic-clean = {
        input = {
          blocklist = [];
          "plugins_order" = ["rnnoise#0"];
          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = false;
            "input-gain" = 0.0;
            "model-name" = "";
            "output-gain" = 0.0;
            release = 20.0;
            "vad-thres" = 50.0;
            wet = 0.0;
          };
        };
      };
    };
  };
}
