# Authorize DHCP Server 
In real world environments, it is best to keep your DHCP server seperate from the DC

1) Ensure that both DC1 and Server1 VM are on
    - Log in with the DOMAIN ADMIN CREDENTIALS
2) Go to DC1 VM and install the DHCP Server Tools feature if not done already

<p align="center">
  <img src="screenshots/02-DHCPFeature.png" width="800">
  <br>
  <em>Installing DHCP Server Tools</em>
</p>

3) After install, I clicked on "DHCP" on the left side within Server Manager

<p align="center">
  <img src="screenshots/03-Server1Populates.png" width="800">
  <br>
  <em>Verifying if Server1 populates</em>
</p>

4) I switched over to Server1, and opened up Server Manager. Then, I clicked on "Tools" -> "DHCP"

<p align="center">
  <img src="screenshots/04-DHCPWindow.png" width="800">
  <br>
  <em>DHCP GUI</em>
</p>

5) I right click on "server1.lab.local" and clicked on "Authorize"

<p align="center">
  <img src="screenshots/05-DHCPAuthorize.png" width="800">
  <br>
  <em>Authorizing the DHCP Server</em>
</p>

6) Click on IPv4 and it should change from red down arrow to green

<p align="center">
  <img src="screenshots/06-DHCPGood.png" width="800">
  <br>
  <em>Confirmed Authorization</em>
</p>

# Setup DHCP Scope
1) I right clicked on IPv4 and clicked on "New Scope"

<p align="center">
  <img src="screenshots/07-DHCPScope.png" width="800">
  <br>
  <em>DHCP Scope Options</em>
</p>

2) I input the desired name and description
    - It is best practice to utilize naming conventions and descriptions for organizations purposes
3) I also input the IP addresses that I wanted to exclude. INPUT THE DNS SERVER!!!
    - Other IP addresses go in here as well (i.e. printers)

<table>
  <tr>
    <td align="center">
      <img src="screenshots/08-DHCPName.png" width="400">
      <br>
      <em>DHCP Name and Description</em>
    </td>
    <td align="center">
      <img src="screenshots/09-DHCPExclusion.png" width="400">
      <br>
      <em>DHCP Exclusion</em>
    </td>
  </tr>
</table>

4) Input the desired DHCP range as well.

For the purposes of this lab, I will use the following DHCP scope  
Start IP Address: 192.168.0.2  
End IP Address: 192.168.0.254

<p align="center">
  <img src="screenshots/10-DHCPRange.png" width="800">
  <br>
  <em>DHCP Range</em>
</p>

5) For the DHCP Lease, it is up to the SysAdmin on what it should be. Be mindful of when people come and go

<p align="center">
  <img src="screenshots/11-DHCPLease.png" width="800">
  <br>
  <em>DHCP Lease</em>
</p>

6) In a real world environment, your DHCP server will be connected to a router. Input the default gateway IP address for your scope.

    - Also configure your router to have the default gateway IP address

<p align="center">
  <img src="screenshots/12-DefaultGateway.png" width="800">
  <br>
  <em>Router (Default Gateway)</em>
</p>

7) Verify the DNS Server

<p align="center">
  <img src="screenshots/13-DNSVerify.png" width="800">
  <br>
  <em>DNS Server</em>
</p>

8) Verify if DHCP Scope is good

<p align="center">
  <img src="screenshots/14-DHCPScopeConfigured.png" width="800">
  <br>
  <em>DHCP Scope Active</em>
</p>

# Test DHCP Server  
1) Start up the Win11 Client VM  
2) I checked if a static IP Address is assigned or not. If it is, change it to automatically  

<table>
  <tr>
    <td align="center">
      <img src="screenshots/15-StaticIP.png" width="400">
      <br>
      <em>Static IP Address</em>
    </td>
    <td align="center">
      <img src="screenshots/16-Automatic.png" width="400">
      <br>
      <em>Change to Automatic</em>
    </td>
  </tr>
</table>

3) By default, the Win11 Client VM will automatically obtain a DHCP address. If not, I would use these commands to gain a DHCP address

    ipconfig /release
    ipconfig /renew
    ipconfig /all

<p align="center">
  <img src="screenshots/17-ipconfig.png" width="800">
  <br>
  <em>Commands for DHCP</em>
</p>

4) Verify if the new IP adddress belongs in the correct DHCP range  

<p align="center">
  <img src="screenshots/18-DHCPAddressObtained.png" width="800">
  <br>
  <em>DHCP Address accquired</em>
</p>

# Implement and Test Failover Solution  
It is best to have two of anything. This allows for high availability and redundancy  
There are two modes for configuring failover:  
Hot Standby - One DHCP Server on, One DHCP Server off  (If one fails, the other becomes active)  
Load Balance - Both DHCP Servers on  (Both distribute DHCP traffic and one server becomes primary if other fails)

For this lab, I will be installing the DHCP Server Role on DC1 as the partner DHCP server and test the Hot Standby feature  
1) On DC1 VM, install DHCP Server Role

<p align="center">
  <img src="screenshots/19-DHCPServerInstall.png" width="800">
  <br>
  <em>DHCP Install on DC1</em>
</p>

2) Complete Post-Install of DHCP Server Role

