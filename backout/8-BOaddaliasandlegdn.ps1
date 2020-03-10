#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

<#add aliases
$ALIASES = Import-Csv distributiongroups.csv
$ALIASES | % {Set-DistributionGroup -Identity $_.PrimarySmtpAddress -EmailAddresses @{Add=$_.FULLADDRESS}}
 #>


#add aliases
$ALIASES = Import-Csv distributiongroups.csv
$UserDomain = Read-Host "enter in your domain name (ex: contoso.com) in here"

foreach ($alias in $aliases){
    write-host "Updating the alias for the following DG:" $alias.Alias -ForegroundColor Yellow
    # Buidling the Alias SMTP domain
        $AliasName = $alias.Alias
        $AliasSMTP = $AliasName + "@" + $UserDomain

    Set-DistributionGroup -Identity $alias.PrimarySmtpAddress -EmailAddresses @{Add=$AliasSMTP} -ErrorAction SilentlyContinue

}


<#add LegacyExchangeDN as x500
Import-Csv distributiongroups_modified.csv | ForEach-Object{
$smtp=$_.PrimarySmtpAddress
$LegacyExchangeDN="x500:"+$_.LegacyExchangeDN
Set-DistributionGroup $smtp -EmailAddresses @{Add=$LegacyExchangeDN}
}
 #>

#add LegacyExchangeDN as x500
Import-Csv distributiongroups.csv | ForEach-Object{
    write-host "Updating X500 Address for DG:" $_.Name -ForegroundColor Green
    $smtp=$_.PrimarySmtpAddress
    $LegacyExchangeDN="x500:"+$_.LegacyExchangeDN
    Set-DistributionGroup $smtp -EmailAddresses @{Add=$LegacyExchangeDN} -ErrorAction SilentlyContinue
}

