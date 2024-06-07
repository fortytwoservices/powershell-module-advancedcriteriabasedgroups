# Load module locally
Import-Module .\AdvancedCriteriaBasedGroups -Force -Verbose

# Reuse existing connection to Microsoft Graph
Connect-AdvancedCriteriaBasedGroups -UseExistingMgGraphConnection -Verbose

# Start working on a group
Start-AdvancedCriteriaBasedGroup -ObjectId "404c71ff-bb33-4434-85e1-2e6c9863d33c" -Verbose

# Evaluate a criteria for guest users
Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "marius*#EXT#*"} -Verbose -Debug

# Evaluate a criteria for guest users
Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "*#EXT#*"} -Verbose -Debug

# Complete the group criteria processing
Complete-AdvancedCriteriaBasedGroup `
    -Verbose `
    -TransitionInUrls "https://prod-253.westeurope.logic.azure.com:443/workflows/6826bb7ba2d24e3bb90b75469ab4012f/triggers/When_a_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0&sig=rb1HhqokT5lSYiNGF8im7-4x8Te9DNLGnzZacUOlXCk" `
    -TransitionOutUrls "https://prod-253.westeurope.logic.azure.com:443/workflows/6826bb7ba2d24e3bb90b75469ab4012f/triggers/When_a_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0&sig=rb1HhqokT5lSYiNGF8im7-4x8Te9DNLGnzZacUOlXCk"