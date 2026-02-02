THEME=dark

get_system_theme() {
  # macos
  if [[ "$(uname)" == "Darwin" ]]; then
    [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]] \
      && echo dark || echo light

  # WSL (untested)
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    local val
    val=$(powershell.exe -Command \
      "(Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize').AppsUseLightTheme" \
      | tr -d '\r')
    [[ "$val" == "0" ]] && echo dark || echo light

  # KDE plasma (untested)
  elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
    local scheme
    scheme=$(kreadconfig5 --group General --key ColorScheme 2>/dev/null \
          || kreadconfig6 --group General --key ColorScheme 2>/dev/null)
    [[ "${scheme,,}" == *"dark"* ]] && echo dark || echo light

  else
    echo dark
  fi
}

theme() {
  local target="$1"
  if [[ "$target" == "system" ]]; then
    target="$(get_system_theme)"
  elif [[ -z "$target" ]]; then
    [[ "$THEME" == "dark" ]] && target=light || target=dark
  fi
  THEME="$target"
  if [[ "$target" == "dark" ]]; then
    base16_tokyo-night-terminal-dark
  else
    base16_tokyo-night-terminal-light
  fi
}

