# 🛡️ Sysmon + PowerShell Email Alert System (Windows Setup Guide)

This project sets up a complete incident detection system using **Sysmon** and **PowerShell** on Windows. It watches for **elevated PowerShell usage** (admin-level activity) and sends a **real-time Gmail alert** when triggered.

---

## ✅ Prerequisites

- 🖥️ Windows 10 or 11 (Admin access required)
- 📥 PowerShell 5.1+ (installed by default)
- 🔐 Gmail account with:
  - 2-Step Verification (2FA) enabled
  - App Password created

---

## 🧰 Step 1: Download & Install Sysmon

### 1. Download Sysmon

📦 Get it here:  
https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon

- Extract the contents (e.g., `Sysmon64.exe`) to:  
  `C:\Sysmon`

### 2. Download a Configuration File

Use a community config like SwiftOnSecurity's:  
https://github.com/SwiftOnSecurity/sysmon-config

- Download the `sysmonconfig-export.xml` file
- Move it to `C:\Sysmon`

### 3. Install Sysmon

Open **PowerShell as Administrator** and run:

```powershell
cd C:\Sysmon
.\Sysmon64.exe -accepteula -i sysmonconfig-export.xml
