# CheeseCTFv10

**Difficulty:** Easy  
**Platform:** TryHackMe  
**Date:** 2025-12-15

---

## Overview

Inspired by the great cheese talk of THM!

---

## Phases

- [[Recon]]
- [[Enumeration-Exploitation]]
- [[Foothold]]
- [[Post-Exploitation]]
- [[Privilege-Escalation]]

---

## Tools Used

-  NMAP
-  GoBuster
-  PHP Filter Chain Script
-  GTFObins

---

## Techniques Used

-  Local File Inclusion
-  SQL Injection
- PHP Filter Chains

---

## Flags

**User Flag:** `THM{9f2ce3df1beeecaf695b3a8560c682704c31b17a}`   
**Root Flag:** `THM{dca75486094810807faf4b7b0a929b11e5e0167c}`

---

## Key Takeaways

1. Usage of your own public key to access users via ssh. Works when you have write permission on target user's .ssh authorized_keys file.
2. Advance obfuscation using PHP Filter Chains and abusing PHP's convert.iconv filters
3. Advance SQLi payloads to bypass SQL commands filtering

