# Run this script in PowerShell **as Administrator** to allow phones on Wi-Fi to reach Rails on port 3000.
# Right-click PowerShell → Run as administrator, then:
#   cd "C:\Users\Darshan\StudioProjects\E-Book app\scripts"
#   .\allow-rails-port-3000.ps1

$ruleName = "Rails Ebook API 3000"

$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if ($existing) {
  Write-Host "Firewall rule '$ruleName' already exists."
} else {
  New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3000
  Write-Host "Firewall rule '$ruleName' created."
}

Write-Host "Test from phone browser: http://YOUR_PC_IP:3000/api/v1/health"
