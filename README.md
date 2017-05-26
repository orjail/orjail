# torjail
bind a program inside a network namespace that could exit only with tor

## requirements
you'll need a running tor instance with following configuration:
```
VirtualAddrNetwork 10.200.1.1/10 
AutomapHostsSuffixes .onion,.exit 
AutomapHostsOnResolve 1
TransPort 9040 
TransListenAddress 10.200.1.1
DNSPort 5353
DNSListenAddress 10.200.1.1
```

## usage examples:

- get an homepage content via tor: 
`./torjail curl autistici.org > autistici.org `

- resolve a onion address: 
`./torjail dig wi7qkxyrdpu5cmvr.onion`

- get an onion webserver content via tor:  
`./torjail curl wi7qkxyrdpu5cmvr.onion`  

- open a firefox with user $USER that could only reach internet via tor:  
`./torjail sudo -u $USER firefox -P /tmp/tmpprofile`  

> warning: firefox has a flag that block .onion resolution by default -> change it using about:config network.dns.blockDotOnion


- get a shell that could not reach internet (only via tor)
`./torjail sudo -u $USER bash`


## issues
- you need a non loop-back nameserver specified in /etc/resolv.conf


