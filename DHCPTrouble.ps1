# RUN THIS SCRIPT AS ADMINISTRATOR on Primary DHCP Server

# Variables needed for the script
$scopeId = (Get-DHCPServerv4Scope).ScopeId
$failover = Get-DhcpServerv4Failover | Select-Object -First 1
$partner = $failover.PartnerServer

# Defining the scenarios that will be randomly selected
$Scenarios = @(
    # Scenario 1: Client receives APIPA address
    {Stop-Service DHCPServer -Force
    Invoke-Command -ComputerName $partner {Stop-Service DHCPServer -Force}},

    # Scenario 2: Scope deactivated
    {Set-DHCPServerv4Scope -ScopeId $scopeId -State Inactive
    Set-DHCPServerv4Scope -ComputerName $partner -ScopeId $scopeId -State Inactive},

    # Scenario 3: Wrong DNS Server in scope options (IP works, names don't resolve)
    {Set-DHCPServerv4OptionValue -ScopeId $scopeId -DnsServer 192.168.0.50 -Force
    Set-DHCPServerv4OptionValue -ComputerName $partner -ScopeId $scopeId -DnsServer 192.168.0.50 -Force},

    # Scenario 4: Firewall blocking DHCP traffic
    {Disable-NetFirewallRule -DisplayGroup "DHCP Server"
    Invoke-Command -ComputerName $partner {Disable-NetFirewallRule -DisplayGroup "DHCP Server"}},
    
    # Scenario 5: DHCP Partner Communication Failure
    {Invoke-Command -ComputerName $partner {Stop-Service DHCPServer -Force}},

    # Scenario 6: Failover relationship removed
    {Remove-DhcpServerv4Failover -Name $failover.Name -Force},

    # Scenario 7: Firewall blocking DHCP replicaiton traffic between the two servers
    {Disable-NetFirewallRule -DisplayName 'DHCP Server Failover (TCP-In)'
    Disable-NetFirewallRule -DisplayName 'DHCP Server Failover (TCP-In)' -CimSession $partner}
)

# This will randomly select a scenario to run
& ($Scenarios | Get-Random)

Write-Host "### DHCP Script has done its magic ###"
Write-Host "### It's up to you to fix the issue ###"