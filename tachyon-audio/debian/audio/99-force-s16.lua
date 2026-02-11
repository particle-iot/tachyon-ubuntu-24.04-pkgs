rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.platform-soc_0_sound.*" },
    },
  },
  apply_properties = {
    ["api.alsa.format"] = "S16_LE",
    ["audio.format"] = "S16LE",
    ["audio.rate"] = 48000,
  },
}

table.insert(alsa_monitor.rules, rule)
