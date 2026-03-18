## Stack
StrongSwan: 5.9.5 (swanctl) || Zabbix: 7.4

## File Structure
```
/zabbix/
├── scripts/
│   ├── swanctl-stats.sh
│   └── swanctl-list-sas.sh
└── zabbix_agentd.d/
    └── userparameter_swanctl.conf
```
### How it works
Scripts parse swanctl output, Zabbix Agent executes scripts Metrics collected via User parameters

## Installation

1. Copying scripts with the necessary execution rights added
2. Copy the Zabbix Agent UserParameters
3. Import `zbx_export_templates.xml` into Zabbix
4. Attach template to host
5. Add to visudo
```
Defaults:zabbix !requiretty
zabbix ALL=(ALL) NOPASSWD: /usr/sbin/swanctl
### If you plan to use Trigger actions
zabbix ALL=(ALL) NOPASSWD: /bin/systemctl restart strongswan
```
6. Adding execution rights allow zabbix scripts (Restart strongSwan)
### zabbix_agent2.conf 
```
AllowKey=system.run[sudo /usr/bin/systemctl restart strongswan,nowait]
DenyKey=system.run[*]
```
### Alerts
Trigger `min(/template_swanctl/swanctl.ikesas.half-open,5m)<>0` checks the last 5min of the swanctl.ikesas.half-open metric
