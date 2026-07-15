# Windows Repair Suite v2.0

**Complete Windows Maintenance, Repair & Optimization Toolkit**

Created for Monday's Players - A comprehensive collection of Windows repair tools, organized by category with a professional launcher interface.

---

## Quick Start

**Run as Administrator:** `Windows-Repair-Suite.bat`

This is your main launcher with all tools organized by category.

---

## Suite Structure

```
windows-fix-suite/
├── Windows-Repair-Suite.bat      # Main launcher (START HERE)
├── registry/                      # Registry files
│   ├── Context-Menu-Tweaks.reg
│   ├── Default-Services-Win10.reg
│   ├── Gaming-Optimizations.reg
│   ├── Indexing-Fast.reg
│   ├── Performance-Tweaks.reg
│   └── Privacy-Tweaks.reg
├── scripts/
│   └── Windows-Repair-Suite.ps1 # PowerScript version
├── fixes/
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
├── diagnostics/
│   └── System-Diagnostics.bat
├── tools/                         # (3rd party tools)
└── docs/
    ├── README.md
    └── TROUBLESHOOTING.md
```

---

## What's Included

### Main Categories

| Category | Description | Key Tools |
|----------|-------------|-----------|
| **System Repairs** | SFC, DISM, Component Store | Complete system image repair |
| **Performance Tweaks** | Registry optimizations, services | Gaming/Productivity modes |
| **Network Fixes** | TCP/IP, DNS, Winsock reset | Full network stack repair |
| **Security Tools** | Defender scans, firewall | Malware removal |
| **Maintenance Tools** | Cleanup, defrag, temp files | Disk space recovery |
| **Registry Tools** | Backup/restore, tweaks | Safe registry operations |
| **Diagnostics** | System info, health reports | Comprehensive analysis |
| **Service Management** | Default/optimized services | Gaming/Productivity profiles |

### Registry Files

| File | Purpose |
|------|---------|
| `Performance-Tweaks.reg` | UI speed, responsiveness |
| `Gaming-Optimizations.reg` | Low latency, gaming mode |
| `Privacy-Tweaks.reg` | Disable telemetry, tracking |
| `Indexing-Fast.reg` | Speed up Windows Search |
| `Context-Menu-Tweaks.reg` | Add Copy To, Take Ownership |
| `Default-Services-Win10.reg` | Restore default services |

---

## Usage Modes

### 1. Main Launcher (Recommended)
```batch
Windows-Repair-Suite.bat
```
Navigate menus to select repairs by category.

### 2. Individual Tools
Run specific fixes from the `fixes/` folders:
```batch
fixes\network\Network-Full-Reset.bat
fixes\system\Windows-Update-Repair.bat
```

### 3. PowerScript (Advanced)
```powershell
# Quick repair
.\scripts\Windows-Repair-Suite.ps1 -Mode Quick

# Full repair with report
.\scripts\Windows-Repair-Suite.ps1 -Mode Full -CreateRestorePoint -GenerateReport

# Gaming optimization
.\scripts\Windows-Repair-Suite.ps1 -Mode Gaming
```

---

## Available PowerScript Modes

| Mode | Description | Time |
|------|-------------|------|
| `Quick` | SFC + Temp cleanup + Network | 5-15 min |
| `Deep` | Full DISM + Defender scan | 30-60 min |
| `Full` | Everything + restore point | 45-90 min |
| `Gaming` | Service optimization | 2-5 min |
| `Network` | Complete network reset | 5-10 min |
| `Security` | Defender + Updates | 15-30 min |
| `Maintenance` | Cleanup + component store | 10-20 min |

---

## Important Notes

### Always Run as Administrator
All tools require elevated privileges to modify system settings.

### Create Restore Points
Before major changes, the suite can create system restore points automatically.

### Reboot Required
Many fixes require a reboot to take full effect. The tools will prompt when needed.

### Windows Versions
- Primary target: Windows 10/11
- Some tools work on Windows 7/8
- Registry files tested on Windows 10 21H2+

---

## Safety Features

- **Admin check**: Won't run without elevation
- **Restore points**: Automatic backup creation
- **Non-destructive**: Fixes are reversible
- **Logging**: All operations logged
- **Confirmations**: Critical actions ask for confirmation

---

## Troubleshooting

See `docs/TROUBLESHOOTING.md` for common issues and solutions.

---

## Credits

- Performance tweaks adapted from AskVG/Vishal Gupta
- Service configurations based on Microsoft defaults
- Gaming optimizations from various Windows communities

---

## License

Free for personal and commercial use. Modify as needed for your organization.

---

**Created for Monday's Players** | Version 2.0