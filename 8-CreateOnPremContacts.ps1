#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

$logfile = "8_errors_$(Get-Date -Format yyyyMMddTHHmmssffff).txt"
$OU = Read-Host -Prompt 'OU for on prem group contacts'
$proxyAddresses = Import-Csv .\distributiongroups-SMTPproxy.csv
$groups = Import-Csv .\distributiongroups.csv | ? {$_.PrimarySmtpAddress -like "*dc*"}

foreach($group in $groups){
    try
    {
        $routingAddress = $null
        $contactAddresses = $null
        $contactAddresses = $group.EmailAddresses -split ";"
        $routingAddress = $contactAddresses | ? {($_ -like "*mail.onmicrosoft*")}
        
        if($routingAddress)
        {
            Write-Host "Working on: " $group.Name
            #Added logic to add "onmicrosoft" address instead of Primary SMTP
            New-MailContact -Name $group.Name -ExternalEmailAddress $routingAddress -OrganizationalUnit $OU
        }
    }

    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red "Error: " $_.Exception.Message
        #error to log
        Write-Output "Error: " $_.Exception.Message | Out-File $logFile -Append
    }
}
