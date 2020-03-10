#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

#results file
$exportGroupslist = "distributiongroups.csv"
$exportGroupsProxy = "distributiongroups-SMTPproxy.csv"
$exportGroupMembers = "distributiongroups-and-members.csv"
$logfile = "1_errors_$(Get-Date -Format yyyyMMddTHHmmssffff).txt"


Write-Host -ForegroundColor green "Getting list of distribution groups..."
#Get all groups into temp variable
$groups = Get-DistributionGroup -ResultSize Unlimited -IgnoreDefaultScope
Write-Host -ForegroundColor yellow "Found" $groups.count "Distribution Groups"

#function to export data to csv files
Function ExportGroups
{
    try
    {
        Write-Host -ForegroundColor Yellow "Exporting Distribution Groups to" $exportGroupslist
        $groups | Select-Object RecipientTypeDetails,`
        Name,`
        @{Name="NewName";Expression={"NEW" + $_.Name}},`
        Alias,`
        @{Name="NewAlias";Expression={"NEW" + $_.Alias}},`
        DisplayName,@{Name="NewDisplayName";Expression={"NEW" + $_.DisplayName}},`
        PrimarySmtpAddress,`
        @{name="NEWPrimarySmtpAddress";expression={"NEW" + $_.PrimarySmtpAddress}},`
        @{name="SMTPDomain";expression={$_.PrimarySmtpAddress.Domain}},`
        MemberJoinRestriction,`
        MemberDepartRestriction,`
        RequireSenderAuthenticationEnabled,`
        ModerationEnabled,`
        SendModerationNotifications,`
        LegacyExchangeDN,`
        OrganizationalUnit,`  # Added this line
		HiddenFromAddressListsEnabled,`
        @{name="Managedby";expression={($_.ManagedBy) -join ";"}},`
        @{Name="DN";Expression={$_.DistinguishedName -join ";"}},`
        @{name="AcceptMessagesOnlyFrom";expression={($_ |select -expandproperty AcceptMessagesOnlyFrom).name -join ";"}},`
        @{name="AcceptMessagesOnlyFromDLMembers";expression={($_ |select -expandproperty AcceptMessagesOnlyFromDLMembers).name -join ";"}},`
        @{name="AcceptMessagesOnlyFromSendersOrMembers";expression={($_ |select -expandproperty AcceptMessagesOnlyFromSendersOrMembers).name -join ";"}},`
        @{name="ModeratedBy";expression={($_ |select -expandproperty ModeratedBy).name -join ";"}},
        @{name="BypassModerationFromSendersOrMembers";expression={($_ |select -expandproperty BypassModerationFromSendersOrMembers).name -join ";"}},
        @{name="GrantSendOnBehalfTo";expression={($_ |select -expandproperty GrantSendOnBehalfTo).name -join ";"}},
        @{Name="EmailAddresses";Expression={$_.EmailAddresses -join ";"}}`
         | Export-Csv $exportGroupslist -NoTypeInformation
    }

    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red "Error exporting groups " $_.Exception.Message
        #error to log
        Write-Output "ERROR" $_.Exception.Message | Out-File $logFile -Append
    }
}


Function ExportGroupAddresses
{
    try
    {
        Write-Host -ForegroundColor Yellow "Exporting Distribution Groups Email Addresses to" $exportGroupsProxy

        #Export 2) ON-PREM export distribution groups’ smtp aliases
        $groups | Select-Object RecipientTypeDetails,PrimarySmtpAddress -ExpandProperty emailaddresses | select RecipientTypeDetails,PrimarySmtpAddress, @{name="TYPE";expression={$_}} | Export-Csv $exportGroupsProxy -NoTypeInformation
    }
    
    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red  "Error exporting email addresses " $_.Exception.Message
        #error to log
        Write-Output "ERROR" $_.Exception.Message | Out-File $logFile -Append
    }
}

Function ExportGroupMembers
{
    try
    {
        Write-Host -foregroundcolor Yellow "Exporting Distribution Groups members to" $exportGroupMembers

        #Export 2) ON-PREM export distribution groups’ smtp aliases
        $groups | % {
            #Add count loop
            $guid=$_.Guid;
            $GroupType=$_.RecipientTypeDetails;
            $Name=$_.Name;
            $SMTP=$_.PrimarySmtpAddress;
            Get-DistributionGroupMember -Identity $guid.ToString() -ResultSize Unlimited | `
            Select-Object `
            @{name="GroupType";expression={$GroupType}},`
            @{name="Group";expression={$name}},`
			@{name="NEWGroup";expression={"NEW" + $name}},`
            @{name="GroupSMTP";expression={$SMTP}},`
            @{name="NEWGroupSMTP";expression={"NEW" + $SMTP}},`
            @{name="PrimarySMTPDomain";expression={$SMTP.Domain}},`
            @{Label="Member";Expression={$_.Name}},`
            @{Label="MemberSMTP";Expression={$_.PrimarySmtpAddress}},`
			@{name="NEWMemberSMTP";expression={"NEW" + $_.PrimarySmtpAddress}},`
            @{Label="MemberType";Expression={$_.RecipientTypeDetails}}
        } | Export-Csv $exportGroupMembers -NoTypeInformation
 
    }

    catch
    {
        #error on screen
        Write-Host -ForegroundColor Red  "Error exporting Group Members " $_.Exception.Message
        #error to log
        Write-Output "ERROR" $_.Exception.Message | Out-File $logFile -Append
    }
}

ExportGroups
ExportGroupAddresses
ExportGroupMembers
