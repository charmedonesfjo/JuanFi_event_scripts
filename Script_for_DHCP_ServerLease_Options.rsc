# Created by: CharmedOnesFJO
# Description : DHCP option set for DHCP Clients 
#               w/ Static IP reserved to get DNS at NTP|SNTP values
#               
#BEGIN
{
# replace  "bridge-local" w/ actual DHCP NAME  goto WINBOX--->IP ===>DHCP SERVER >>> LOOK FOR THE NAME ITEM
:local DHCPServerName "bridge-local";
#
#
# for ONE DHCP SERVER = 0 | for Multiple = 1
:local DHCPserver 0;  
#
## DONT EDIT BEYOND THIS LINE
/ip dhcp-server
/ip dhcp-server option add code=6 name=PublicDNS value="'1.0.0.1''8.8.4.4'"
/ip dhcp-server option add code=42 name=SNTP value="'time.google.com''time.windows.com'"
/ip dhcp-server option sets add name=DHCPSET options=PublicDNS,SNTP
:if ( $DHCPserver=0) do={ /ip dhcp-server set dhcp-option-set=DHCPSET [find name=$DHCPServerName]; } else={ :foreach iDHCP in=[/ip dhcp-server find] do={/ip dhcp-server set dhcp-option-set=DHCPSET $iDHCP } }
}
#EOL