# Troubleshooting Guide

Common issues and solutions when using Windows Repair Suite.

---

## General Issues

### "Access Denied" Errors
**Problem:** Tools fail with access denied
**Solution:** 
- Right-click → Run as Administrator
- Ensure UAC is not completely disabled

### Tools Won't Start
**Problem:** Scripts don't execute
**Solution:**
- Check Windows Script Host is enabled
- Ensure .bat/.reg file associations are correct
- Run from local drive (not network share)

### Changes Don't Apply
**Problem:** Registry changes don't take effect
**Solution:**
- Reboot required for most registry changes
- Some changes need Explorer restart: `taskkill /f /im explorer.exe & start explorer`

---

## System Repairs

### SFC "Found corrupt files but couldn't fix"
**Solution:**
1. Run Windows-Update-Repair.bat first
2. Then run System-File-Repair.bat with "Deep Repair" option
3. If still failing, may need Windows install media for source files

### DISM "Source files not found"
**Solution:**
```cmd
# Mount Windows ISO and use as source:
DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:D:\sources\install.wim:1
```

### Windows Update Stuck
**Solution:**
1. Run Windows-Update-Repair.bat
2. Restart in Safe Mode, run again
3. Check Windows Update Troubleshooter in Settings

---

## Network Issues

### No Internet After Network Reset
**Solution:**
1. Restart computer
2. Check network adapter in Device Manager
3. Run: `netsh int ip reset` again
4. Check Windows Network Troubleshooter

### DNS Issues Persist
**Solution:**
```cmd
# Set DNS manually:
netsh interface ip set dns "Wi-Fi" static 8.8.8.8
netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2
```

---

## Performance Issues

### Gaming Tweaks Caused Problems
**Solution:**
1. Run Gaming-Optimizer.bat
2. Select option 6 "Restore Default Settings"
3. Reboot

### System Unstable After Service Changes
**Solution:**
1. Import `registry/Default-Services-Win10.reg`
2. Reboot
3. Re-apply only specific tweaks needed

### Boot Loop After Registry Changes
**Solution:**
1. Boot from Windows install media
2. Open Command Prompt (Shift+F10)
3. Load registry hive and restore from backup:
```cmd
reg load HKLM\Temp C:\Windows\System32\config\SOFTWARE
reg restore HKLM\Temp C:\Path\To\Backup.reg
```

---

## Security Issues

### Defender Won't Start
**Solution:**
```cmd
# Check service:
sc query WinDefend

# Re-register:
regsvr32.exe /u "%ProgramFiles%\Windows Defender\MpClient.dll"
regsvr32.exe "%ProgramFiles%\Windows Defender\MpClient.dll"

# Or use Windows Security Troubleshooter in Settings
```

### Can't Run MSRT
**Solution:**
- Download latest version from Microsoft
- Run in Safe Mode

---

## Recovery Options

### System Restore Point Not Available
**Solution:**
```cmd
# Enable System Restore:
wmic /Namespace:\\root\default Path SystemRestore Call Enable C:\
```

### Create Manual Restore Point
**Solution:**
```cmd
wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="Manual", RestorePointType=12
```

### Undo All Changes
**Solution:**
1. Boot to Safe Mode
2. Import original service registry
3. System Restore to point before repairs

---

## Performance Monitoring

### Check What's Slowing System
```cmd
# Resource usage:
resmon

# Boot analysis:
winsat formal

# Check startup impact:
taskmgr /0 /startup
```

---

## Getting Help

If issues persist:

1. Run diagnostics: `diagnostics/System-Diagnostics.bat`
2. Generate report and review
3. Check Windows Event Viewer for specific errors
4. Search error codes on Microsoft Support

---

## Preventive Measures

Before running extensive repairs:

1. ✅ Create System Restore Point
2. ✅ Backup important data
3. ✅ Note current settings
4. ✅ Have Windows install media ready
5. ✅ Ensure stable power (laptops plugged in)