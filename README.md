[![Build Status](https://travis-ci.org/orjail/orjail.svg?branch=master)](https://travis-ci.org/orjail/orjail)

> ### :warning: WARNING
> orjail is under development, use at your own risk.  
> if you find a bug, please create an [issue](https://github.com/orjail/orjail/issues).

## why?
we've tried to deanonimize a program executed in torsocks environment and that was not so difficult as torsocks use LD_PRELOAD, so you only need to statically compile your stuff.
as [whonix](https://www.whonix.org/) is sometimes too much, the idea is to experiment with [linux namespaces](http://man7.org/linux/man-pages/man7/namespaces.7.html) and learn by doing something usefull (at least for us).

## requirements
1. a linux kernel supporting namespaces (you have it since 2008)
1. tor installed
1. [firejail](https://firejail.wordpress.com/) (optional)


## how it works
it creates a separated network namespace (using `ip netns`) with its own network
interface and a link to the host interface with some iptables rules (on host)
that force traffic generated from inside orjail to only exit via tor (including dns).  
inside orjail you'll be in another pid namespace (this way you cannot switch
namespace), and another mount namespace (we use this to show a different /etc/resolv.conf).  

**if you find a way to deanonimize a program running inside orjail** (also a shell with root privileges) would be nice to [share it with us](https://github.com/orjail/orjail/issues)


## additional info
1. `orjail` needs root permission to run
1. `orjail` runs your program as your user
1. `orjail` will launch a tor instance bound to orjail interface


## usage examples: 

#### an example to see what are we talking about (try yourself with ps aux, ls)
```
$ sudo orjail ifconfig
out-orjail: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.200.1.2  netmask 255.255.255.0  broadcast 0.0.0.0
        inet6 fe80::6439:afff:febc:c9b5  prefixlen 64  scopeid 0x20<link>
        ether 66:39:af:bc:c9:b5  txqueuelen 1000  (Ethernet)
        RX packets 6847  bytes 7488116 (7.1 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6809  bytes 915088 (893.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

#### run an hidden service inside orjail (you'll find your address inside `examples/hostname`)
`sudo orjail -v -H 8080 -d examples  "python -m SimpleHTTPServer 8080" `

#### getting an homepage content with curl via tor
`sudo orjail curl autistici.org > autistici.org `

#### same as before with another user
`sudo orjail -u another_user curl autistici.org`

#### "resolve" a onion address (not so usefull, just to show that .onion resolving works)
`sudo orjail dig wi7qkxyrdpu5cmvr.onion`

#### get an onion webserver content via tor:
`sudo orjail curl wi7qkxyrdpu5cmvr.onion`

#### open a firefox that could reach internet via tor only:
`sudo orjail firefox -P /tmp/tmpprofile`

> ### :warning:
> firefox has a flag that blocks .onion resolution by default, change it in **about:config**/**network.dns.blockDotOnion**.  
>
> **running a browser inside orjail is not safe, please use Tor Browser instead**

#### get an anonymous shell
`sudo orjail -s`

#### run pidgin in verbose mode
`sudo orjail -v pidgin`

#### keep the namespace after exit so we can start another program in same ns 
`sudo orjail -k ls`

#### Use `firejail` as a security sandbox to join orjail network namespace
`sudo orjail -f thunderbird`

Made with :heart: by [_TO*hacklab](https://autistici.org/underscore)
