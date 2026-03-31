#!/bin/sh
set -e

case "$(uname -s)" in
    Linux*)
        PLATFORM=Linux
        FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
        ;;
    Darwin*)
        PLATFORM=Darwin
        FONT_DIR="$HOME/Library/Fonts"
        ;;
    *)
        echo "Unsupported platform: $(uname -s)" >&2
        exit 1
        ;;
esac

TMP_DIR=/tmp/nerd-fonts-install

mkdir -p "$FONT_DIR"
mkdir -p "$TMP_DIR"

FONT_URLS="
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuMono.zip
"

FONTS_TO_INSTALL="
MesloLGLNerdFont-Regular.ttf
UbuntuMonoNerdFont-Regular.ttf
"

for url in $FONT_URLS; do
    filename="$(basename "$url")"
    echo "Downloading $filename..."
    if ! wget -q -O "$TMP_DIR/$filename" "$url"; then
        echo "Failed to download $filename" >&2
        exit 1
    fi

    unzip -qo "$TMP_DIR/$filename" -d "$TMP_DIR"

    echo "Downloaded $(basename "$url")"
done

for font in $FONTS_TO_INSTALL; do
    echo "Installing $font..."
    cp -v "$TMP_DIR/$font" "$FONT_DIR"
done


if [ "$PLATFORM" = "Linux" ]; then
    echo "Refreshing font cache..."
    fc-cache -fv >/dev/null 2>&1 || echo "Warning: fc-cache failed (may need sudo)"
fi

echo "Cleaning up..."
rm -rfv "$TMP_DIR"

echo "Fonts installed to $FONT_DIR"
