[![Build Status](https://travis-ci.org/orjail/orjail.svg?branch=master)](https://travis-ci.org/orjail/orjail)

> ### :warning: WARNING
> Security isn’t just about the tools you use or the software you download. It begins with understanding the unique threats you face and how you can counter those threats.

# orjail
**orjail** is a tool that let you create a jail around a program to force it's network traffic through tor [Tor](https://www.torproject.org/). 
It creates a hostile environment for anything trying to discover your real IP address.


## Install
##### From source
```
git clone https://github.com/orjail/orjail.git
cd orjail
sudo make install
```
#

## Why?
We've tried to deanonimize a program executed in torsocks environment and that was not so difficult as torsocks use LD_PRELOAD, so you only need to statically compile your stuff.
as [Whonix](https://www.whonix.org/) is sometimes too much, the idea is to experiment with [linux namespaces](http://man7.org/linux/man-pages/man7/namespaces.7.html) and learn by doing something useful (at least for us).

## Requirements
- Linux kernel supporting namespaces (you have it since 2008)
- Tor installed
- [firejail](https://firejail.wordpress.com/) (optional, but really suggested)

## How it works
It creates a separated [network namespace](https://en.wikipedia.org/wiki/Linux_namespaces#Network_(net)) (using `ip netns`) with its own network
interface and a link to the host interface with some iptables rules (on host)
that force traffic generated from inside orjail to only exit via Tor (including DNS).  
Inside **orjail** you'll be in another pid namespace (try `sudo orjail ps aux`) and another mount namespace (we use this to show a different /etc/resolv.conf).  

**if you find a way to deanonimize a program running inside orjail** (also a shell with root privileges) would be nice to [share it with us](https://github.com/orjail/orjail/issues)


## Additional info
- orjail needs root permission to run
- orjail runs your command as your user
- orjail will launch a Tor instance bound to orjail interface

## Usage
> ```bash
> orjail [options] [command]
> ```
> **-u, --user** \<user>  
> Run command as \<user> (default **$USER**)
>
> **-f, --firejail**  
> Use [firejail](https://firejail.wordpress.com) as a security container
>
> **--firejail-args** "\<args>"  
> Set arguments to pass to firejail surrounded by quotes.  
> eg. "--hostname=host --env=PS1=[orjail]"
>
>
> **--host-torrc**  
> Include your torrc host
>
> **-t, --tor-exec** \<torpath>  
> Select a Tor executable to use. The path can be full, relative or be in $PATH (default **tor**)
>
> **-s, --shell**  
> Execute a shell (default **$SHELL**)
>
>
> **-k, --keep**  
> Don't delete namespace and don't kill tor after the execution.
>
> **-n, --name <name>**  
> Set a custom namespace name (default **orjail**)

## Example

##### An example to understand what are we talking about:
```bash
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

#### Get homepage content with curl via Tor
`sudo orjail curl autistici.org > autistici.org `

#### Same as before with another user
`sudo orjail -u another_user curl autistici.org`

#### "Resolve" an onion address (not so usefull, just to show that .onion resolving works)
`sudo orjail dig wi7qkxyrdpu5cmvr.onion`

#### Run an hidden service inside orjail (you'll find your address inside `examples/hostname`)
`sudo orjail -v -H 8080 -d examples  "python -m SimpleHTTPServer 8080" `

#### Get an onion webserver content via Tor:
`sudo orjail curl wi7qkxyrdpu5cmvr.onion`

#### Open a firefox that could reach internet via Tor only:
`sudo orjail firefox -P /tmp/tmpprofile`

> ### :warning:
> firefox has a flag that blocks .onion resolution by default, change it in **about:config**/**network.dns.blockDotOnion**.  
>
> **running a browser inside orjail is not safe, please use [Tor Browser](https://www.torproject.org/projects/torbrowser.html.en) instead**

#### Get an anonymous shell
`sudo orjail -s`

#### Run pidgin in verbose mode
`sudo orjail -v pidgin`

#### Keep the namespace after exit so we can start another program in same ns 
`sudo orjail -k ls`

#### Use `firejail` as a security sandbox to join orjail network namespace
`sudo orjail -f thunderbird`

## Know issues
- dbus
- X


---
Made with  :heart: by [_to hacklab](https://autistici.org/underscore)
