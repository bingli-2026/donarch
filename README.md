# donarch TheBlackDon's Dotfiles

**Don's Arch Configurations** for Niri with Noctalia Shell

A complete, ready-to-use desktop environment configuration for Arch Linux featuring Niri + Noctalia with Catppuccin aesthetics.


If you enjoy what I do, consider supporting me on Ko-fi! Every little bit means the world! https://ko-fi.com/theblackdon


## Features

- **Niri Compositor**: Scrollable-tiling Wayland compositor
- **Noctalia Shell**: Launcher, bar, and desktop shell experience
- **Catppuccin Mocha Theme**: Consistent theming across all applications (GTK, Qt, terminal, shell)
- **ly Display Manager**: Lightweight TTY login manager
- **Curated Applications**: kitty terminal, fish shell, nemo file manager, and optional apps
- **Symlinked Configs**: Easy to update - edit files in the repo and changes apply immediately
- **Optional dcli Integration**: Declarative package management for tracking your system configuration in YAML and git

## Screenshots

![DonArch Desktop](assets/screenshots/desktop-overview.png)
*DonArch running with Niri, Noctalia, and Catppuccin Mocha theme*

## Requirements

- **OS**: Arch Linux or Arch-based distribution (CachyOS, EndeavourOS, etc.)
- **AUR Helper**: paru or yay
- **Internet Connection**: Required for package installation

## Installation

### Quick Install

```bash
git clone https://gitlab.com/theblackdon/donarch.git
cd donarch
./install.sh
```

The installer will guide you through:
1. System compatibility checks
2. Niri compositor installation
3. Optional application selection
4. dcli integration (optional)
5. Package installation
6. Configuration deployment
7. Theme application
8. Display manager setup

### What Gets Installed

**Core Packages:**
- Build tools (git, cmake, meson, gcc, base-devel)
- jq and dialog for the installer

**Compositor Packages:**
- Niri: niri, waybar, mako, fuzzel, swayidle, screenshot tools

**Theme Packages:**
- Catppuccin GTK theme (Mocha variant)
- Tela purple icon theme
- Bibata Modern Ice cursor theme
- Qt5/Qt6 Wayland support and theming
- Kvantum theme engine

**Desktop Shell & Display Manager:**
- Noctalia Shell
- Quickshell
- ly

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
2. **At the login screen:**
   - Select the Niri session
   - Log in with your credentials
3. **Enjoy your beautiful desktop!**

### Key Bindings

#### Niri
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


## dcli Integration (Optional)

DonArch supports optional integration with **dcli** - a declarative package management tool for Arch Linux inspired by NixOS.

### What is dcli?

dcli allows you to:
- Manage all your packages in YAML configuration files
- Track your entire system configuration in git
- Sync your setup across multiple machines
- Organize packages into reusable modules
- Declaratively manage systemd services

### What happens when you enable dcli?

If you choose to install dcli during setup, the installer will:
1. Install `dcli-arch-git` from AUR
2. Create a dcli configuration structure at `~/.config/arch-config`
3. Generate modules for all DonArch packages:
   - `base` - Core dependencies
   - `themes` - Catppuccin Mocha theme packages
   - `shell` - Noctalia + display manager packages
   - `apps` - Terminal, file manager, shell
   - `niri` - Niri compositor
4. Create a host configuration file with all installed packages declared

### Using dcli after installation

```bash
# View your current configuration
dcli status

# Sync packages (install missing, optionally remove extras)
dcli sync

# List all modules
dcli module list

# Enable/disable modules
dcli module enable gaming
dcli module disable development

# Search and install packages
dcli search
dcli install firefox

# Set up git tracking (recommended for multi-machine setups)
dcli repo init

# Edit configurations
dcli edit
```

### Multi-machine setup with dcli

```bash
# On your first machine
dcli repo init              # Initialize git repository
dcli repo push              # Push to your git remote

# On additional machines
dcli repo clone             # Clone your configuration
dcli sync                   # Install all packages from config
```

For more information, visit the [dcli repository](https://gitlab.com/theblackdon/dcli-arch).

## Customization

All configuration files are symlinked from the repository, making customization easy:

```bash
cd donarch

# Edit Niri config
nano configs/niri/niri/config.kdl

# Edit terminal config
nano configs/shared/kitty/kitty.conf

# Edit shell config
nano configs/shared/fish/config.fish

# Edit Noctalia settings
nano configs/shared/noctalia/settings.json
```

Changes take effect immediately (or after reloading the compositor with `Super+Shift+R`).

### Changing Wallpapers

Replace the wallpaper at:
```bash
assets/wallpapers/wallpaper.png
```

Or edit the compositor config to point to your own wallpaper.

## Troubleshooting

### ly doesn't start
```bash
# Check ly status
sudo systemctl status ly@tty1

# Check ly config
cat /etc/ly/config.ini

# Restart ly
sudo systemctl restart ly@tty1
```

If your package provides `ly.service` instead of `ly@tty1.service`, replace the unit name accordingly.

### Chinese input is unavailable
```bash
# Install fcitx5 Rime support
sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-rime fcitx5-configtool
paru -S rime-ice-git

# Log out and back in after installation so environment.d is applied,
# then open the fcitx5 UI and make sure Rime is added as an input method
fcitx5-configtool
```

### Themes not applying
```bash
# Reapply themes manually
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-mauve-standard+default'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-purple-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
```

### Noctalia shell not starting
```bash
# Check if Noctalia is running
pgrep -a qs

# Start Noctalia manually
qs -c noctalia-shell
```

### Compositor won't start
```bash
# For Niri
niri-session

# Check logs
journalctl --user -xe
```

## Uninstallation

To remove donarch and restore your system:

```bash
# Stop and disable greetd
sudo systemctl disable --now greetd

# Restore original configs (if you made a backup)
rm -rf ~/.config
mv ~/.config.backup-YYYYMMDD_HHMMSS ~/.config

# Remove symlinks
unlink ~/.config/niri
unlink ~/.config/noctalia
# ... etc

# Optionally remove packages
sudo pacman -R niri ly quickshell
```

## Directory Structure

```
donarch/
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
│   ├── shared/            # Shared configurations
│   └── niri/              # Niri-specific
├── packages/              # Package lists
└── assets/                # Wallpapers and images
```

## Credits

- **[Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)** - Desktop shell
- **[Niri](https://github.com/YaLTeR/niri)** - Scrollable-tiling Wayland compositor
- **[Catppuccin](https://github.com/catppuccin/catppuccin)** - Soothing pastel theme
- **[ly](https://github.com/fairyglade/ly)** - Lightweight TTY display manager

## License

MIT License - Feel free to use and modify as you wish!

## Contributing

Issues and pull requests welcome! If you find bugs or have suggestions for improvements, please open an issue on GitLab.

---

## Original Author and Source

- Original upstream author: **TheBlackDon**
- Original source repository: **https://gitlab.com/theblackdon/donarch**

**Made with ❤️ by TheBlackDon**
