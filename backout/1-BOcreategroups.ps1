#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.


Import-Csv distributiongroups.csv | ForEach-Object{
write-host $_.Name
    $OU = $_.OrganizationalUnit
    $RecipientTypeDetails=$_.RecipientTypeDetails
    $Name = $($_.NEWName -replace '\s','')[0..63] -join "" # remove spaces first, then truncate to first 64 characters
    $Alias = $($_.NEWAlias -replace '\s','')[0..63] -join "" # remove spaces first, then truncate to first 64 characters
    $DisplayName=$_.NEWDisplayName
    $smtp=$_.NEWPrimarySmtpAddress
    $RequireSenderAuthenticationEnabled=[System.Convert]::ToBoolean($_.RequireSenderAuthenticationEnabled)
    $join=$_.MemberJoinRestriction
    $depart=$_.MemberDepartRestriction
    $ManagedBy=$_.ManagedBy -split ';'
    $AcceptMessagesOnlyFrom=$_.AcceptMessagesOnlyFrom -split ';'
    $AcceptMessagesOnlyFromDLMembers=$_.AcceptMessagesOnlyFromDLMembers -split ';'
    $AcceptMessagesOnlyFromSendersOrMembers=$_.AcceptMessagesOnlyFromSendersOrMembers -split ';'
    
    Write-Output ""
    Write-Output "Working on Group: $Name"
    Write-Output ""
 
    if ($RecipientTypeDetails -eq "MailUniversalSecurityGroup")
        {
        if ($ManagedBy)
            {
            New-DistributionGroup -Type security -Name $Name -Alias $Alias -DisplayName $DisplayName -OrganizationalUnit $OU -PrimarySmtpAddress $smtp -MemberJoinRestriction $join -MemberDepartRestriction $depart -ManagedBy $ManagedBy
            Start-Sleep -s 10
            Set-DistributionGroup -Identity $Name -HiddenFromAddressListsEnabled $true
            }
            Else
            {
            New-DistributionGroup -Type security -Name $Name -Alias $Alias -DisplayName $DisplayName -OrganizationalUnit $OU -PrimarySmtpAddress $smtp -MemberJoinRestriction $join -MemberDepartRestriction $depart 
            Start-Sleep -s 10
            Set-DistributionGroup -Identity $Name -HiddenFromAddressListsEnabled $true
            }
        }
 
    if ($RecipientTypeDetails -eq "MailUniversalDistributionGroup")
        {
        if ($ManagedBy)
            {
            New-DistributionGroup -Name $Name -Alias $Alias -DisplayName $DisplayName -OrganizationalUnit $OU -PrimarySmtpAddress $smtp  -MemberJoinRestriction $join -MemberDepartRestriction $depart -ManagedBy $ManagedBy
            Start-Sleep -s 10
            Set-DistributionGroup -Identity $Name -HiddenFromAddressListsEnabled $true
            }
            Else
            {
            New-DistributionGroup -Name $Name -Alias $Alias -DisplayName $DisplayName -OrganizationalUnit $OU -PrimarySmtpAddress $smtp -MemberJoinRestriction $join -MemberDepartRestriction $depart 
            Start-Sleep -s 10
            Set-DistributionGroup -Identity $Name -HiddenFromAddressListsEnabled $true
            }
        }
 
    if ($RecipientTypeDetails -eq "RoomList")
        {
        if ($ManagedBy)
            {
            New-DistributionGroup -RoomList -Name $Name -Alias $Alias -DisplayName $DisplayName -OrganizationalUnit $OU -PrimarySmtpAddress $smtp -MemberJoinRestriction $join -MemberDepartRestriction $depart -ManagedBy $ManagedBy
            Start-Sleep -s 10
            Set-DistributionGroup -Identity $Name -HiddenFromAddressListsEnabled $true
            }
            Else
            {
            New-DistributionGroup -RoomList -Name $Name -Alias $Alias -DisplayName $DisplayName -OrganizationalUnit $OU -PrimarySmtpAddress $smtp -MemberJoinRestriction $join -MemberDepartRestriction $depart 
            Start-Sleep -s 10
            Set-DistributionGroup -Identity $Name -HiddenFromAddressListsEnabled $true
            }
        }
 
 
    if ($AcceptMessagesOnlyFrom) {Set-DistributionGroup -Identity $Name -AcceptMessagesOnlyFrom $AcceptMessagesOnlyFrom}
    if ($AcceptMessagesOnlyFromDLMembers) {Set-DistributionGroup -Identity $Name -AcceptMessagesOnlyFromDLMembers $AcceptMessagesOnlyFromDLMembers}
    if ($AcceptMessagesOnlyFromSendersOrMembers) {Set-DistributionGroup -Identity $Name -AcceptMessagesOnlyFromSendersOrMembers $AcceptMessagesOnlyFromSendersOrMembers}
}