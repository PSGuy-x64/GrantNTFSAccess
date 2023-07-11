# GrantNTFSAccess

EXAMPLE :   .\Grant-Access.ps1 -RootFolder 'C:\TestShare2\' -Identity 'Contoso\CrtServers'

![image](https://github.com/PSGuy-x64/GrantNTFSAccess/assets/130890375/47bb0ac8-6633-4670-bb76-ad2c9aa2a088)

![image](https://github.com/PSGuy-x64/GrantNTFSAccess/assets/130890375/19b12cf0-ff3f-4ae9-b106-e178cb3f1e52)

![image](https://github.com/PSGuy-x64/GrantNTFSAccess/assets/130890375/8353cab2-278a-4149-9ee6-57c139e16e5b)


if you don not have access to the root folder/subfolder, better to use system account (NT AUTHORITY\SYSTEM) via psexe tools
https://learn.microsoft.com/en-us/sysinternals/downloads/psexec
psexec -i -s powershell
