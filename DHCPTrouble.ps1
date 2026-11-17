# RUN THIS SCRIPT AS ADMINISTRATOR on Primary DHCP Server

# Variables needed for the script
$ScopeId = (Get-DHCPServerv4Scope).ScopeId
$Failover = Get-DhcpServerv4Failover | Select-Object -First 1
$Partner = $Failover.PartnerServer

# Defining the scenarios that will be randomly selected
$Scenarios = @(
    # Scenario 1: Client receives APIPA address
    {Stop-Service DHCPServer -Force
    Invoke-Command -ComputerName $Partner {Stop-Service DHCPServer -Force}},

    # Scenario 2: Scope deactivated
    {Set-DHCPServerv4Scope -ScopeId $ScopeId -State Inactive
    Set-DHCPServerv4Scope -ComputerName $Partner -ScopeId $ScopeId -State Inactive},

    # Scenario 3: Wrong DNS Server in scope options (IP works, names don't resolve)
    {Set-DHCPServerv4OptionValue -ScopeId $ScopeId -DnsServer 8.8.4.4
    Set-DHCPServerv4OptionValue -ComputerName $Partner -ScopeId $ScopeId -DnsServer 8.8.4.4},

    # Scenario 4: Partner server's DHCP service is stopped
    {Invoke-Command -ComputerName $Partner {Stop-Service DHCPServer -Force}},

    # Scenario 5: Failover relationship removed
    {Remove-DhcpServerv4Failover -Name $Failover.Name -Force}
)

# This will randomly select a scenario to run
& ($Scenarios | Get-Random)

Write-Host "### DHCP Script has done its magic ###"
Write-Host "### It's up to you to fix the issue ###"