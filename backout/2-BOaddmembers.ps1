#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.


Import-Csv distributiongroups-and-members.csv | ForEach-Object{
$RecipientTypeDetails=$_.GroupType
$NEWGroupSMTP=$_.NEWGroupSMTP
$MemberSMTP=$_.MemberSMTP
$NewGroupName = $_.newgroup
Write-Output "Adding members to the following group: $NewGroupName"  # Updated to show the output
    if ($RecipientTypeDetails -eq "MailUniversalSecurityGroup")
        {
        Add-DistributionGroupMember -Identity $NEWGroupSMTP -Member $MemberSMTP -BypassSecurityGroupManagerCheck -ErrorAction SilentlyContinue
        }
    
    if ($RecipientTypeDetails -eq "MailUniversalDistributionGroup")
        {
        Add-DistributionGroupMember -Identity $NEWGroupSMTP -Member $MemberSMTP -ErrorAction SilentlyContinue
        }
 
    if ($RecipientTypeDetails -eq "RoomList")
        {
        Add-DistributionGroupMember -Identity $NEWGroupSMTP -Member $MemberSMTP -ErrorAction SilentlyContinue
        }
 
}

 