# Created by: CharmedOnesFJO
# Date Created : 21Feb2021 revised 30Nov2022
# Description : Create PPPoE Server Interface
# How to : Copy Paste Command OR Import file command at winbox terminal
#BOF
{
### Replace "bridge-PPPoE" w/ your Actual Bridge or Ethernet Interface Name      
:local ibridge "bridge-PPPoE";
:do { 
### Dont Edit Beyond this LINE.    
:do {/interface bridge add name=$ibridge } on-error={/ system logging enable 0; :log error "error-1 addBridge"};    
/ip pool add name=pool_pppoe_service ranges=172.16.26.22-172.16.26.250
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes local-address=172.16.26.1 name=pppoe_server remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=pppoe_user_template only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=5M/3M remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=P03M only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=4M/4M remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=P05M only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=6M/6M remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=P07M only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=8M/8M remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=P10M only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=11M/11M remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=P15M only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=16M/16M remote-address=pool_pppoe_service
/ppp profile add address-list=IP_PPPoE bridge="$ibridge" change-tcp-mss=yes insert-queue-before=bottom local-address=172.16.26.1 name=P20M only-one=yes parent-queue=none queue-type=ethernet-default rate-limit=21M/21M remote-address=pool_pppoe_service
/interface pppoe-server server add default-profile=pppoe_server disabled=no interface="$ibridge" one-session-per-host=yes service-name=PPPoE_Service max-mru=1504 max-mtu=1504 mrru=1580
/ip address add address=172.16.26.1/24 interface="$ibridge" network=172.16.26.0
/ip dhcp-server network add address=172.16.26.0/24 comment=defconf gateway=172.16.26.1 netmask=24
/ip firewall address-list add address=172.16.26.0/24 list=IntraNET
/ip firewall address-list add address=172.16.26.0/24 disabled=yes list=IP_PPPoE
/ip firewall nat add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN src-address-list=IP_PPPoE
/ppp secret add name=ppp_template profile=pppoe_user_template service=pppoe
} on-error={/system logging enable 0; :log error "PPPoE Service Installation E R R O R "};
}
#EOF