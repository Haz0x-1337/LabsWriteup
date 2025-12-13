#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== New Lab Note Generator ===${NC}\n"

# Machine Name
read -p "Machine Name: " machine_name

# Platform
echo -e "\n${BLUE}Platform:${NC}"
echo "1) HTB"
echo "2) TryHackMe"
echo "3) VulnHub"
echo "4) Other"
read -p "Select (1-4): " platform_choice

case $platform_choice in
    1) platform="HTB"; platform_tag="htb" ;;
    2) platform="TryHackMe"; platform_tag="thm" ;;
    3) platform="VulnHub"; platform_tag="vulnhub" ;;
    4) read -p "Enter platform: " platform; platform_tag=$(echo "$platform" | tr '[:upper:]' '[:lower:]') ;;
esac

# OS
echo -e "\n${BLUE}Operating System:${NC}"
echo "1) Linux"
echo "2) Windows"
echo "3) Other"
read -p "Select (1-3): " os_choice

case $os_choice in
    1) os="Linux"; os_tag="linux" ;;
    2) os="Windows"; os_tag="windows" ;;
    3) read -p "Enter OS: " os; os_tag=$(echo "$os" | tr '[:upper:]' '[:lower:]') ;;
esac

# Difficulty
echo -e "\n${BLUE}Difficulty:${NC}"
echo "1) Easy"
echo "2) Medium"
echo "3) Hard"
echo "4) Insane"
read -p "Select (1-4): " diff_choice

case $diff_choice in
    1) difficulty="Easy"; diff_tag="easy" ;;
    2) difficulty="Medium"; diff_tag="medium" ;;
    3) difficulty="Hard"; diff_tag="hard" ;;
    4) difficulty="Insane"; diff_tag="insane" ;;
esac

# Target IP (optional)
read -p "Target IP (press Enter to skip): " target_ip
target_ip=${target_ip:-"TARGET_IP"}

# Get current date
current_date=$(date +"%Y-%m-%d")

# Create Labs directory if it doesn't exist
mkdir -p Labs

# Sanitize filename
filename=$(echo "$machine_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
filepath="Labs/${filename}.md"

# Check if file exists
if [ -f "$filepath" ]; then
    read -p "${YELLOW}File already exists. Overwrite? (y/n): ${NC}" overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Aborting..."
        exit 0
    fi
fi

# Create the markdown file
cat > "$filepath" <<EOF
---
platform: ${platform}
os: ${os}
difficulty: ${difficulty}
date: ${current_date}
status: active
tags: [${platform_tag}, ${os_tag}, ${diff_tag}]
---

# ${machine_name}

## Machine Info
- **Platform:** ${platform}
- **OS:** ${os}
- **Difficulty:** ${difficulty}
- **Target IP:** ${target_ip}
- **Date Started:** ${current_date}

## Links
- **Techniques Used:**
- **Tools Used:**

---

## Reconnaissance

### Initial Scans

\`\`\`bash

# Add reconnaissance commands

\`\`\`

**Findings:**
-

---

## Enumeration

### Nmap Results

#### Default Scan

\`\`\`bash

nmap -sC -sV -oA InitialScan ${target_ip}

\`\`\`

#### All Ports Scan

\`\`\`bash

nmap -sC -sV -p- --min-rate 5000 -T4 -Pn -oA AllScan ${target_ip}

\`\`\`

#### UDP Scan

\`\`\`bash

nmap -sU --top-ports 20 -oA UDPScan ${target_ip}

\`\`\`


### Service Enumeration

#### Port XX - Service

\`\`\`bash

# Enumeration commands

\`\`\`

**Findings:**
-

---

## Initial Access

### Vulnerability
- **Type:**
- **Description:**

### Exploitation

\`\`\`bash

# Exploitation steps

\`\`\`

**Shell Access:**
- User:
- Method:

---

## Privilege Escalation

### Enumeration

\`\`\`bash

# Privilege escalation enumeration

\`\`\`

### Method
- **Technique:**
- **Description:**

### Exploitation

\`\`\`bash

# Commands executed

\`\`\`

---

## Flags

- **User Flag:** \`\`
- **Root Flag:** \`\`

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
EOF

echo -e "\n${GREEN}✓ Lab note created successfully!${NC}"
echo -e "Location: ${YELLOW}$filepath${NC}"
echo -e "\n${BLUE}Open it in Obsidian to start taking notes!${NC}"
