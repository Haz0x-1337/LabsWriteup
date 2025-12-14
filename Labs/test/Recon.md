# NMAP

##### Default Scan

```bash
sudo nmap -sC -sV -oN DefaultScan.txt -Pn 
```

##### Full Scan

```bash
sudo nmap -sV -p- --min-rate 5000 -T4 -Pn -oA FullScan.txt
```

##### UDP Scan

```bash
sudo nmap -sU --top-ports 20 -Pn -oN UDPScan.txt
```

#### Findings



