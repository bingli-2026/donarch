#!/usr/bin/env bash
# Dotfiles deployment functions for donarch installer

# Source utils for logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Create symlink (removing existing files/symlinks first)
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    mkdir -p "$target_dir"

    # Remove existing file/symlink if present
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi

    # Create symlink
    ln -sf "$source" "$target"
}

# Deploy assets directory
deploy_assets() {
    local repo_dir="$1"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"

    log_info "Deploying assets..."

    if [ -d "$repo_dir/assets" ]; then
        create_symlink "$repo_dir/assets" "$config_dir/donarch/assets"
        log_success "Assets linked to $config_dir/donarch/assets"
    fi
}

# Deploy shared configurations
deploy_shared_configs() {
    local repo_dir="$1"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"

    log_info "Deploying shared configurations..."

    local shared_configs=(
        "kitty"
        "fish"
        "gtk-3.0"
        "gtk-4.0"
        "noctalia"
    )

    for config in "${shared_configs[@]}"; do
        if [ -d "$repo_dir/configs/shared/$config" ]; then
            if [ "$config" = "shell-switch" ]; then
                log_info "Linking $config..."
                create_symlink "$repo_dir/configs/shared/$config" "$config_dir/$config"

                # Ensure shell-switch binary is available in PATH
                if [ -f "$repo_dir/configs/shared/$config/shell-switch" ]; then
                    chmod +x "$repo_dir/configs/shared/$config/shell-switch" 2>/dev/null || true
                    mkdir -p "$user_home/.local/bin"
                    ln -sf "$repo_dir/configs/shared/$config/shell-switch" "$user_home/.local/bin/shell-switch"
                    log_success "shell-switch linked to $user_home/.local/bin/shell-switch"
                else
                    log_warn "shell-switch executable not found in shared config; skipping ~/.local/bin link"
                fi
            else
                log_info "Linking $config..."
                create_symlink "$repo_dir/configs/shared/$config" "$config_dir/$config"
            fi
        fi
    done

    # Handle Qt configs separately to process $HOME variable
    for qt_config in "qt5ct" "qt6ct"; do
        if [ -d "$repo_dir/configs/shared/$qt_config" ]; then
            log_info "Processing $qt_config config with path expansion..."
            mkdir -p "$config_dir/$qt_config"
            if [ -f "$repo_dir/configs/shared/$qt_config/${qt_config}.conf" ]; then
                sed "s|\$HOME|$user_home|g" "$repo_dir/configs/shared/$qt_config/${qt_config}.conf" > "$config_dir/$qt_config/${qt_config}.conf"
            fi
            # Copy other files if they exist
            find "$repo_dir/configs/shared/$qt_config" -type f ! -name "${qt_config}.conf" -exec cp {} "$config_dir/$qt_config/" \; 2>/dev/null || true
        fi
    done

    # Handle fastfetch separately to process $HOME variable
    if [ -d "$repo_dir/configs/shared/fastfetch" ]; then
        log_info "Processing fastfetch config with path expansion..."
        mkdir -p "$config_dir/fastfetch"
        if [ -f "$repo_dir/configs/shared/fastfetch/config.jsonc" ]; then
            sed "s|\$HOME|$user_home|g" "$repo_dir/configs/shared/fastfetch/config.jsonc" > "$config_dir/fastfetch/config.jsonc"
        fi
        # Copy other fastfetch files if they exist
        find "$repo_dir/configs/shared/fastfetch" -type f ! -name "config.jsonc" -exec cp {} "$config_dir/fastfetch/" \; 2>/dev/null || true
    fi

    log_success "Shared configurations deployed"
}

