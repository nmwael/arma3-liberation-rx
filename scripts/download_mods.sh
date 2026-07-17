#!/bin/bash
set -euo pipefail

STEAMCMD_DIR="/home/container/steamcmd"
MODS_DIR="/home/container/serverfiles"
WORKSHOP_DIR="/home/container/Steam/steamapps/workshop/content/107410"

# Mod list: "WorkshopID ModFolderName"
MODS=(
    "450814997 @CBA_A3"
    "463939057 @ACE3"
    "583496184 @CUP_Terrains_Core"
    "583544987 @CUP_Terrains_Maps"
    "583545784 @CUP_Units"
    "583546887 @CUP_Weapons"
    "583547213 @CUP_Vehicles"
    "873218719 @ACE_Compat_CUP"
    "333310405 @EnhancedMovement"
    "666656604 @AdvancedTowing"
    "665483317 @AdvancedRappelling"
    "1474177632 @AdvancedUrbanRappelling"
    "2659632121 @Liberation_RX"
)

echo "=== Installing SteamCMD ==="
mkdir -p "$STEAMCMD_DIR"
cd "$STEAMCMD_DIR"
if [ ! -f "steamcmd.sh" ]; then
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
fi

echo "=== Downloading Workshop Mods ==="
for mod in "${MODS[@]}"; do
    ID=$(echo "$mod" | cut -d' ' -f1)
    FOLDER=$(echo "$mod" | cut -d' ' -f2)
    echo "Downloading $ID -> $FOLDER"
    ./steamcmd.sh +force_install_dir "$MODS_DIR" +login anonymous +workshop_download_item 107410 "$ID" validate +quit
done

echo "=== Creating Symlinks ==="
mkdir -p "$MODS_DIR"
for mod in "${MODS[@]}"; do
    ID=$(echo "$mod" | cut -d' ' -f1)
    FOLDER=$(echo "$mod" | cut -d' ' -f2)
    SRC="$WORKSHOP_DIR/$ID"
    DST="$MODS_DIR/$FOLDER"
    if [ -d "$SRC" ]; then
        ln -sfn "$SRC" "$DST"
        echo "Linked $FOLDER -> $SRC"
    else
        echo "WARNING: $SRC not found for $FOLDER"
    fi
done

echo "=== Copying Liberation RX Mission ==="
MISSION_SRC="$WORKSHOP_DIR/2659632121/mpmissions"
if [ -d "$MISSION_SRC" ]; then
    mkdir -p "$MODS_DIR/mpmissions"
    cp -v "$MISSION_SRC"/*.pbo "$MODS_DIR/mpmissions/"
    echo "Mission PBOs copied"
else
    echo "WARNING: Liberation RX mission folder not found"
fi

echo "=== Generating Bikey List ==="
find "$MODS_DIR" -name "*.bikey" -exec cp -v {} "$MODS_DIR/keys/" \; 2>/dev/null || true
mkdir -p "$MODS_DIR/keys"

echo "=== Done ==="
