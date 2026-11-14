# Server 1 VM not populating within DC1
In order to authorize a DHCP server, a domain admin account must authorize it within Server Manager. This process happens within DC1 VM in this lab environment. First I went to Server Manager, Then I clicked on "Manage" at the top right to add Server1 in DC1's list of server. 

<table>
  <tr>
    <td align="center">
      <img src="screenshots/50-AuthorizingServer1VM.png" width="400">
      <br>
      <em>Adding Server1</em>
    </td>
    <td align="center">
      <img src="screenshots/51-AddingServer1toDC1.png" width="400">
      <br>
      <em>Trying to add Server1</em>
    </td>
  </tr>
</table>

I tried adding Server1 with the local admin account. That did not work initially. So I switched to the domain admin account. 

<p align="center">
  <img src="screenshots/52-LoggedInWithLocalAccount.png" width="800">
  <br>
  <em>Not logged in with Domain Admin Account</em>
</p>


After adding Server1 with the domain admin account, an error appeared stating "Kerberos Error." 

<p align="center">
  <img src="screenshots/53-Server1Kerberos.png" width="800">
  <br>
  <em>Authentication Error</em>
</p>

So I tried logging into Server1 with the domain credentials. The following appeared.

<p align="center">
  <img src="screenshots/54-LoggedInWithLocalAccount.png" width="800">
  <br>
  <em>Logging in with Domain Admin Creds into Server1</em>
</p>

So I logged into Server1 with the local admin account and used the following commands

    Test-ComputerSecureChannel -Verbose

<p align="center">
  <img src="screenshots/55-TestComputerSecureChannelVerbose.png" width="800">
  <br>
  <em>Testing SecureChannel</em>
</p>



This returned false, which verifies that the trust relationship status is broken
To fix this, I used this command

    Test-ComputerSecureChannel -Repair -Credential (Get-Credential)

<p align="center">
  <img src="screenshots/56-TestComputerSecureChannelFailed.png" width="800">
  <br>
  <em>Command fails</em>
</p>

I thought this would work. However, even after providing the credentials, an error appears stating that the action is not authorized. BEST THING TO DO IS RE-JOIN SERVER1 FROM SCRATCH

# Server VM not populating within DC1 due to Computed Packet Size
So after fixing the debacle with Server1's trust being broken, I tried adding Server1 again to DC1's list of server. A new error appeared

<p align="center">
  <img src="screenshots/60-NewError.png" width="800">
  <br>
  <em>WS-Management Packet Size Error</em>
</p>

To fix this, I used the following commands on BOTH DC1 and Server1

    winrm get winrm/config
        - Look for MaxEnvelopSizekb = 500

<p align="center">
  <img src="screenshots/61-WinRmVerification.png" width="800">
  <br>
  <em>WinRm Config</em>
</p>

    winrm set winrm/config '@{MaxEnvelopeSizekb="8192"}'
    Restart-Service WinRM

<table>
  <tr>
    <td align="center">
      <img src="screenshots/62-WinRmEnvelopeChange.png" width="400">
      <br>
      <em>MaxEnvelopeSize Change</em>
    </td>
    <td align="center">
      <img src="screenshots/63-RestartWinRm.pngwidth="400">
      <br>
      <em>Restarting the WinRm Service</em>
    </td>
  </tr>
</table>

Close out Service Manager on DC1 and reopen it to try adding it again

<p align="center">
  <img src="screenshots/64-SuccessfulAdd.png" width="800">
  <br>
  <em>Server1 Added to DC1's Server List</em>
</p>