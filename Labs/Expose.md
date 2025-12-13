---
platform: TryHackMe
os: Linux
difficulty: Easy
date: 2025-12-14
status: active
tags: [thm, linux, easy]
---

# Expose

## Machine Info

- **Platform:** TryHackMe
- **OS:** Linux
- **Difficulty:** Easy
- **Target IP:** 10.49.152.202
- **Date Started:** 2025-12-14

## Links

- **Techniques
- Used:** 
- **Tools Used:** 

---
## Enumeration

### Nmap Results

#### Default Scan

```bash

nmap -sC -sV -oA InitialScan 10.49.152.202

PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 2.0.8 or later
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:192.168.133.134
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 2
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 78:73:27:f4:23:60:0d:b0:3a:89:6e:1f:5c:01:9a:c1 (RSA)
|   256 4c:40:9e:64:38:36:99:13:29:c7:1a:55:1e:16:7e:a2 (ECDSA)
|_  256 31:f5:bc:c5:57:37:2b:af:38:3f:c4:ca:fa:6d:7d:5e (ED25519)
53/tcp open  domain  ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

#### All Ports Scan

```bash

nmap -sC -sV -p- --min-rate 5000 -T4 -Pn -oA AllScan 10.49.152.202

PORT     STATE SERVICE                 VERSION
21/tcp   open  ftp                     vsftpd 2.0.8 or later
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:192.168.133.134
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 1
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
22/tcp   open  ssh                     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 78:73:27:f4:23:60:0d:b0:3a:89:6e:1f:5c:01:9a:c1 (RSA)
|   256 4c:40:9e:64:38:36:99:13:29:c7:1a:55:1e:16:7e:a2 (ECDSA)
|_  256 31:f5:bc:c5:57:37:2b:af:38:3f:c4:ca:fa:6d:7d:5e (ED25519)
53/tcp   open  domain                  ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
1337/tcp open  http                    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: EXPOSED
|_http-server-header: Apache/2.4.41 (Ubuntu)
1883/tcp open  mosquitto version 1.6.9
| mqtt-subscribe: 
|   Topics and their most recent payloads: 
|     $SYS/broker/clients/disconnected: 0
|     $SYS/broker/store/messages/bytes: 181
|     $SYS/broker/clients/inactive: 0
|     $SYS/broker/load/sockets/5min: 0.39
|     $SYS/broker/heap/current: 49448
|     $SYS/broker/load/sockets/15min: 0.13
|     $SYS/broker/load/bytes/received/15min: 3.45
|     $SYS/broker/messages/sent: 2
|     $SYS/broker/load/messages/sent/5min: 0.39
|     $SYS/broker/load/bytes/received/1min: 47.51
|     $SYS/broker/load/connections/5min: 0.39
|     $SYS/broker/store/messages/count: 53
|     $SYS/broker/load/messages/sent/15min: 0.13
|     $SYS/broker/clients/connected: 1
|     $SYS/broker/load/messages/received/15min: 0.13
|     $SYS/broker/load/bytes/sent/1min: 7.31
|     $SYS/broker/messages/stored: 53
|     $SYS/broker/bytes/sent: 8
|     $SYS/broker/messages/received: 2
|     $SYS/broker/clients/total: 1
|     $SYS/broker/load/messages/sent/1min: 1.83
|     $SYS/broker/version: mosquitto version 1.6.9
|     $SYS/broker/uptime: 143 seconds
|     $SYS/broker/retained messages/count: 53
|     $SYS/broker/load/sockets/1min: 1.67
|     $SYS/broker/load/bytes/received/5min: 10.21
|     $SYS/broker/clients/active: 1
|     $SYS/broker/load/messages/received/1min: 1.83
|     $SYS/broker/load/connections/15min: 0.13
|     $SYS/broker/load/bytes/sent/5min: 1.57
|     $SYS/broker/load/bytes/sent/15min: 0.53
|     $SYS/broker/load/connections/1min: 1.83
|     $SYS/broker/heap/maximum: 49960
|     $SYS/broker/bytes/received: 52
|     $SYS/broker/load/messages/received/5min: 0.39
|_    $SYS/broker/clients/maximum: 1
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

#### UDP Scan

```bash

nmap -sU --top-ports 20 -oA UDPScan 10.49.152.202

PORT      STATE         SERVICE
53/udp    open          domain
67/udp    closed        dhcps
68/udp    open|filtered dhcpc
69/udp    closed        tftp
123/udp   closed        ntp
135/udp   closed        msrpc
137/udp   closed        netbios-ns
138/udp   closed        netbios-dgm
139/udp   closed        netbios-ssn
161/udp   closed        snmp
162/udp   closed        snmptrap
445/udp   closed        microsoft-ds
500/udp   closed        isakmp
514/udp   closed        syslog
520/udp   closed        route
631/udp   closed        ipp
1434/udp  closed        ms-sql-m
1900/udp  closed        upnp
4500/udp  closed        nat-t-ike
49152/udp closed        unknown
```

### Service Enumeration

#### Port 21 - Service

```bash

# Enumeration commands
ftp 10.49.152.202 21 

Name (10.49.152.202:haz0x): Anonymous
331 Please specify the password.
Password: 
230 Login successful.

ftp> ls -la
229 Entering Extended Passive Mode (|||41000|)
150 Here comes the directory listing.
drwxr-xr-x    2 0        121          4096 Jun 11  2023 .
drwxr-xr-x    2 0        121          4096 Jun 11  2023 ..
226 Directory send OK.

ftp> put test.txt
local: test.txt remote: test.txt
229 Entering Extended Passive Mode (|||36722|)
550 Permission denied.

```

**Findings:**
-  Anonymous login is enabled
-  Empty Directory
-  PUT is not allowed

------ 
## Initial Access

### Vulnerability
- **Type:** 
- **Description:** 

### Exploitation

```bash

# Exploitation steps

```

**Shell Access:**
- User: 
- Method: 

---

## Privilege Escalation

### Enumeration

```bash

# Privilege escalation enumeration

```

### Method
- **Technique:** 
- **Description:** 

### Exploitation

```bash

# Commands executed

```

---

## Flags

- **User Flag:** ``
- **Root Flag:** ``

---

## Key Takeaways

1. 
2. 
3. 

---

## Related Boxes
- [[]]

---

## References
- 
