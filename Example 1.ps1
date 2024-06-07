# Load module locally
Import-Module ./AdvancedCriteriaBasedGroups -Force -Verbose

# Reuse existing connection to Microsoft Graph
Connect-AdvancedCriteriaBasedGroups -UseExistingMgGraphConnection -Verbose

# Start working on a group
Start-AdvancedCriteriaBasedGroup -ObjectId "404c71ff-bb33-4434-85e1-2e6c9863d33c" -Verbose

# Add some members of the group by criteria (Example is for all guest accounts, by filtering on the userPrincipalName property)
Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "*#EXT#*"} -Verbose -Debug

# Add all members of a specified group object. At this stage, we will have a mix of users from the criteria and the group
Add-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" -Verbose -Debug

# Remove all users matching the following criteria
Remove-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "admin*"} -Verbose -Debug

# Add this point, we have essentially 1) Added all guests, 2) Added all members of a specified group, but then 3) Removed all users that has a UPN starting with admin
# We are now ready to actually complete the operation, by writing the changes to Entra ID, and triggering transition in/out urls
Complete-AdvancedCriteriaBasedGroup `
    -Verbose `
    -TransitionInUrls "https://prod-253.westeurope.logic.azure.com:443/workflows/6826bb7ba2d24e3bb90b75469ab4012f/triggers/When_a_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0&sig=rb1HhqokT5lSYiNGF8im7-4x8Te9DNLGnzZacUOlXCk" `
    -TransitionOutUrls "https://prod-253.westeurope.logic.azure.com:443/workflows/6826bb7ba2d24e3bb90b75469ab4012f/triggers/When_a_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0&sig=rb1HhqokT5lSYiNGF8im7-4x8Te9DNLGnzZacUOlXCk"