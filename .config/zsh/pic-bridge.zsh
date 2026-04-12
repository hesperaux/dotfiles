# Pic Bridge - Simple screenshot upload to ~/pic.png on remote
# Then use !picsync in opencode to copy to current directory

_save_clipboard() {
    local fixed_path="/tmp/latest-screenshot.png"
    
    if command -v wl-paste &>/dev/null; then
        wl-paste --type image/png > "$fixed_path" 2>/dev/null
    elif command -v xclip &>/dev/null; then
        xclip -selection clipboard -t image/png -o > "$fixed_path" 2>/dev/null
    elif command -v pngpaste &>/dev/null; then
        pngpaste "$fixed_path" 2>/dev/null
    else
        echo "❌ No clipboard tool (wl-paste, xclip, or pngpaste)"
        return 1
    fi
    
    if [[ -s "$fixed_path" ]]; then
        echo "$fixed_path"
        return 0
    else
        echo "❌ No image in clipboard"
        return 1
    fi
}

# Upload to ~/pic.png on remote
pic() {
    local host="$1"
    [[ -z "$host" ]] && { echo "Usage: pic <host>"; return 1; }
    
    local local_img
    local_img=$(_save_clipboard) || return 1
    
    echo "📤 Uploading screenshot to $host:~/pic.png..."
    scp "$local_img" "$host:~/pic.png" || { echo "❌ Upload failed"; return 1; }
    
    echo "✅ Screenshot uploaded!"
    echo ""
    echo "In opencode, run: !picsync"
    echo "Then use: @pic.png"
}

# Aliases
pic-ai() { pic ai; }
pic-ood() { pic ood; }
pic-quasar() { pic quasar; }
pic-nebula() { pic nebula; }
pic-ceres() { pic ceres; }
pic-emonpi() { pic emonpi; }
pic-monolith() { pic monolith; }

pic-help() {
    cat << 'EOF'
=== Pic Bridge ===

1. Copy screenshot to clipboard
2. Run: pic-ai (or pic-ood, pic-quasar, etc.)
3. In opencode: !picsync
4. Use: @pic.png

That's it! The !picsync command is already on the remote server.
EOF
}

if ! command -v wl-paste &>/dev/null && ! command -v xclip &>/dev/null && ! command -v pngpaste &>/dev/null; then
    echo "⚠️  Warning: No clipboard tool found. Install wl-paste, xclip, or pngpaste."
fi
