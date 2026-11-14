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

# Install Additional DHCP Server  
It is best to have two of anything. This allows for high availability and redundancy  
There are two modes for configuring failover:  
Hot Standby - One DHCP Server on, One DHCP Server off  (If one fails, the other becomes active)
Load Balance - Both DHCP Servers on  (Both distribute DHCP traffic)

# Implement and Test Failover Solution  

# Troubleshoot common DHCP scenarios  