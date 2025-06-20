$EmailFrom = "abood.jallad.2001@gmail.com"
$EmailTo = "abdalrahmanjallad001@gmail.com"
$EmailSubject = " Sysmon Alert Detected!"
$SmtpServer = "smtp.gmail.com"
$SmtpPort = 587
$EmailUser = "abood.jallad.2001@gmail.com"

$EmailPassword = "jzcclwzgudvhfplo"  



$filter = @{
    LogName = 'Microsoft-Windows-Sysmon/Operational'
    ID      = 1 
}

function Send-EmailAlert($body) {
    $securePass = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($EmailUser, $securePass)

    Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject `
        -Body $body -SmtpServer $SmtpServer -Port $SmtpPort -UseSsl -Credential $cred
}


$seen = @{}

Write-Host "Monitoring Sysmon logs for Event ID 1 (Process Creation)..."

while ($true) {
    Get-WinEvent -FilterHashtable $filter -MaxEvents 10 | ForEach-Object {
        if (-not $seen.ContainsKey($_.RecordId)) {
            $seen[$_.RecordId] = $true

            $event = $_
            $details = $event.Message

            # Filter: PowerShell (powershell.exe) AND IntegrityLevel High (Admin)
            if ($details -match '(?i)Image:\s*(.+powershell.exe)' -and $details -match 'IntegrityLevel:\s*High') {
                Write-Host "`nALERT detected at $(Get-Date):`n$details" -ForegroundColor Blue
                Send-EmailAlert $details
            }
            else {
                Write-Host "Ignored non-admin PowerShell or other process"
            }
        }
    }

    Start-Sleep -Seconds 3
}
