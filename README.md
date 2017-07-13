> ### :warning: WARNING
> torjail is under development, use at your own risk.  
> if you find a bug, please create an [issue](https://github.com/lesion/torjail/issues).

## why?
we've tried to deanonimize a program executed in torsocks environemnt and that was not so difficult, as torsocks use LD_PRELOAD so you only need to statically compile your stuff.
as [whonix](https://www.whonix.org/) is sometimes too much, the idea is to experiment with [linux namespaces](http://man7.org/linux/man-pages/man7/namespaces.7.html) and learn by doing something usefull (at least for us).

## requirements
1. a linux kernel supporting namespaces (you have it since 2008)
1. tor installed


## how it works
it creates a separated network namespace (using `ip netns`) with its own network
interface and a link to the host interface with some iptables rules (on host)
that force traffic generated from inside torjail to only exit via tor (including dns).  
inside torjail you'll be in another pid namespace (this way you cannot switch
namespace), and another mount namespace (we use this to show a different /etc/resolv.conf).  

**if you find a way to deanonimize a program running inside torjail** (also a shell with root privileges) would be nice to [share it with us](https://github.com/lesion/torjail/issues)


## additional info
1. `torjail` needs root permission to run
1. `torjail` runs your program as your user
1. `torjail` will launch a tor instance with a default configuration (but you can specify your own instance with `-t`)
1. other questions?


## usage examples: 

#### an example to see what are we talking about (try yourself with ps aux, ls)
```
$ sudo torjail ifconfig
out-torjail: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.200.1.2  netmask 255.255.255.0  broadcast 0.0.0.0
        inet6 fe80::6439:afff:febc:c9b5  prefixlen 64  scopeid 0x20<link>
        ether 66:39:af:bc:c9:b5  txqueuelen 1000  (Ethernet)
        RX packets 6847  bytes 7488116 (7.1 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6809  bytes 915088 (893.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

#### getring an homepage content with curl via tor
`sudo torjail curl autistici.org > autistici.org `

#### same as before with another user
`sudo torjail -u another_user curl autistici.org`

#### "resolve" a onion address (not so usefull, just to show that .onion resolving works)
`sudo torjail dig wi7qkxyrdpu5cmvr.onion`

#### get an onion webserver content via tor:
`sudo torjail curl wi7qkxyrdpu5cmvr.onion`

#### open a firefox that could reach internet via tor only:
`sudo torjail firefox -P /tmp/tmpprofile`

> ### :warning:
> firefox has a flag that blocks .onion resolution by default, change it in **about:config**/**network.dns.blockDotOnion**.  
>
> **running a browser inside torjail is not safe, please use Tor Browser instead**

#### get an anonymous shell
`sudo torjail -s`

#### run pidgin in verbose mode
`sudo torjail -v pidgin`

#### keep the namespace after exit so we can start another program in same ns 
`sudo torjail -k ls`


Made with :heart: by [_TO*hacklab](https://autistici.org/underscore)
