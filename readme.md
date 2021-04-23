# Vscode remote xdebug over ssh

This contains a small demo on how to setup xdebug over ssh and debug with vscode. 
It also contains som network tools, so you can experiment and debug your xdebug voyage.

Put this code on at machine med docker and run `make build up` and point your browser to
the `machine:8000`

## The setup

```
Computer A ip:192.168.1.10:9000 
  |
ssh tunnel
  | 
Computer B ip:10.0.0.1:9000
  |
Docker image ip:172.0.0.2
```

### Computer A
This has installed vscode with PHP Debug extention

In `launch.json` you need the following configuration:
```
{
    "name": "Listen for XDebug",
    "type": "php",
    "request": "launch",
    "hostname": "127.0.0.1",
    "port": 9000,
    "log": true, 
    "pathMappings": {
        "/var/www/service": "${workspaceRoot}/src"
    }
}
```

- `hostname`: to insure that it bind to IPv4. Otherwise it will bind IPv6
- `log`: set this to true, so it display a log info in the `Debug Console`
- `pathMappings`: maps from the remote location to local location. If not set it will not stop at your breakpoints.

### Computer B
This has installed ssh, dokker daemon and a docker image containing apache, php and xdebug (see Docker and docker-compose.yml)

- xdebug enabled (phpenmod xdebug)
- GatewayPorts=yes in sshd_config and restart sshd if you need to change it

In `xdebug.ini` your the following configuration:
```
zend_extension=xdebug.so
xdebug.remote_enable = 1
xdebug.remote_host = <container host>
xdebug.remote_port = 9000
```

- `remote_host`: is the ip of your docker host. In the above example it is Computer B. This is the point where xdebug will bind to.
- `remote_port`: must be the same as in `launch.json`

### Ssh tunnel

On your machine (Computer A) your run the following command:

`ssh -R 9000:localhost:9000 remote (Computer B)`

This will open a socket and listen on all interface on port 9000. You can verify this with

`netstat -tan `

and verify that there exists this value in the Local Address column 

`0.0.0.0:9000`

## Trouleshooting

Apart from activating debug in xdebug on the client and server the docker contains som net tools.
Especially Netcat which I used to debug connections between the components. By running as a simple
chat setup it is easy verify the connections problems. 
Start the listening part/server by `nc -l -p 7000` and a client part by `nc -D <ip> 7000` and start chatting.
