##### Basic SMB share enumeration

```bash

smbclient -L //<TARGET_IP> -N

```

##### Enumerate SMB with credentials 

```bash

smbclient -L //<TARGET_IP> -U user

```

##### List files in a share

```bash
 
smbclient //<TARGET_IP>/SHARE -N

```

##### CrackMapExec

```bash

crackmapexec smb <TARGET_IP>

```

##### With Creds

```bash

crackmapexec smb <TARGET_IP> -u user -p pass --shares

```

##### Password Spray

```bash

crackmapexec smb <TARGET_IP> -u users.txt -p 'Password123'

```

##### Null Session

```bash

rpcclient -U "" <TARGET_IP>

```