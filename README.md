# Read Me

Hashes of the script:
- MD5: bf0c60d4b0945f71e173dbcde1bf1a2d
- SHA-1: bcf5b0d885fe4702e99781517a936546a1f8ab6e
- SHA-256: 9d540a9c9482c55abed05a15baf5f9df210d65ec87bddfa4bed958eecfdc501e

This script automates several modes of the lynis tool. These modes are 
  - audit system
  - audit system --pentest
  - audit system --forensics
    
The system that will be auditited will be a remote system. This script utilizes ssh for remote administration. 

# Download and Execute the Script
To download the script enter:
- git clone https://github.com/djpsabados/audit.git

Navigate to the directory 'audit': 
- cd audit

Make the script executeble:
- chmod +x audit_lynis.sh (or sudo chmod +x audit_lynis.sh if you need elevated priveleges)

Execute the script: 
- ./lynis_audit.sh (or sudo ./lynis_audit.sh)

Follow the prompts and enter your desired information.



