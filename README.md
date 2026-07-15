# Windows Fix Suite v2.0

**Complete Windows Maintenance, Repair & Optimization Toolkit**

A comprehensive collection of Windows repair tools organized for easy use. Originally created for Monday's Players PC repair sessions.

---

## Quick Start

```batch
# Run the main launcher (as Administrator!)
Windows-Repair-Suite.bat
```

## One-Click Options

| Script | Purpose |
|--------|---------|
| `Quick-Fix.bat` | Fast repair for common issues (5 min) |
| `Safe-Mode-Launcher.bat` | Boot to Safe Mode options |

---

## Repository Structure

```
windows-fix/
├── Windows-Repair-Suite.bat      # Main launcher (START HERE)
├── Quick-Fix.bat                 # One-click quick repair
├── Safe-Mode-Launcher.bat        # Safe mode boot options
│
├── registry/                     # Registry tweak files
│   ├── Context-Menu-Tweaks.reg
│   ├── Default-Services-Win10.reg
│   ├── Gaming-Optimizations.reg
│   ├── Indexing-Fast.reg
│   ├── Performance-Tweaks.reg
│   ├── Privacy-Tweaks.reg
│   └── legacy/                   # Original registry files
│
├── scripts/
│   ├── Windows-Repair-Suite.ps1  # PowerShell version
│   └── legacy/                   # Original scripts
│
├── fixes/                        # Individual repair tools
│   ├── network/
│   │   └── Network-Full-Reset.bat
│   ├── system/
│   │   ├── System-File-Repair.bat
│   │   └── Windows-Update-Repair.bat
│   ├── performance/
│   │   └── Gaming-Optimizer.bat
│   ├── security/
│   │   └── Security-QuickScan.bat
│   └── maintenance/
│       └── System-Cleanup.bat
│
├── diagnostics/
│   └── System-Diagnostics.bat
│
├── docs/
│   ├── README.md                 # This file
│   ├── TROUBLESHOOTING.md        # Common issues & fixes
│   └── legacy/                   # Original documentation
│
└── tools/                        # 3rd party executables
    ├── ClassicShellSetup_4_3_1.exe
    ├── WiseCare365.exe
    ├── avg_antivirus_free_setup.exe
    └── ...
```

---

## Main Launcher Features

The `Windows-Repair-Suite.bat` provides a 9-category menu:

1. **System Repairs** - SFC, DISM, Component Store
2. **Performance Tweaks** - Registry, services, optimizations
3. **Network Fixes** - TCP/IP, DNS, Winsock reset
4. **Security Tools** - Defender, firewall, malware scans
5. **Maintenance Tools** - Cleanup, defrag, disk check
6. **Registry Tools** - Backup, restore, tweaks
7. **Diagnostics** - System info, health checks
8. **Service Management** - Default services, optimizations
9. **All-In-One Repair** - Complete automated cycle

---

## Registry Tweaks Available

| File | Description |
|------|-------------|
| `Performance-Tweaks.reg` | UI speed, responsiveness, faster shutdown |
| `Gaming-Optimizations.reg` | Low latency, disable DVR, gaming mode |
| `Privacy-Tweaks.reg` | Disable telemetry, tracking, Cortana |
| `Indexing-Fast.reg` | Speed up Windows Search |
| `Context-Menu-Tweaks.reg` | Add Copy To, Move To, Take Ownership |
| `Default-Services-Win10.reg` | Restore all services to defaults |

---

## PowerScript Advanced Mode

```powershell
# Quick repair (5-15 min)
.\scripts\Windows-Repair-Suite.ps1 -Mode Quick

# Full repair with restore point and report (45-90 min)
.\scripts\Windows-Repair-Suite.ps1 -Mode Full -CreateRestorePoint -GenerateReport

# Gaming optimization
.\scripts\Windows-Repair-Suite.ps1 -Mode Gaming

# Network reset only
.\scripts\Windows-Repair-Suite.ps1 -Mode Network
```

**Available Modes:** Quick, Deep, Full, Gaming, Network, Security, Maintenance

---

## Individual Fix Tools

| Tool | Use For |
|------|---------|
| `Network-Full-Reset.bat` | No internet, DNS issues, network errors |
| `System-File-Repair.bat` | Corrupt system files, DISM errors |
| `Windows-Update-Repair.bat` | Stuck updates, error codes |
| `Gaming-Optimizer.bat` | Lag, stutter, game performance |
| `Security-QuickScan.bat` | Quick security check, defender issues |
| `System-Cleanup.bat` | Free disk space, remove temp files |
| `System-Diagnostics.bat` | Generate health reports, check status |

---

## Requirements

- **Windows 10/11** (most tools work on Windows 7/8 too)
- **Administrator privileges** (always run as Admin!)
- **PowerShell 5.1+** (for PowerScript version)

---

## Safety Features

- ✅ Admin check on all tools
- ✅ Automatic restore point creation (optional)
- ✅ Non-destructive operations
- ✅ Logging of all changes
- ✅ Confirmation prompts for critical actions

---

## Original Files

Legacy files from the original repo are preserved in `*/legacy/` folders:
- `registry/legacy/` - Original .reg files
- `scripts/legacy/` - Original .bat scripts
- `docs/legacy/` - Original documentation

---

## Troubleshooting

See `docs/TROUBLESHOOTING.md` for:
- Common errors and fixes
- Recovery procedures
- Manual repair instructions

---

## Credits

- Performance tweaks adapted from AskVG/Vishal Gupta
- Service configurations based on Microsoft defaults
- Original repository by kaibuzz0
- Suite v2.0 organization and additions

---

## License

Free for personal and commercial use.

---

**Windows Fix Suite v2.0** | For Monday's Players
