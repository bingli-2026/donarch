# BD-Configs

**Black Don's Dots** for Hyprland & Niri with DankMaterialShell

A complete, ready-to-use desktop environment configuration for Arch Linux featuring modern Wayland compositors with Catppuccin Design aesthetics.


If you enjoy what I do, consider supporting me on Ko-fi! Every little bit means the world! https://ko-fi.com/theblackdon


## Features

- **Dual Compositor Support**: Choose between Hyprland (dynamic tiling) or Niri (scrollable tiling), or install both
- **DankMaterialShell (DMS)**: Beautiful Material Design shell with bar, notifications, launcher, and lock screen
- **Catppuccin Mocha Theme**: Consistent theming across all applications (GTK, Qt, terminal, shell)
- **DMS-Greeter**: Elegant display manager for seamless session switching
- **Curated Applications**: kitty terminal, fish shell, nemo file manager, and optional apps
- **Symlinked Configs**: Easy to update - edit files in the repo and changes apply immediately

## Screenshots

![BD-Configs Desktop](assets/screenshots/desktop-overview.png)
*BD-Configs running with Niri, DankMaterialShell, and Catppuccin Mocha theme*

## Requirements

- **OS**: Arch Linux or Arch-based distribution (CachyOS, EndeavourOS, etc.)
- **AUR Helper**: paru or yay
- **Internet Connection**: Required for package installation

## Installation

### Quick Install

```bash
git clone https://gitlab.com/theblackdon/bd-configs.git
cd bd-configs
chmod +x install.sh
./install.sh
```

The installer will guide you through:
1. System compatibility checks
2. Compositor selection (Hyprland, Niri, or both)
3. Optional application selection
4. Package installation
5. Configuration deployment
6. Theme application
7. Display manager setup

### What Gets Installed

**Core Packages:**
- Build tools (git, cmake, meson, gcc, base-devel)
- jq and dialog for the installer

**Compositor Packages:**
- Hyprland: hyprland, hypridle, xdg-desktop-portals, screenshot tools, pyprland
- Niri: niri, waybar, mako, fuzzel, swayidle, screenshot tools

**Theme Packages:**
- Catppuccin GTK theme (Mocha variant)
- Tela purple icon theme
- Bibata Modern Ice cursor theme
- Qt5/Qt6 Wayland support and theming
- Kvantum theme engine

**DMS & Display Manager:**
- DankMaterialShell (dms-shell-git)
- Quickshell (DMS dependency)
- greetd + greetd-dms-greeter-git

**Required Applications:**
- kitty (terminal)
- fish (shell)
- nemo (file manager)
- fastfetch (system info)

**Optional Applications:**
- Zen Browser (privacy-focused browser)
- Zed (modern code editor)
- Helix (modal text editor)

## Post-Installation

### First Login

1. **Reboot your system**
2. **At the DMS-greeter login screen:**
   - Select your preferred session (Hyprland or Niri)
   - Log in with your credentials
3. **Enjoy your beautiful desktop!**

### Key Bindings

#### Universal (Both Compositors)
- `Super + Space` - Application launcher
- `Super + T` or `Super + Return` - Terminal (kitty)
- `Super + Ctrl + Return` - Floating Terminal (kitty)
- `Super + Q` - Close window
- `Super + F` - File manager (nemo)
- `Super + B` - Browser (if installed)
- `Super + Shift + R` - Reload compositor config
- `Super + Alt + L` - Lock screen
- `Super + Ctrl + Up or Down` - Move relative workspaces

#### Media Keys
- `XF86AudioRaiseVolume` - Volume up
- `XF86AudioLowerVolume` - Volume down
- `XF86AudioMute` - Toggle mute
- `XF86MonBrightnessUp` - Brightness up
- `XF86MonBrightnessDown` - Brightness down


## Customization

All configuration files are symlinked from the repository, making customization easy:

```bash
cd bd-configs

# Edit compositor configs
nano configs/hyprland/hypr/hyprland.conf
nano configs/niri/niri/config.kdl

# Edit terminal config
nano configs/shared/kitty/kitty.conf

# Edit shell config
nano configs/shared/fish/config.fish

# Edit DMS settings
nano configs/shared/DankMaterialShell/settings.json
```

Changes take effect immediately (or after reloading the compositor with `Super+Shift+R`).

### Changing Wallpapers

Replace the wallpaper at:
```bash
assets/wallpapers/wallpaper.png
```

Or edit the compositor config to point to your own wallpaper.

## Troubleshooting

### DMS-greeter doesn't start
```bash
# Check greetd status
sudo systemctl status greetd

# Check greetd config
cat /etc/greetd/config.toml

# Restart greetd
sudo systemctl restart greetd
```

### Themes not applying
```bash
# Reapply themes manually
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-mauve-standard+default'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-purple-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
```

### DMS shell not starting
```bash
# Check if DMS is running
pgrep -a dms

# Start DMS manually
dms run
```

### Compositor won't start
```bash
# For Hyprland
Hyprland

# For Niri
niri-session

# Check logs
journalctl --user -xe
```

## Uninstallation

To remove bd-configs and restore your system:

```bash
# Stop and disable greetd
sudo systemctl disable --now greetd

# Restore original configs (if you made a backup)
rm -rf ~/.config
mv ~/.config.backup-YYYYMMDD_HHMMSS ~/.config

# Remove symlinks
unlink ~/.config/hypr
unlink ~/.config/niri
unlink ~/.config/DankMaterialShell
# ... etc

# Optionally remove packages
sudo pacman -R hyprland niri dms-shell-git greetd-dms-greeter-git
```

## Directory Structure

```
bd-configs/
├── install.sh              # Main installer script
├── README.md               # This file
├── lib/                    # Installer library functions
│   ├── utils.sh           # Utility functions
│   ├── checks.sh          # System checks
│   ├── packages.sh        # Package installation
│   ├── dotfiles.sh        # Config deployment
│   ├── themes.sh          # Theme application
│   └── greeter.sh         # Display manager setup
├── configs/               # Configuration files
│   ├── shared/            # Shared between compositors
│   ├── hyprland/          # Hyprland-specific
│   └── niri/              # Niri-specific
├── packages/              # Package lists
└── assets/                # Wallpapers and images
```

## Credits

- **[DankMaterialShell (DMS)](https://github.com/dburian/DankMaterialShell)** - Beautiful Material Design shell for Wayland
- **[Hyprland](https://hyprland.org/)** - Dynamic tiling Wayland compositor
- **[Niri](https://github.com/YaLTeR/niri)** - Scrollable-tiling Wayland compositor
- **[Catppuccin](https://github.com/catppuccin/catppuccin)** - Soothing pastel theme
- **[greetd](https://git.sr.ht/~kennylevinsen/greetd)** - Minimal display manager

## License

MIT License - Feel free to use and modify as you wish!

## Contributing

Issues and pull requests welcome! If you find bugs or have suggestions for improvements, please open an issue on GitLab.

---

**Made with ❤️ by TheBlackDon**
