# Email Configuration
$EmailFrom = "yourEmail@gmail.com"
$EmailTo = "userEmail@gmail.com"
$EmailSubject = "Sysmon Alert Detected!"
$SmtpServer = "smtp.gmail.com"
$SmtpPort = 587
$EmailUser = "yourEmail@gmail.com"
$EmailPassword = "YourPassword"  # Gmail App Password

# Convert Email Credentials
$securePass = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($EmailUser, $securePass)

function Send-EmailAlert($subject, $body) {
    Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $subject `
        -Body $body -SmtpServer $SmtpServer -Port $SmtpPort -UseSsl -Credential $cred
}

function Check-AdminPowerShell($details) {
    if ($details -match '(?i)Image:\s*(.+powershell.exe)' -and $details -match 'IntegrityLevel:\s*High') {
        Send-EmailAlert "Admin PowerShell Detected!" $details
        Write-Host "`n[ALERT] Admin PowerShell Detected!" -ForegroundColor Cyan
[console]::Out.Flush()
    }
}

function Check-UnsignedScript($details) {
    if ($details -match '(?i)CommandLine:\s*(.+\.ps1)' -and $details -match 'IntegrityLevel:\s*High') {
        Send-EmailAlert "Unsigned PowerShell Script Executed!" $details
        Write-Host "`n[ALERT] Unsigned PowerShell Script Detected!" -ForegroundColor Yellow
[console]::Out.Flush()
    }
}

function Check-SystemFileChange($details) {
    if ($details -match 'TargetFilename:\s*C:\\Windows\\System32\\') {
        Send-EmailAlert "System File Change Detected!" $details
        Write-Host "`n[ALERT] System File Change Detected!" -ForegroundColor Red
[console]::Out.Flush()
    }
}

function Check-SuspiciousNetwork($details) {
    if ($details -match '(?i)Image:\s*(.*(powershell\.exe|cmd\.exe|nc\.exe|ping\.exe))') {
        Send-EmailAlert "Suspicious Network Activity Detected!" $details
        Write-Host "`n[ALERT] Suspicious Network Connection Detected!" -ForegroundColor Magenta
[console]::Out.Flush()
    }
}


# Event Monitoring Setup
$seen = @{}
Write-Host "Monitoring Sysmon logs for Event IDs 1 (Process), 3 (Network), 11 (File)...`n" -ForegroundColor Green

while ($true) {
    $filters = @(
        @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; ID = 1 },   # Process Creation
        @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; ID = 3 },   # Network Connection
        @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; ID = 11 }   # File Create
    )

    foreach ($filter in $filters) {
        Get-WinEvent -FilterHashtable $filter -MaxEvents 10 | ForEach-Object {
            if (-not $seen.ContainsKey($_.RecordId)) {
                $seen[$_.RecordId] = $true
                $event = $_
                $details = $event.Message

                switch ($event.Id) {
                    1  { Check-AdminPowerShell $details; Check-UnsignedScript $details }
                    3  { Check-SuspiciousNetwork $details }
                    11 { Check-SystemFileChange $details }
                }
            }
        }
    }
    Start-Sleep -Seconds 3
}
