# 🛡️ Sysmon Alerting System with PowerShell + Email Notifications

This project is a lightweight incident detection system using **Sysmon** (System Monitor by Microsoft) and a custom **PowerShell script**. It monitors for **elevated PowerShell usage** (e.g., attackers running PowerShell as administrator) and sends **real-time email alerts** when such events occur.

---

## 🚀 Features

- 🧠 Monitors Sysmon logs for suspicious activity
- ⚠️ Detects high-integrity PowerShell sessions
- 📩 Sends email alerts with detailed information
- 🔐 Secure Gmail-based SMTP (with 2FA & app passwords)
- 🛠️ Easily customizable for different detection patterns

---

## 📦 Requirements

- 🖥️ Windows 10/11 or Server
- 🐚 PowerShell 5.1+ (default on modern Windows)
- 🧰 [Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- 📧 Gmail account with:
  - 2FA enabled
  - App password created

---

## 🛠️ Installation Guide

### 1️⃣ Install Sysmon

1. Download Sysmon from the official Microsoft site:  
   👉 https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon

2. Extract `Sysmon64.exe` or `Sysmon.exe` to `C:\Sysmon`

3. Use a Sysmon config (e.g., from SwiftOnSecurity):  
   👉 https://github.com/SwiftOnSecurity/sysmon-config

4. Install Sysmon with the config (run as Administrator):

```powershell
cd C:\Sysmon
.\Sysmon64.exe -accepteula -i sysmonconfig.xml
