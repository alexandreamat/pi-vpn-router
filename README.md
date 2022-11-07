# pi-vpn-router

Hardware VPN using Raspberry Pi to enable transparent fully tunneled Internet access.

Below is the overall architecture diagram.

```scheme
               ┌──────────┐
               │ Internet │
               └────┬─────┘
                    │
               ┌────┴─────┐
               │ Primary  │
               │  Router  │
               └──────────┘
                    ▲ 192.168.1.1
                    │
                    │ 192.168.1.x
                 ┌──┴───┐
 ┌───────────────┤ eth0 ├───────────────┐
 │ Raspberry Pi  └──────┘               │
 │                  ▲                   │
 │                  │                   │
 │        ┌─────────┼──────────┐        │
 │        │         │          │        │
 │  ┌─────┴─────┐   │          │        │
 │  │  trojan   │   └──┐       │        │
 │  └───────────┘      │       │        │
 │        ▲            │       │        │
 │        │ 10.0.0.2   │       │        │
 │  ┌─────┴─────┐      │       │        │
 │  │ tun2socks │      │       │        │
 │  └───────────┘      │       │        │
 │        ▲            │       │        │
 │        │ 10.0.0.1   │       │        │
 │  ┌─────┴─────┐      │       │        │
 │  │   tun0    │      │       │        │
 │  └───────────┘      │       │        │
 │        ▲            │       │        │
 │        │            │       │        │
 │        └────────┐   │       │        │
 │                 │   │       │        │
 │             ┌───┴───┴──┐    │        │
 │             │ Routing  │    │        │
 │             │  Table   │    │        │
 │             └──────────┘    │        │
 │                 ▲   ▲       │        │
 │                 │   │       │        │
 │                 │   └───────┘        │
 │                 └─┐                  │
 │                   │                  │
 │               ┌───┴──┐               │
 └───────────────┤ eth1 ├───────────────┘
                 └──────┘
                    ▲ 192.168.2.1
                    │
                    │ 192.168.2.y
               ┌────┴─────┐
               │ Tunneled │
               │  Router  │
               └──────────┘
                    ▲ 192.168.3.1
                    │
  ┌──────┬──────────┴─────────┬───┐
  │      │                    │   │
  │ ┌────┴───┐                │  ┌┴─┐
  │ │Computer│ 192.168.3.a    │  │TV│ 192.168.3.d
  │ └────────┘                │  └──┘
  │                           │
┌─┴───┐                     ┌─┴────┐
│Phone│ 192.168.3.b         │Tablet│ 192.168.3.c
└─────┘                     └──────┘
```

Main components, in the upstream direction:
- Devices that have unrestricted Internet connection: computers, smart phones, etc.
- Tunneled router: Router used for all the client connections, which provides transparent fully tunneled Internet access
- `eth1`: One of the ethernet ports of the Raspberry Pi, used as the access point
- Routing table: Routes connections to specific interface, except for connections to the proxy server, which go directly upstream (to avoid an infinite loop)
- `tun0`: Specifically tunnel network interface that will be used for all the incoming traffic
- [tun2socks](https://github.com/xjasonlyu/tun2socks): Tunnel all Internet traffic fron network interface to socks proxy
- [trojan](https://github.com/trojan-gfw/trojan): Accepts socks proxy connections to connect to proxy server
- `eth0`: One of the ethernet ports of the Raspberry Pi, used as the station
- Primary router: Home router provided by the Internet provider

## Instructions

Assuming you have a Raspberry Pi with the latest OS installed:

1. Assemble everything
2. From a computer with visibility to the Raspberry Pi, run:

```
make sync
```

Now you can connect to the tunneled router and enjoy unrestricted Internet.
