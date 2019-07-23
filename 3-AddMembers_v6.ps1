#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.

$logfile = "3_errors_$(Get-Date -Format yyyyMMddTHHmmssffff).txt"

Import-Csv distributiongroups-and-members.csv | % {
    try
    {
        $RecipientTypeDetails = $_.GroupType
        $GroupSMTP = $_.NEWGroupSMTP
        $MemberSMTP = $_.MemberSMTP
        $NEWMemberSMTP = $_.NEWMemberSMTP
        $MemberTYPE = $_.MemberType

        if ($MemberTYPE -eq "MailUniversalSecurityGroup")
        {
            $memberaddress = $NEWMemberSMTP
        }

        else
        {
            $memberaddress = $MemberSMTP
        }

        Write-Host "Adding adddress" $memberaddress "to group" $GroupSMTP
 
        if ($RecipientTypeDetails -eq "MailUniversalSecurityGroup")
        {
            Add-DistributionGroupMember -Identity $GroupSMTP -Member $memberaddress -BypassSecurityGroupManagerCheck
        }
    
        if ($RecipientTypeDetails -eq "MailUniversalDistributionGroup")
        {
            Add-DistributionGroupMember -Identity $GroupSMTP -Member $memberaddress
        }
 
        if ($RecipientTypeDetails -eq "RoomList")
        {
            Add-DistributionGroupMember -Identity $GroupSMTP -Member $memberaddress
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

 