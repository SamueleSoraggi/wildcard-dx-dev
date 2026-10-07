# Super Wildcard DX — SNES Development

ROM development for the **RONT Super Wildcard DX** SNES copier.  
C + 65816 assembly, built with PVSnesLib, tested in Mesen, transferred via parallel port.

---

## Pipeline

```
VSCode → PVSnesLib/asar → .sfc ROM → Mesen test → scp to T500 → DOSBox-X + SWC → Wildcard DX → SNES
```

---

## Project structure

```
wildcard-dx-dev/
├── src/
│   ├── main.c          # C entry point (PVSnesLib)
│   └── main.asm        # 65816 assembly routines (WLA-DX)
├── include/            # shared headers
├── gfx/                # raw graphics assets (before conversion)
├── build/              # object files — gitignored
├── tools/
│   └── add_header.py   # prepend 512-byte SMC header for transfer
├── docs/
│   └── setup.md        # full environment setup guide
├── .vscode/
│   └── tasks.json      # build / clean / deploy tasks
└── Makefile
```

---

## Dev machine (macOS + VSCode)

### Requirements

| Tool | Purpose | Install |
|------|---------|---------|
| PVSnesLib | C + ASM toolchain (gcc-65816 + WLA-DX) | Docker (see below) or build from source |
| asar | Standalone 65816 assembler | [GitHub releases](https://github.com/RPGHacker/asar/releases) |
| Mesen | SNES emulator + debugger | [GitHub releases](https://github.com/SourMesen/Mesen2/releases) |
| Docker Desktop | Runs PVSnesLib on macOS without a native build | [docker.com](https://www.docker.com/products/docker-desktop/) |

### PVSnesLib via Docker

```bash
# Pull once
docker pull alekmaul/pvsneslib

# Add to ~/.zshrc
alias snesmake='docker run --rm -v $(pwd):/src alekmaul/pvsneslib make'
```

### Build

```bash
# In project root
snesmake           # → wildcard-dx-dev.sfc
snesmake header    # → wildcard-dx-dev.smc  (adds 512-byte SMC header)
snesmake clean
```

Or press **⌘⇧B** in VSCode (uses the `build` task in `.vscode/tasks.json`).

### Test in Mesen

Open `wildcard-dx-dev.sfc` in Mesen. Use **Debug → Debugger** for CPU step-through,  
**Debug → PPU Viewer** for tile/palette inspection.

---

## Transfer machine (Thinkpad T500 — Linux Mint)

### One-time parallel port setup

```bash
# Load kernel modules
sudo modprobe parport parport_pc ppdev
sudo rmmod lp

# User access
sudo usermod -a -G lp $USER
sudo chmod 666 /dev/parport0
```

Persist across reboots — add to `/etc/modules`:

```
parport
parport_pc
ppdev
```

Create `/etc/modprobe.d/blacklist-lp.conf`:

```
blacklist lp
```

**BIOS:** enter T500 BIOS (F1) → Config → Parallel Port → set mode to **EPP**.

### DOSBox-X

```bash
sudo add-apt-repository ppa:dosbox-x-team/dosbox-x
sudo apt update && sudo apt install dosbox-x
```

Add to `~/.config/dosbox-x/dosbox-x.conf`:

```ini
[parallel]
parallel1=realport /dev/parport0 speed:1000

[autoexec]
mount c ~/swc
c:
```

Place your SWC Manager DOS software in `~/swc/` (source from archive.org / vintage SNES communities).

### Transfer a ROM

```bash
# From your Mac after building:
scp wildcard-dx-dev.smc user@t500:~/roms/

# On T500 — in DOSBox-X:
C:\> SWC.EXE
# Upload → LPT1 → select the .smc file
```

---

## ROM format notes

- **PVSnesLib** outputs a headerless `.sfc` — accepted directly by Mesen and most emulators.
- **SMC header**: some SWC transfer software requires a 512-byte copier header (`.smc`).  
  Generate it with: `python3 tools/add_header.py game.sfc game.smc`
- **LoROM** mapping is the PVSnesLib default and the right starting point for homebrew.
- ROM size must be a power of two (256KB, 512KB, 1MB…). PVSnesLib pads automatically.

---

## References

- [PVSnesLib Wiki](https://github.com/alekmaul/pvsneslib/wiki) — API reference and tutorials
- [fullsnes](https://problemkaputt.de/fullsnes.htm) — definitive SNES hardware register reference
- [wiki.superfamicom.org](https://wiki.superfamicom.org) — 65816 opcode table and SNES internals
- [SMW Central](https://www.smwcentral.net) — asar, 65816 ASM community and examples
- [DOSBox-X Wiki](https://dosbox-x.com/wiki) — parallel port passthrough documentation
- SNES Development Manual — archive.org → "SNES Development Manual"
