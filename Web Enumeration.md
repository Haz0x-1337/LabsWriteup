##### Directories 

```bash

ffuf -u http://TARGET/FUZZ -w wordlists/dir.txt 
gobuster dir -u http://TARGET -w wordlists/dir.txt 

```

##### Subdomains

```bash

ffuf -u http://FUZZ.target.com -w wordlists/subdomains.txt 
gobuster dns -d target.com -w wordlists/subdomains.txt

```

##### Vhosts

```bash

ffuf -u http://target.com -w wordlists/vhosts.txt -H "Host: FUZZ.target.com" 
gobuster vhost -u http://target.com -w wordlists/vhosts.txt

```

##### File extensions

```bash

ffuf -u http://TARGET/FUZZ -w wordlists/dir.txt -e .php,.txt,.js,.aspx 
gobuster dir -u http://TARGET -w wordlists/dir.txt -x php,txt,js,aspx 

```