# Deploy environment.d snippets without replacing the whole directory
deploy_environment_configs() {
    local repo_dir="$1"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"
    local source_dir="$repo_dir/configs/shared/environment.d"
    local target_dir="$config_dir/environment.d"

    if [ ! -d "$source_dir" ]; then
        return 0
    fi

    log_info "Deploying environment configuration..."
    mkdir -p "$target_dir"

    local file
    for file in "$source_dir"/*; do
        [ -e "$file" ] || continue
        create_symlink "$file" "$target_dir/$(basename "$file")"
    done

    log_success "Environment configuration deployed"
}

# Deploy fcitx5 Rime configuration files
deploy_rime_configs() {
    local repo_dir="$1"
    local user_home=$(get_user_home)
    local source_dir="$repo_dir/configs/shared/fcitx5/rime"
    local target_dir="$user_home/.local/share/fcitx5/rime"

    if [ ! -d "$source_dir" ]; then
        return 0
    fi

    log_info "Deploying fcitx5 Rime configuration..."
    mkdir -p "$target_dir"

    local file
    for file in "$source_dir"/*; do
        [ -e "$file" ] || continue
        create_symlink "$file" "$target_dir/$(basename "$file")"
    done

    log_success "fcitx5 Rime configuration deployed"
}

# Deploy Niri configurations
deploy_niri_configs() {
    local repo_dir="$1"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"

    log_info "Deploying Niri configurations..."

    # Link niri directory
    if [ -d "$repo_dir/configs/niri/niri" ]; then
        log_info "Linking Niri configs..."
        create_symlink "$repo_dir/configs/niri/niri" "$config_dir/niri"
    fi

    log_success "Niri configurations deployed"
}

# Configure shell startup for compositors
configure_shell_startup() {
    local repo_dir="$1"
    local compositor="$2"  # "niri"
    local selected_shell="${3:-noctalia}"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"

    log_info "Configuring $compositor startup for $selected_shell shell..."

    if [ "$selected_shell" != "noctalia" ]; then
        log_error "Unsupported shell: $selected_shell"
        return 1
    fi

    local shell_name="Noctalia Shell"
    local launch_cmd="qs -c noctalia-shell"
    local launcher_cmd="qs -c noctalia-shell ipc call launcher toggle"

    if [ "$compositor" = "niri" ]; then
        # Create niri shell startup config
        local niri_config_dir="$config_dir/niri"
        mkdir -p "$niri_config_dir"

        # Format command as quoted arguments for KDL
        local launch_cmd_args
        launch_cmd_args=$(echo "$launch_cmd" | awk '{for(i=1;i<=NF;i++) printf "\"%s\" ", $i}' | sed 's/ $//')

        local launcher_cmd_args
        launcher_cmd_args=$(echo "$launcher_cmd" | awk '{for(i=1;i<=NF;i++) printf "\"%s\" ", $i}' | sed 's/ $//')

        # Generate shell-switcher-startup.kdl
        cat > "$niri_config_dir/shell-switcher-startup.kdl" << EOF
// Shell Switcher - Startup Configuration
// This file is managed by shell-switch - manual edits will be overwritten
// Current shell: ${shell_name}

spawn-at-startup ${launch_cmd_args}
EOF

        # Generate shell-switcher-binds.kdl
        cat > "$niri_config_dir/shell-switcher-binds.kdl" << EOF
// Shell Switcher - Keybindings
// This file is managed by shell-switch - manual edits will be overwritten
// Current shell: ${shell_name}

binds {
    // Application launcher
    Mod+Space hotkey-overlay-title="Launcher" {
        spawn ${launcher_cmd_args}
    }
}
EOF

        log_success "Niri shell configuration created"
    fi
}

# Main deployment function
deploy_configurations() {
    local repo_dir="$1"
    local install_niri="$2"
    local selected_shell="${3:-noctalia}"

    log_step "Deploying Configurations"

    # Deploy assets first
    deploy_assets "$repo_dir"

    # Always deploy shared configs
    deploy_shared_configs "$repo_dir"
    deploy_environment_configs "$repo_dir"
    deploy_rime_configs "$repo_dir"

    # Deploy compositor-specific configs
    if [ "$install_niri" = "true" ]; then
        deploy_niri_configs "$repo_dir"
        configure_shell_startup "$repo_dir" "niri" "$selected_shell"
    fi

    log_success "All configurations deployed successfully"
}
