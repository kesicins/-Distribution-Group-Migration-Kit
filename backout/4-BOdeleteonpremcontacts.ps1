#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

<#  The below is the original portion of the script
    
    $OU = Read-Host -Prompt 'OU for on prem group contacts'

    Import-Csv distributiongroups.csv | ForEach-Object {
    write-host "Working on: " $_.Name
    write-host
    Remove-MailContact -identity $_.Name -Confirm:$false -WhatIf
    }

#>

# Below is the modified version of the script

$Contacts = Import-Csv distributiongroups.csv

foreach ($Contact in $Contacts ){
    $ContactName = $Contact.Name
    write-host "Removing Mail Contact:" $ContactName -ForegroundColor Yellow
    Remove-MailContact -identity $ContactName -Confirm:$false -ErrorAction SilentlyContinue

}

Write-host "*** An AAD Connect sync will need to be initiated and must complete before proceeding to the next step. ***" -ForegroundColor Cyan