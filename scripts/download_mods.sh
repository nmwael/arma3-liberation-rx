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
    "497661914 @CUP_Units"
    "497660133 @CUP_Weapons"
    "541888371 @CUP_Vehicles"
    "333310405 @EnhancedMovement"
    "639837898 @AdvancedTowing"
    "713709341 @AdvancedRappelling"
    "730310357 @AdvancedUrbanRappelling"
    "2133941118 @Liberation_RX"
    # RHS (free, full factions, Liberation RX native support)
    "843425103 @RHSAFRF"
    "843577117 @RHSUSAF"
    "843593391 @RHSGREF"
    # Client QoL (included by default)
    "1638341685 @DUI"
    "767380317 @Blastcore_Edited"
    "825179978 @Enhanced_Soundscape"
    "903134884 @Align"
    "2791403093 @BetterInventory"
    "825174634 @Suppress"
    "825172265 @Immerse"
    "2995724580 @ImprovedGameSounds"
    "2257686620 @Blastcore_Murr"
    # Terrains
    "648172507 @GOS_Al_Rayak"
    "2645015212 @GreenSeaTerrain"
    "1188303655 @Kunduz_Afghanistan"
    # QoL (included by default)
    "2060770170 @ArsenalSearch"
    "1703187116 @VET_Unflipping"
    "3632946871 @TrueDeath"
    "3450227250 @ReloadWhileAiming"
    # Performance (included by default)
    "1724884525 @AGC"
    "837729515 @CHViewDistance"
    "1486853849 @NoSmokeBounce"
    "2523320712 @SaroTweakMapFPS"
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
MISSION_SRC="$WORKSHOP_DIR/2133941118/mpmissions"
if [ -d "$MISSION_SRC" ]; then
    mkdir -p "$MODS_DIR/mpmissions"
    cp -v "$MISSION_SRC"/*.pbo "$MODS_DIR/mpmissions/"
    echo "Mission PBOs copied"
else
    echo "WARNING: Liberation RX mission folder not found"
fi

echo "=== Generating Bikey List ==="
mkdir -p "$MODS_DIR/keys"
find "$MODS_DIR" -name "*.bikey" -exec cp -v {} "$MODS_DIR/keys/" \; 2>/dev/null || true

echo "=== Done ==="
