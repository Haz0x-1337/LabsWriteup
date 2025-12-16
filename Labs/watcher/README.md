# Watcher

**Difficulty:** Medium  
**Platform:** TryHackMe  
**Date:** 2025-12-16

---

## Overview

A boot2root Linux machine utilising web exploits along with some common privilege escalation techniques.

---

## Phases

- [[Recon]]
- [[Enumeration-Exploitation]]
- [[Foothold]]
- [[Post-Exploitation]]
- [[Privilege-Escalation]]

---

## Tools Used

- NMAP
- GoBuster
- Steganography Tools

---

## Techniques Used

- Local File Inclusion
- Encoding/Decoding
- File Upload to RCE
- Cronjob Hijacking
- Exploiting user scripts
- Library Hijacking 

---

## Flags

**Flag 1:** FLAG{robots_dot_text_what_is_next}
**Flag 2:** FLAG{ftp_you_and_me}
**Flag 3:** FLAG{lfi_what_a_guy}
**Flag 4:** FLAG{chad_lifestyle}
**Flag 5:** FLAG{live_by_the_cow_die_by_the_cow}
**Flag 6:** FLAG{but_i_thought_my_script_was_secure}
**Flag 7:** FLAG{who_watches_the_watchers}



---

## Key Takeaways

1. Learned new way of uploading files through `FTP`. `curl -T test.txt ftp://10.48.158.241/files/test.txt --user ftpuser:givemefiles777`
2. It's possible to hijack a python script if it is running writable libraries
3. Persistence by creating authorized keys for SSH

