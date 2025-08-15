# Visual Theming and Customization

## Theme Inspiration

### Design Sources
- **Typecraft**: Professional developer dotfiles ([typecraft-dev/dotfiles](https://github.com/typecraft-dev/dotfiles))
- **Catppuccin**: Modern, soothing color scheme ([catppuccin/catppuccin](https://github.com/catppuccin/catppuccin))

## Dotfiles Management Setup

### Install Stow
```bash
# Install GNU Stow for symlink management
paru -S stow
```
**Stow**: Creates symbolic links from dotfiles repository to system locations

### Download Theme Base
```bash
# Clone typecraft dotfiles repository
git clone https://github.com/typecraft-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## Wallpaper Configuration

### Install Wallpaper Manager
```bash
# Install hyprpaper for wallpaper management
sudo pacman -S hyprpaper
```

### Apply Wallpaper Theme
```bash
# Create symlinks for wallpaper configuration and backgrounds
stow hyprpaper
stow background
```
**Result**: Wallpaper system configured with theme backgrounds

## Terminal Customization

### Apply Terminal Theme
```bash
# Link kitty terminal configuration
stow kitty
```

### Install Shell Prompt
```bash
# Install Starship prompt
paru -S starship

# Apply Starship configuration
stow starship
```

### Install Themed Font
```bash
# Install Cascadia Code Nerd Font
paru -S ttf-caskaydia-code-nerd
```

### Customize Terminal Opacity
```bash
# Edit kitty configuration for transparency
vim ~/.config/kitty/kitty.conf

# Adjust opacity setting
background_opacity 0.85
```

## Status Bar Theming

### Replace Default Waybar
```bash
# Remove default waybar configuration
rm -rf ~/.config/waybar

# Apply themed waybar configuration
stow waybar
```
**Result**: Professionally styled status bar with consistent theme

## Application Launcher Theme

### Apply Wofi Theme
```bash
# Link wofi configuration
stow wofi
```
**Result**: Application launcher matches overall theme aesthetic

## Lock Screen Theming

### Replace Lock Screen Configuration
```bash
# Remove default hyprlock configuration
rm ~/.config/hypr/hyprlock.conf

# Apply themed lock screen
stow hyprlock
stow hyprmocha
```
**Components**:
- **hyprlock**: Lock screen functionality
- **hyprmocha**: Catppuccin Mocha color variant

## Dynamic Wallpaper System

### Problem with Static Wallpapers
The default hyprpaper configuration only displayed the same wallpaper repeatedly.

### Solution: Random Wallpaper Script
**Created custom script**: `~/.config/hypr/random-wallpaper.sh`

**Script functionality**:
- Selects random wallpaper from backgrounds folder
- Generates temporary hyprpaper configuration
- Applies new wallpaper dynamically

### Integration with Hyprland
```bash
# Added to hyprland.conf
exec-once = ~/.config/hypr/random-wallpaper.sh

# Removed static hyprpaper configuration
# exec-once = hyprpaper
```

## Symlink Management Benefits

### GNU Stow Advantages
- **Version control**: Dotfiles tracked in git repository
- **Easy updates**: Pull changes from upstream
- **Backup**: Configuration safely stored
- **Portability**: Easy setup on new systems
- **Modularity**: Individual component management

### Symlink Structure
```
~/dotfiles/kitty/ → ~/.config/kitty/
~/dotfiles/waybar/ → ~/.config/waybar/
~/dotfiles/wofi/ → ~/.config/wofi/
~/dotfiles/starship/ → ~/.config/starship.toml
```

## Color Scheme: Catppuccin Mocha

### Theme Characteristics
- **Dark theme**: Easy on the eyes
- **Consistent colors**: Unified across all applications
- **Professional**: Suitable for development work
- **Modern**: Contemporary design aesthetic

### Applied Components
- Terminal colors (kitty)
- Status bar theme (waybar)
- Lock screen colors (hyprlock)
- Application launcher (wofi)

## Final Theme Features

### Visual Consistency
- ✅ Unified color scheme across all components
- ✅ Professional typography with Nerd Fonts
- ✅ Dynamic wallpaper system
- ✅ Transparent terminal effects
- ✅ Cohesive status bar design

### Functional Enhancements
- ✅ Random wallpaper rotation
- ✅ Optimized terminal experience
- ✅ Enhanced visual feedback
- ✅ Professional aesthetic

### Technical Implementation
- ✅ Modular configuration management
- ✅ Version-controlled dotfiles
- ✅ Custom scripting integration
- ✅ Upstream theme compatibility

## Result

The system now features a beautiful, cohesive desktop environment that combines:
- **Professional appearance**: Suitable for development work
- **Modern design**: Contemporary visual elements
- **Functional beauty**: Aesthetics that enhance productivity
- **Personal customization**: Tailored to individual preferences

The theming process transforms the functional Arch installation into a visually stunning and personalized workspace.

