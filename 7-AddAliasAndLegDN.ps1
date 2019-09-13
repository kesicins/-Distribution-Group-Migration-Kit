#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

$logfile = "7_errors_$(Get-Date -Format yyyyMMddTHHmmssffff).txt"

#add aliases
$ALIASES = Import-Csv distributiongroups-SMTPproxy.csv
$aliasCount = $ALIASES.count
$ALIASES | % {
    try
    {
        Write-Host "Remaining aliases:"$aliasCount
        Set-DistributionGroup -Identity $_.PrimarySmtpAddress -EmailAddresses @{Add=$_.TYPE}
        $aliasCount--
    }

    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red "Error: " $_.Exception.Message
        #error to log
        Write-Output "Error: " $_.Exception.Message | Out-File $logFile -Append
    }
}
 
#add LegacyExchangeDN as x500
$x500 = Import-Csv distributiongroups.csv 
$x500count = $x500.count
$x500 | % {
    try
    {
        Write-Host "Remaining x500's:"$x500count
        $smtp = $_.PrimarySmtpAddress
        $LegacyExchangeDN = "x500:"+$_.LegacyExchangeDN
        Set-DistributionGroup $smtp -EmailAddresses @{Add=$LegacyExchangeDN}
        $x500count--
    }

    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red "Error: " $_.Exception.Message
        #error to log
        Write-Output "Error: " $_.Exception.Message | Out-File $logFile -Append
    }
}

