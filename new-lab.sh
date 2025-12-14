#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== New Lab Note Generator ===${NC}\n"

# Room Name
read -p "Room Name: " room_name

# Difficulty
echo -e "\n${BLUE}Difficulty:${NC}"
echo "1) Easy"
echo "2) Medium"
echo "3) Hard"
read -p "Select (1-4): " diff_choice

case $diff_choice in
    1) difficulty="Easy" ;;
    2) difficulty="Medium" ;;
    3) difficulty="Hard" ;;
    4) difficulty="Insane" ;;
esac

# Platform
echo -e "\n${BLUE}Platform:${NC}"
echo "1) HTB"
echo "2) TryHackMe"
echo "3) VulnHub"
echo "4) Other"
read -p "Select (1-4): " platform_choice

case $platform_choice in
    1) platform="HTB" ;;
    2) platform="TryHackMe" ;;
    3) platform="VulnHub" ;;
    4) read -p "Enter platform: " platform ;;
esac

# Get current date
current_date=$(date +"%Y-%m-%d")

# Sanitize folder name
foldername=$(echo "$room_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
folderpath="Labs/${foldername}"

# Check if folder exists
if [ -d "$folderpath" ]; then
    read -p "${YELLOW}Folder already exists. Overwrite? (y/n): ${NC}" overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Aborting..."
        exit 0
    fi
    rm -rf "$folderpath"
fi

# Create folder structure
mkdir -p "$folderpath"

# Create README.md
cat > "$folderpath/README.md" <<EOF
# ${room_name}

**Difficulty:** ${difficulty}  
**Platform:** ${platform}  
**Date:** ${current_date}

---

## Overview



---

## Phases

- [[Recon]]
- [[Enumeration]]
- [[Foothold]]
- [[Post-Exploitation]]
- [[Privilege-Escalation]]

---

## Tools Used

- 

---

## Techniques Used

- 

---

## Flags

**User Flag:** \`\`  
**Root Flag:** \`\`

---

## Key Takeaways

1. 
2. 
3. 

EOF

# Create phase files
cat > "$folderpath/Recon.md" <<EOF
# NMAP

##### Default Scan

\`\`\`bash
sudo nmap -sC -sV -oN DefaultScan.txt -Pn 
\`\`\`

##### Full Scan

\`\`\`bash
sudo nmap -sV -p- --min-rate 5000 -T4 -Pn -oA FullScan.txt
\`\`\`

##### UDP Scan

\`\`\`bash
sudo nmap -sU --top-ports 20 -Pn -oN UDPScan.txt
\`\`\`

#### Findings



EOF

cat > "$folderpath/Enumeration.md" <<EOF
# Port X - Service

\`\`\`bash

\`\`\`

# Port X - Service

\`\`\`bash

\`\`\`

# Port X - Service

\`\`\`bash

\`\`\`

EOF

cat > "$folderpath/Foothold.md" <<EOF

EOF

cat > "$folderpath/Post-Exploitation.md" <<EOF

EOF

cat > "$folderpath/Privilege-Escalation.md" <<EOF

EOF

echo -e "\n${GREEN}✓ Lab folder created successfully!${NC}"
echo -e "Location: ${YELLOW}$folderpath${NC}"
echo -e "\n${BLUE}Files created:${NC}"
echo -e "  - README.md"
echo -e "  - Recon.md"
echo -e "  - Enumeration.md"
echo -e "  - Foothold.md"
echo -e "  - Post-Exploitation.md"
echo -e "  - Privilege-Escalation.md"
echo -e "\n${BLUE}Open the folder in Obsidian to start taking notes!${NC}"
