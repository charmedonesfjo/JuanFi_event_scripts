# Created by: CharmedOnesFJO
# Date Created : 01Aug2022 revised 20Nov2022
# Description : Customized Routine to create Hotspot base on VLAN ID
# How to use : Upload this file to Winbox then open Terminal [import file-name=ScriptToADD_HSVLAN.rsc]
/ system logging enable 0;
:log info "ScriptGenerationStarted $[/system clock get date] $[/system clock get time]"
{
### ADD MODE Sequence 0=addALL 1=ADD Only VLAN ID and VLAN Bridge Ports :if ($AddMode=0) do={ }
:local AddMode 1;     
### Change value Accordingly    
:local etherport "ether6";
:local vportname "E06";
### Fixed Value Dont Change anything
:local vname "bridge-hs-v";
:local HSdummy "xDummyDONTDeleteEnableThisItem"
:local HSprofile "default_one_ip";
:local IPadd;
:local vnum;
:local iface;
:if ($AddMode=0) do={ :do { /interface list add name=WAN } on-error={/ system logging enable 0; :log error "WAN List already exist"};
:do { /interface list add exclude=WAN name=LAN } on-error={/ system logging enable 0; :log error "LAN List already exist"};
:do { /interface list add exclude=WAN name=HS } on-error={/ system logging enable 0; :log error "HS List already exist"};
:do {/ip hotspot profile add name=default_one_ip } on-error={/ system logging enable 0; :log error "default_one_ip already exist"};
:do {/interface bridge add disabled=yes name=$HSdummy comment="DONTDeleteEnableThisItem"} on-error={/ system logging enable 0; :log error "DummyItem already exist"}; }
/system logging disable 0;
### FROM/TO is your VLAN ID Tagged
:for i from=10 to=51 do={
:set $vnum $i;
:set $iface "$vname$vnum";
#
:if ($AddMode=0) do={ :do {/interface bridge add name=$iface } on-error={/ system logging enable 0; :log error "error-1 addBridge"}; }
#
:do {/interface vlan add interface=$etherport name="$vportname-vlan$i" vlan-id=$i } on-error={/ system logging enable 0; :log error "error2 addvlan"};
#
:if ($AddMode=0) do={ :do {/ip pool add name="pool_bridge-hs-v$i" ranges="10.200.$i.12-10.200.$i.252" comment="hotspot network VLAN $i" } on-error={/ system logging enable 0; :log error "error3 addpool"};
:do {/ip dhcp-server add address-pool="pool_bridge-hs-v$i" disabled=no interface=$iface lease-time=3m name=$iface } on-error={/ system logging enable 0; :log error "error4 addDHCPserver"};
:do {/ queue simple add disabled=yes name="hs-<bridge-hs-v$i>" comment="DONT ENABLE/MOVE/DELETE THIS ITEM" queue="hotspot-default/hotspot-default" target=$HSdummy} on-error={/ system logging enable 0; :log error "error6 addDummySQ"};
:do {/ip hotspot add address-pool="pool_bridge-hs-v$i" disabled=no interface=$iface name=$iface profile=$HSprofile } on-error={/ system logging enable 0; :log error "error5 addHS"}; }
#
:do {/interface bridge port add bridge=$iface interface="$vportname-vlan$i" trusted=yes } on-error={/ system logging enable 0; :log error "error7 addPort"};
#
:if ($AddMode=0) do={ :do {/interface list member add interface=$iface list=HS comment="Hotspot VLAN $i" } on-error={/ system logging enable 0; :log error "error8 AddLstMember"};
:do {/ip address add address="10.200.$i.1/24" interface=$iface network="10.200.$i.0" } on-error={/ system logging enable 0; :log error "error9 AddIPADD"};
:do {/ip dhcp-server network add address="10.200.$i.0/24" comment="hotspot network VLAN $i" gateway="10.200.$i.1" } on-error={/ system logging enable 0; :log error "error10 AddDHCPnet"};
:do {/ip firewall address-list add address="10.200.$i.5/32" comment="IP_COINSLOTS VLAN $i" list=IP_COINSLOTS } on-error={/ system logging enable 0; :log error "error11 AddADDList"};
:do {/ip firewall address-list add address="10.200.$i.0/24" comment="IP_HS_VLAN_NETWORK $i" list=IP_HS_VLAN_NETWORK } on-error={/ system logging enable 0; :log error "error12 AddADDList"};
:do {/ip firewall address-list add address="10.200.$i.0/24" comment="IP_HS_VLAN_NETWORK $i" list=IntraNET } on-error={/ system logging enable 0; :log error "error13 AddADDList"}; }
#
/ system logging enable 0; :log warning "Processing ScriptLine $i $[/system clock get date] $[/system clock get time]"
/system logging disable 0;
} }
:if ($AddMode=0) do={ :do {/ip firewall nat add action=masquerade chain=srcnat comment="masquerade ALL hotspot VLAN networks" src-address-list="IP_HS_VLAN_NETWORK"} on-error={/ system logging enable 0; :log error "error13 Masquerade"}; }
/ system logging enable 0; :log error "ScriptGenerationDONE $[/system clock get date] $[/system clock get time]"
/ file
/ file remove [find name=ScriptToADD_HSVLAN.rsc];
/ file remove [find name=flash/ScriptToADD_HSVLAN.rsc];
/ file remove [find name=skins/ScriptToADD_HSVLAN.rsc];
/ file remove [find name=pub/ScriptToADD_HSVLAN.rsc];
/ file remove [find name=flash/skins/ScriptToADD_HSVLAN.rsc];
/ file remove [find name=flash/pub/ScriptToADD_HSVLAN.rsc];
/ console clear-history;
