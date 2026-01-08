#!/usr/bin/env bash
# Dotfiles deployment functions for bd-configs installer

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
        "qt5ct"
        "qt6ct"
        "fastfetch"
    )
    
    for config in "${shared_configs[@]}"; do
        if [ -d "$repo_dir/configs/shared/$config" ]; then
            log_info "Linking $config..."
            create_symlink "$repo_dir/configs/shared/$config" "$config_dir/$config"
        fi
    done
    
    log_success "Shared configurations deployed"
}

# Deploy Hyprland configurations
deploy_hyprland_configs() {
    local repo_dir="$1"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"
    
    log_info "Deploying Hyprland configurations..."
    
    # Link hypr directory
    if [ -d "$repo_dir/configs/hyprland/hypr" ]; then
        log_info "Linking Hyprland configs..."
        create_symlink "$repo_dir/configs/hyprland/hypr" "$config_dir/hypr"
    fi
    
    # Link zed directory
    if [ -d "$repo_dir/configs/hyprland/zed" ]; then
        log_info "Linking Zed editor configs..."
        create_symlink "$repo_dir/configs/hyprland/zed" "$config_dir/zed"
    fi
    
    log_success "Hyprland configurations deployed"
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

# Merge DMS settings (base + compositor-specific)
merge_dms_configs() {
    local repo_dir="$1"
    local compositor="$2"  # "hyprland" or "niri"
    local user_home=$(get_user_home)
    local config_dir="$user_home/.config"
    local dms_dir="$config_dir/DankMaterialShell"
    
    log_info "Merging DMS configurations for $compositor..."
    
    # Check if jq is installed
    if ! command_exists jq; then
        log_warn "jq not installed, falling back to direct copy"
        create_symlink "$repo_dir/configs/$compositor/DankMaterialShell" "$dms_dir"
        return 0
    fi
    
    local base_settings="$repo_dir/configs/shared/DankMaterialShell/settings.json"
    local compositor_settings="$repo_dir/configs/$compositor/DankMaterialShell/settings.json"
    
    if [ ! -f "$base_settings" ]; then
        log_warn "Base DMS settings not found, using compositor settings only"
        create_symlink "$repo_dir/configs/$compositor/DankMaterialShell" "$dms_dir"
        return 0
    fi
    
    if [ ! -f "$compositor_settings" ]; then
        log_warn "Compositor-specific DMS settings not found, using base settings only"
        create_symlink "$repo_dir/configs/shared/DankMaterialShell" "$dms_dir"
        return 0
    fi
    
    # Create DMS directory
    mkdir -p "$dms_dir"
    
    # Merge JSON files with jq
    jq -s '.[0] * .[1]' "$base_settings" "$compositor_settings" > "$dms_dir/settings.json"
    
    # Copy other DMS files from compositor-specific directory
    if [ -d "$repo_dir/configs/$compositor/DankMaterialShell/themes" ]; then
        cp -r "$repo_dir/configs/$compositor/DankMaterialShell/themes" "$dms_dir/"
    fi
    
    # Also copy from shared if they exist
    if [ -d "$repo_dir/configs/shared/DankMaterialShell/themes" ]; then
        cp -r "$repo_dir/configs/shared/DankMaterialShell/themes" "$dms_dir/" 2>/dev/null || true
    fi
    
    # Copy any CSS files
    cp "$repo_dir/configs/shared/DankMaterialShell"/*.css "$dms_dir/" 2>/dev/null || true
    cp "$repo_dir/configs/$compositor/DankMaterialShell"/*.css "$dms_dir/" 2>/dev/null || true
    
    log_success "DMS configurations merged"
}

# Main deployment function
deploy_configurations() {
    local repo_dir="$1"
    local install_hyprland="$2"
    local install_niri="$3"
    
    log_step "Deploying Configurations"
    
    # Always deploy shared configs
    deploy_shared_configs "$repo_dir"
    
    # Deploy compositor-specific configs
    if [ "$install_hyprland" = "true" ]; then
        deploy_hyprland_configs "$repo_dir"
        merge_dms_configs "$repo_dir" "hyprland"
    fi
    
    if [ "$install_niri" = "true" ]; then
        deploy_niri_configs "$repo_dir"
        # If both are installed and we already merged for hyprland, skip niri merge
        # Or we could merge both - for now, prefer the first one selected
        if [ "$install_hyprland" != "true" ]; then
            merge_dms_configs "$repo_dir" "niri"
        fi
    fi
    
    log_success "All configurations deployed successfully"
}
