# Arma 3 Liberation RX — Dedicated Server (Pterodactyl + Docker)

6-player co-op Liberation RX server using **Discord for voice** (no TFAR needed).

## Quick Start (Pterodactyl Panel)

1. **Create Server** → Egg: `Arma 3` (parkervcp/arma3)
2. **Docker Image**: `ghcr.io/parkervcp/games:arma3`
3. **Startup Command**: `scripts/start.sh`
4. **Variables** (set in Startup tab):
   - `SERVER_NAME` = "Liberation RX - 6 Player Co-op"
   - `SERVER_PASSWORD` = your password
   - `ADMIN_PASSWORD` = admin password
   - `MAX_PLAYERS` = 10
   - `SERVER_PORT` = 2302 (auto-assigned)
   - `MISSION_FILE` = `Liberation_RX.Altis.pbo`
5. **Install Mods** (Console tab):
   ```bash
   bash scripts/download_mods.sh
   ```
6. **Start Server**

---

## Quick Start (Docker Compose - Local Testing)

```bash
git clone https://github.com/nmwael/arma3-liberation-rx.git
cd arma3-liberation-rx

# Download mods (run once)
docker compose run --rm arma3-liberation-rx bash scripts/download_mods.sh

# Start server
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

---

## File Structure

```
arma3-liberation-rx/
├── docker-compose.yml          # Local testing
├── pterodactyl-egg.json        # Pterodactyl egg definition
├── .devcontainer/              # Devcontainer config (no Docker-in-Docker)
├── .gitignore
├── README.md
├── scripts/
│   ├── download_mods.sh        # SteamCMD mod downloader
│   └── start.sh                # Pterodactyl entrypoint
├── mods/
│   ├── client-modlist.html     # Arma 3 Launcher import preset (35 mods)
│   └── client-modlist.txt      # Human-readable mod list
└── serverfiles/                # Mounted at /home/container/serverfiles
    ├── modlist.html            # Server-side modlist (copy of client)
    ├── mpmissions/             # Liberation RX mission PBOs
    ├── @CBA_A3/                # Mod symlinks (created by download_mods.sh)
    ├── @ACE3/
    └── ...
```

---

## Full Mod List (35 mods)

### Required (12)
| Mod | Workshop ID | Folder | Notes |
|-----|-------------|--------|-------|
| CBA_A3 | `450814997` | @CBA_A3 | Core dependency |
| ACE3 | `463939057` | @ACE3 | Medical, ballistics, interactions |
| CUP Terrains - Core | `583496184` | @CUP_Terrains_Core | Terrain framework |
| CUP Terrains - Maps | `583544987` | @CUP_Terrains_Maps | Map assets |
| CUP Units | `497661914` | @CUP_Units | Faction units |
| CUP Weapons | `497660133` | @CUP_Weapons | Weapon assets |
| CUP Vehicles | `541888371` | @CUP_Vehicles | Vehicle assets |
| Enhanced Movement | `333310405` | @EnhancedMovement | Climbing/vaulting |
| Advanced Towing | `639837898` | @AdvancedTowing | Vehicle towing |
| Advanced Rappelling | `713709341` | @AdvancedRappelling | Rope rappelling |
| Advanced Urban Rappelling | `730310357` | @AdvancedUrbanRappelling | Urban rappelling |
| **Liberation RX** | **`2133941118`** | **@Liberation_RX** | **Mission PBO (Altis)** |

### RHS Faction Mods (3)
| Mod | Workshop ID | Folder |
|-----|-------------|--------|
| RHS: AFRF | `843425103` | @RHSAFRF |
| RHS: USAF | `843577117` | @RHSUSAF |
| RHS: GREF | `843593391` | @RHSGREF |

### Quality of Life (13)
| Mod | Workshop ID | Folder | Notes |
|-----|-------------|--------|-------|
| DUI - Squad Radar | `1638341685` | @DUI | Squad tracking HUD |
| Align | `903134884` | @Align | Alignment helper |
| Better Inventory | `2791403093` | @BetterInventory | Unified inventory view |
| Suppress | `825174634` | @Suppress | Suppression effects |
| Immerse | `825172265` | @Immerse | Screen effects |
| Improved Game Sounds | `2995724580` | @ImprovedGameSounds | Audio enhancements |
| Blastcore Murr Edition | `2257686620` | @Blastcore_Murr | Explosion effects |
| Arsenal Search | `2060770170` | @ArsenalSearch | Ctrl+F search in Arsenal |
| VET Unflipping | `1703187116` | @VET_Unflipping | Flip overturned vehicles |
| True Death | `3632946871` | @TrueDeath | Black screen on death |
| Reload While Aiming | `3450227250` | @ReloadWhileAiming | Reload while ADS |
| Enhanced Soundscape | `825179978` | @Enhanced_Soundscape | Ambient audio |
| Blastcore Edited | `767380317` | @Blastcore_Edited | Visual effects |

### Performance (4)
| Mod | Workshop ID | Folder | Notes |
|-----|-------------|--------|-------|
| AGC - Advanced Garbage Collector | `1724884525` | @AGC | Body/weapon cleanup for FPS |
| CH View Distance | `837729515` | @CHViewDistance | Dynamic view distance by vehicle |
| No 40mm Smoke Bounce | `1486853849` | @NoSmokeBounce | Smoke embeds instead of bouncing |
| saroTweakMapFPS | `2523320712` | @SaroTweakMapFPS | Hide terrain objects for FPS |

### Terrains (3)
| Mod | Workshop ID | Folder |
|-----|-------------|--------|
| G.O.S Al Rayak | `648172507` | @GOS_Al_Rayak |
| Green Sea Terrain | `2645015212` | @GreenSeaTerrain |
| Kunduz Afghanistan | `1188303655` | @Kunduz_Afghanistan |

> **No TFAR** — Using Discord for voice. Liberation RX works fine without radio mod.

---

## Client Setup (Share with Friends)

1. Open `mods/client-modlist.html` in browser
2. Click each Workshop link → **Subscribe**
3. Or: Arma 3 Launcher → Presets → Import → Select `client-modlist.html`
4. Join server via IP:port or Steam server browser

---

## Liberation RX Mission Config

Mission is server-side only. Edit parameters in `serverfiles/mpmissions/Liberation_RX.Altis.pbo` (use PBO Manager) or via in-game parameters menu:

| Parameter | 6-Player Recommended |
|-----------|---------------------|
| Player Count | 6 |
| Faction | NATO vs CSAT (or RHS if added) |
| Difficulty | Veteran |
| AI Commander | Enabled |
| Logistics | Enabled (sling load, trucks) |
| Fast Travel | Disabled (immersive) |
| Revive | ACE Medical (Basic) |

### Map Variants (change MISSION_FILE)
- `Liberation_RX.Altis.pbo` (default, large)
- `Liberation_RX.Tanoa.pbo` (jungle, denser)
- `Liberation_RX.Livonia.pbo` (Contact DLC required)
- `Liberation_RX.Weferlingen.pbo` (German terrain)
- `Liberation_RX.Ravenport.pbo` (US-style)

---

## Ports (UDP)

| Port | Purpose |
|------|---------|
| 2302 | Game |
| 2303 | Steam Query |
| 2304 | Steam Master |
| 2305 | BattlEye |

Open all 4 on firewall/router/Pterodactyl allocation.

---

## Performance Tuning (6 Players)

`basic.cfg` (generated by start.sh):
```
MinBandwidth=131072
MaxBandwidth=20971520
MaxMsgSend=256
MaxSizeGuaranteed=512
MaxSizeNonguaranteed=256
```

`start.sh` JVM args:
```
-maxMem=6144 -maxVRAM=4096 -enableHT -malloc=tbb4malloc_bi
```

Target: **40+ server FPS** with 6 players.

---

## Updating Mods

```bash
# Pterodactyl console
bash scripts/download_mods.sh

