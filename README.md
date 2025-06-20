# 🛡️ Sysmon + PowerShell Email Alert System

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
```
✅ This activates Sysmon event logging.

Check logs in:
Event Viewer → Applications and Services Logs → Microsoft → Windows → Sysmon → Operational

##💻 Step 2: Set Up the Alert Script
###1. Create a Working Directory
```powershell
mkdir C:\SysmonAlert
```
###2. Move Your PowerShell Script
Place your app.ps1 in `C:\SysmonAlert`.

###3. Edit Email Settings in app.ps1
Update the following fields with your Gmail details:

```powershell
$EmailFrom = "your@gmail.com"
$EmailTo = "recipient@gmail.com"
$EmailUser = "your@gmail.com"
$EmailPassword = "your_app_password"  # Use App Password!
```
###📧 Step 3: Gmail App Password Setup
####1. Enable 2-Step Verification
Go to:
`https://myaccount.google.com/security`

Enable 2-Step Verification under "Signing in to Google".

####2. Generate App Password
In the same Security settings, go to App passwords

Choose:

App: `Mail`

Device: `Windows Computer`

Click Generate

Copy the 16-digit password (e.g., abcd efgh ijkl mnop)

Paste it into the `$EmailPassword` field (no spaces)

✅ This secures your script with Gmail’s SMTP.

##🏃‍♂️ Step 4: Run the Alert Script
Open PowerShell as Administrator:

```powershell
cd C:\SysmonAlert
.\app.ps1
```
Expected output:
```powershell
[+] Monitoring for elevated PowerShell sessions...
```
##🧪 Step 5: Test the Alert
Open a new PowerShell window as Administrator:

```powershell
Start-Process powershell -Verb runAs
```
Expected result:

```Console displays:
[ALERT] Admin PowerShell Detected!
```
`You receive an email with alert details`