<table>
  <tr>
    <td align="center">
      <img src="screenshots/20-DHCPPostInstall-1.png" width="400">
      <br>
      <em>DHCP Post-Install</em>
    </td>
    <td align="center">
      <img src="screenshots/21-DHDCPPostInstall-2.png" width="400">
      <br>
      <em>DHCP Post-Install Warning</em>
    </td>
  </tr>
</table>

<p align="center">
  <img src="screenshots/22-DHCPPostInstall-Complete.png" width="800">
  <br>
  <em>Final Confirmation of DHCP Install on DC1</em>
</p>

3) On Server1 VM, click on Tools -> DHCP
4) In the "DHCP" window, double click on DHCP server -> Right Click on IPv4 -> Select "Configure Failover"

<p align="center">
  <img src="screenshots/23-ConfigureFailover.png" width="800">
  <br>
  <em>Failover Feature within DHCP Tool</em>
</p>

5) Select the DHCP Scopes

<p align="center">
  <img src="screenshots/24-Failover-Scopes.png" width="800">
  <br>
  <em>Selecting the desirec DHCP scope for failover</em>
</p>

6) Select DC1 as the partner server

<p align="center">
  <img src="screenshots/25-Partner-Server.png" width="800">
  <br>
  <em>Selecting DC1 as the DHCP Partner Server</em>
</p>

7) At the "Create a new failover relationship" portion, I will use the Hot Standby Mode
  - Name the failover relationship as desired
  - One DHCP Server stays active; Partner DHCP Server is on standby in case of the primary DHCP Server fails
  - Maximum Client Lead Time is set at 1 hour (best for normal environments); I will be setting it at 5 min for lab purposes
    - safety timer that prevents two DHCP servers from giving out the same IP address
  - State Switchover Internal is disabled by default
    - timer that tells your DHCP server how long to wait before automatically declaring its partner server is down.
  - WRITE DOWN AND REMEMBER THE SHARED SECRET

<p align="center">
  <img src="screenshots/26-ConfiguringFailover.png" width="800">
  <br>
  <em>DHCP Failover Configuration</em>
</p>

8) Review and confirm failover settings

<p align="center">
  <img src="screenshots/27-FailoverSettings.png" width="800">
  <br>
  <em>Final Confirmation Screen</em>
</p>

9) Go back to DC1 and verify if failover relationship has appeared

<p align="center">
  <img src="screenshots/28-DC1-FailoverScope.png" width="800">
  <br>
  <em>DC1 DHCP Failover Success</em>
</p>

10) To test the failover, double check if Win11 Client VM is still on. If not, turn it on
11) Verify if Win11 VM is receiving a DHCP address

<p align="center">
  <img src="screenshots/29-Win11Client.png" width="800">
  <br>
  <em>Win11 Client Device still receiving DHCP IP from Server1</em>
</p>

12) Turn off Server1 VM
13) Go back to DC1 to verify if the DHCP service is active

<p align="center">
  <img src="screenshots/30-DC1Failover-Success.png" width="800">
  <br>
  <em>DC1 DHCP Service Up and Running</em>
</p>

14) Go back to Win11 Client VM to see if a new DHCP address is assigned

<table>
  <tr>
    <td align="center">
      <img src="screenshots/31-Win11NewIP.png" width="400">
      <br>
      <em>Win11 receiving a DHCP address from Win11</em>
    </td>
    <td align="center">
      <img src="screenshots/32-Win11Commands.png" width="400">
      <br>
      <em>Testing DC1 by inputting ipconfig commands into Win11 Client VM</em>
    </td>
  </tr>
</table>


15) After verifying successful failover of DHCP, turn Server1 VM back on to verify if DHCP service still works

<p align="center">
  <img src="screenshots/33-Server1Works.png" width="800">
  <br>
  <em>Server1 DHCP still works!</em>
</p>

# Troubleshoot common DHCP scenarios  
For the following scenarios, I created a fun script that randomizes what issue you may encounter when dealing with DHCP servers. These are the most common scenarios when dealing with DHCP. Have fun!!!

1) Workstation receiving APIPA (Auotmatic Private IP Addressing)
This is probably the most common troubleshooting issue that you will come across. I came across this issue when working the helpdesk. You can easily identify it, as the IP starts with 169.254.x.x

Causes: DHCP Scope Exhausted, DHCP Server/Service is down, Firewall blocking DHCP traffic, Network 
Connectivity (wired/wireless)

What I would do:
  On the client device, I will run these preliminary commands
    ipconfig /all
    ipconfig /release
    ipconfig /renew
    ping X.X.X.X (known server IP or DHCP Server IP)

2) Client receiving a DHCP address but cannot access the Internet
Say that your client device does receive a DHCP address. However, it cannot connect to external resources or an organization's resources.

Causes: incorrect default gateway, incorrect DNS Server Address, incorrect subnet mask, incorrect DHCP scope configurations

Commands to use:
  ipconfig /all
  ping x.x.x.x (default gateway/DNS/website/known IP)
  tracert x.x.x.x (website/known IP)


3) DHCP Failover does not work
Another common issue with the failover relatioship not working.

Causes: Failover misconfigurations, Primary DHCP Server/Service offline, Partner DHCP Server/Service is offline, Network connectivity

Commands to use:
  Get-DHCPServerv4Failover
  Get-DHCPServerv4Scope
  Get-Service DHCPServer
  Test-NetConnection X.X.X.X(DHCP Server)