# Docker compose
docker compose run --rm arma3-liberation-rx bash scripts/download_mods.sh
docker compose up -d
```

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| "Missing mod" on join | Run `download_mods.sh`, verify symlinks in `@ModName` |
| Mission not loading | Check `mpmissions/` has `Liberation_RX.*.pbo`, set `MISSION_FILE` correctly |
| Low server FPS | Reduce `viewDistance` in profile, lower AI count, check `-maxMem` |
| BattlEye kicks | Ensure `verifySignatures=2`, all mods have keys (`.bisign`) |
| Can't connect | Check all 4 UDP ports open, `SERVER_PORT` matches allocation |

---

## Links

- [Liberation RX Workshop (Altis)](https://steamcommunity.com/sharedfiles/filedetails/?id=2133941118)
- [Pterodactyl Arma 3 Egg](https://github.com/parkervcp/eggs/tree/master/game/arma3)
- [Docker Image](https://github.com/parkervcp/games/pkgs/container/games)

---

## Workshop ID Notes

Some mods had dead Workshop IDs (result=9) that were replaced:

| Original Mod | Dead ID | Replacement | New ID |
|---|---|---|---|
| CUP Units | `583545784` | CUP Units (old ID) | `497661914` |
| CUP Weapons | `583546887` | CUP Weapons (old ID) | `497660133` |
| CUP Vehicles | `583547213` | CUP Vehicles (old ID) | `541888371` |
| Advanced Towing | `666656604` | Advanced Towing (new ID) | `639837898` |
| Advanced Rappelling | `665483317` | Advanced Rappelling (new ID) | `713709341` |
| Advanced Urban Rappelling | `1474177632` | Advanced Urban Rappelling (new ID) | `730310357` |
| Liberation RX | `2659632121` | Liberation RX (Altis) | `2133941118` |
| STUI (ShackTac UI) | `498724824` | DUI - Squad Radar | `1638341685` |
| Blastcore Edited | `817849698` | Blastcore Edited (standalone) | `767380317` |
| Enhanced Soundscape | `1771939421` | Enhanced Soundscape | `825179978` |

**Removed mods** (no replacement available):
- ACE Compat - CUP (`873218719`) — integrated into ACE3
- ACE Compat - RHS (`2174159327`) — integrated into ACE3
- RHS: SAF (`1082989427`) — removed from Workshop entirely
