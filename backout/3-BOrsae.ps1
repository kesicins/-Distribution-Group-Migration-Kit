#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

write-host -ForegroundColor Yellow "Getting a List of Groups with RequireSenderAuthenticationEnabled set to False:"

get-distributiongroup -ResultSize Unlimited -IgnoreDefaultScope | where-object {$_.RequireSenderAuthenticationEnabled -like 'false' } | select alias,RequireSenderAuthenticationEnabled

write-host -ForegroundColor Green "Values from the DistributionGroups.csv Spreadsheet:"
Import-Csv distributiongroups.csv | where-object {$_.RequireSenderAuthenticationEnabled -like 'false' } | ForEach-Object {

write-host -ForegroundColor Yellow "RequireSenderAuthenticationEnabled setting is set to false for the following Distro Group:" $_.alias $_.RequireSenderAuthenticationEnabled
set-distributiongroup $_.alias -RequireSenderAuthenticationEnabled $false 
}

write-host -ForegroundColor Green "Checking groups in AD..."

get-distributiongroup | where-object {$_.RequireSenderAuthenticationEnabled -like 'false' } | ForEach-Object {
write-host -ForegroundColor Green $_.alias $_.RequireSenderAuthenticationEnabled

}
