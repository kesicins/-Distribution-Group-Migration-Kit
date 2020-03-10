#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

$logfile = "5_errors_$(Get-Date -Format yyyyMMddTHHmmssffff).txt"

$RENAMEDG = Import-Csv distributiongroups.csv
$count = $RENAMEDG.count
$RENAMEDG | % {
    try
    {
        $NEWName = $($_.NEWName -replace '\s','')[0..63] -join "" # remove spaces first, then truncate to first 64 characters
        $Name = $_.Name
        $Alias = $_.Alias
        $DisplayName = $_.DisplayName
        $PrimarySmtpAddress = $_.PrimarySmtpAddress
	    $Hidden = [System.Convert]::ToBoolean($_.HiddenFromAddressListsEnabled)
        Write-Output "Remaining:"$count
        Write-Output ""
        Write-Output "Working on Group: $Name"
        Write-Output ""

        Set-DistributionGroup -Identity $NEWName -Name $Name -Alias $Alias -DisplayName $DisplayName -PrimarySmtpAddress $PrimarySmtpAddress -HiddenFromAddressListsEnabled $Hidden
        $count--
    }

    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red "Error: " $_.Exception.Message
        #error to log
        Write-Output "Error: " $_.Exception.Message | Out-File $logFile -Append
    }
}

