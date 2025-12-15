# NMAP

##### Default Scan

```bash
sudo nmap -sC -sV -oN DefaultScan.txt -Pn 
PORT   STATE SERVICE VERSION
21/tcp open  ftp?
|_ftp-anon: ERROR: Script execution failed (use -d to debug)
|_ftp-syst: ERROR: Script execution failed (use -d to debug)
|_tls-alpn: ERROR: Script execution failed (use -d to debug)
|_ftp-bounce: ERROR: Script execution failed (use -d to debug)
|_ssl-date: ERROR: Script execution failed (use -d to debug)
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, X11Probe: 
|_    550 12345 0f7000f800770008777000000000000000f80008f7f70088000cf00
|_ssl-cert: ERROR: Script execution failed (use -d to debug)
|_tls-nextprotoneg: ERROR: Script execution failed (use -d to debug)
|_sslv2: ERROR: Script execution failed (use -d to debug)
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 2c:21:25:26:bc:f4:61:22:11:9b:2d:ed:11:fa:48:f3 (RSA)
|   256 fd:92:20:c3:57:c8:48:0e:4a:03:fe:ff:94:2f:7c:4d (ECDSA)
|_  256 a0:f8:bc:04:85:34:ef:c5:88:87:1d:3b:02:88:a2:78 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: The Cheese Shop
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
|_http-server-header: Apache/2.4.41 (Ubuntu)

```

##### Full Scan

```bash
sudo nmap -sV -p- --min-rate 5000 -T4 -Pn -oA FullScan.txt

PORT   STATE SERVICE VERSION
21/tcp open  ftp?
|_ftp-anon: ERROR: Script execution failed (use -d to debug)
|_ftp-syst: ERROR: Script execution failed (use -d to debug)
|_tls-alpn: ERROR: Script execution failed (use -d to debug)
|_ftp-bounce: ERROR: Script execution failed (use -d to debug)
|_ssl-date: ERROR: Script execution failed (use -d to debug)
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, X11Probe: 
|_    550 12345 0f7000f800770008777000000000000000f80008f7f70088000cf00
|_ssl-cert: ERROR: Script execution failed (use -d to debug)
|_tls-nextprotoneg: ERROR: Script execution failed (use -d to debug)
|_sslv2: ERROR: Script execution failed (use -d to debug)
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 2c:21:25:26:bc:f4:61:22:11:9b:2d:ed:11:fa:48:f3 (RSA)
|   256 fd:92:20:c3:57:c8:48:0e:4a:03:fe:ff:94:2f:7c:4d (ECDSA)
|_  256 a0:f8:bc:04:85:34:ef:c5:88:87:1d:3b:02:88:a2:78 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: The Cheese Shop
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
|_http-server-header: Apache/2.4.41 (Ubuntu)

```

##### UDP Scan

```bash
sudo nmap -sU --top-ports 20 -Pn -oN UDPScan.txt

PORT      STATE         SERVICE
53/udp    closed        domain
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

Nmap done: 1 IP address (1 host up) scanned in 18.46 seconds

```

#### Findings

- FTP
- SSH
- HTTP

---





