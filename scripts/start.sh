#!/bin/bash
set -euo pipefail

# Pterodactyl Environment Variables
SERVER_NAME="${SERVER_NAME:-Liberation RX - 6 Player Co-op}"
SERVER_PASSWORD="${SERVER_PASSWORD:-changeme}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin123}"
MAX_PLAYERS="${MAX_PLAYERS:-10}"
SERVER_PORT="${SERVER_PORT:-2302}"
MISSION_FILE="${MISSION_FILE:-Liberation_RX.Altis.pbo}"
SERVER_PROFILE="${SERVER_PROFILE:-server}"
WORLD="${WORLD:-empty}"

CONTAINER_DIR="/home/container"
SERVER_DIR="${CONTAINER_DIR}/serverfiles"
PROFILE_DIR="${SERVER_DIR}/profile"
CONFIG_DIR="${SERVER_DIR}"

echo "=== Arma 3 Liberation RX Server Starting ==="
echo "Server Name: $SERVER_NAME"
echo "Max Players: $MAX_PLAYERS"
echo "Port: $SERVER_PORT"
echo "Mission: $MISSION_FILE"

# Create profile directory
mkdir -p "$PROFILE_DIR"

# Generate server.cfg
cat > "${CONFIG_DIR}/server.cfg" << CFGEOF
hostname = "$SERVER_NAME";
password = "$SERVER_PASSWORD";
passwordAdmin = "$ADMIN_PASSWORD";
maxPlayers = $MAX_PLAYERS;
persistent = 1;
verifySignatures = 2;
equalModRequired = 0;
requiredSecureId = 2;
voteThreshold = 1.5;
voteMissionPlayers = 1;
reportingIP = "arma3pc.master.gamespy.com";
logFile = "server_console.log";
timeStampFormat = "short";
motd[] = {"Welcome to Liberation RX Co-op!", "Discord: your-discord-link", "Voice: Discord (no TFAR required)"};
motdInterval = 5;
maxDesync = 150;
averageDelay = 10;
maxDiscrepancy = 50;
kickDuplicate = 1;
kickClientsOnSlowNetwork = 0;
kickClientsOnSlowNetworkThreshold = 500;
CFGEOF

# Generate basic.cfg
cat > "${CONFIG_DIR}/basic.cfg" << BASICEOF
language="English";
adapter=-1;
3D_Performance=100000;
Resolution_W=0;
Resolution_H=0;
Resolution_Bpp=32;
MinBandwidth=131072;
MaxBandwidth=20971520;
MaxMsgSend=256;
MaxSizeGuaranteed=512;
MaxSizeNonguaranteed=256;
MinErrorToSend=0.001;
MinErrorToSendNear=0.01;
MaxCustomFileSize=100000;
Windowed=0;
serverLongitude=0;
serverLatitude=52;
serverLongitudeAuto=0;
serverLatitudeAuto=52;
BASICEOF

# Generate server profile
cat > "${PROFILE_DIR}/${SERVER_PROFILE}.Arma3Profile" << PROFILEOF
version=2;
viewDistance=3000;
preferredObjectViewDistance=2000;
terrainGrid=12.5;
activeKeys[]={};
PROFILEOF

# Build mod parameter (includes QoL mods by default)
MODS=(
    "@CBA_A3"
    "@ACE3"
    "@CUP_Terrains_Core"
    "@CUP_Terrains_Maps"
    "@CUP_Units"
    "@CUP_Weapons"
    "@CUP_Vehicles"
    "@ACE_Compat_CUP"
    "@EnhancedMovement"
    "@AdvancedTowing"
    "@AdvancedRappelling"
    "@AdvancedUrbanRappelling"
    "@Liberation_RX"
    # RHS (free, full factions, Liberation RX native)
    "@RHSAFRF"
    "@RHSUSAF"
    "@RHSGREF"
    "@RHSSAF"
    "@ACE_Compat_RHS"
    # QoL mods (included by default)
    "@STUI"
    "@Blastcore_Edited"
    "@Enhanced_Soundscape"
    "@Align"
    "@BetterInventory"
    "@Suppress"
    "@Immerse"
    "@ImprovedGameSounds"
    "@Blastcore_Murr"
    # Terrains
    "@GOS_Al_Rayak"
    "@GreenSeaTerrain"
    "@Kunduz_Afghanistan"
)

MOD_STRING=$(IFS=";"; echo "${MODS[*]}")
SERVER_MOD_STRING="@CBA_A3;@ACE3"

echo "=== Starting Arma 3 Server ==="
cd "$SERVER_DIR"

exec ./arma3server_x64 \
    -mod="$MOD_STRING" \
    -servermod="$SERVER_MOD_STRING" \
    -config="${CONFIG_DIR}/server.cfg" \
    -cfg="${CONFIG_DIR}/basic.cfg" \
    -port="$SERVER_PORT" \
    -profiles="$PROFILE_DIR" \
    -name="$SERVER_PROFILE" \
    -world="$WORLD" \
    -autoinit \
    -maxMem=6144 \
    -maxVRAM=4096 \
    -enableHT \
    -malloc=tbb4malloc_bi \
    -noLogs \
    -loadMissionToMemory \
    "$MISSION_FILE"
