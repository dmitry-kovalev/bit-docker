# Bit-docker
_Heavily reworked version of [bit-docker](https://github.com/teambit/bit-docker)._

A dockerfile setup to run your own [Bit](https://www.github.com/teambit/bit) server.  
If you want to setup a bare-bone Bit remote server without Docker, please refer to [this guide](https://docs.bit.dev/docs/bit-server).

## Getting started

1. Clone this repository.  
1. Build image  
    ```shell script
    $ docker build . -t bit
   ```
1. Create persistent volume for bit data and grant right permissions
    ```shell script
    $ docker volume create bit_data
    $ chown 2000:2000 /var/lib/docker/volumes/bit_data/_data 
    ```
1. Add all of yours public ssh keys in one file `authorized_keys` and change owner to `bit` user (UID:2000)
    ```shell script
    $ chown 2000:2000 authorized_keys
    ```   
1. Run container
    ```shell script       
    $ docker run --name bit \
        --detach --rm \
        -p 5022:22 -P \
        --mount type=volume,source=bit_data,target=/opt/scope \
        --volume `pwd`/authorized_keys:/home/bit/.ssh/authorized_keys \
        bit
    ```
**Note:** *You can change port 5022 to any as you want to use to connect to your bit server.*

If you run correctly all previous steps your server should be started successful.

To use bit on your local machine you should run following steps.   
1. Configure workspace to use the server.  
    ```shell script
    $ bit init
    $ bit remote add ssh://bit@<hostname>:5022:/opt/scope -g
    ```
1. Export components to a Bit server.  
    ```shell script
    $ bit export scope
    ```
1. Import components from a Bit server.  
    ```shell script
    $ bit import scope.<component-name>
    ````
1. Stop server  
    ```shell script
    $ docker kill bit
    ```

## Troubleshooting

### Unable to connect to server

- See if container is running.  
    ```shell script
    $ docker ps --all | grep bit
    ```
- Make the SSH port is configured correctly.  
    ```shell script
    $ docker port bit
    ```
  You should see something like this
  ```
  22/tcp -> 0.0.0.0:5022    
  ```
- See that your server is configured for your workspace.  
    ```shell script
    $ bit remote
    ```
    
### Unable to import/export

Bit uses SSH for networking. This setup [mounts](http://github.com/dmitry-kovalev/bit-docker/blob/master/README.md#L29) single [authorized_keys](https://www.ssh.com/ssh/authorized_keys/) 
file with public keys of all yours users.  
To manually add keys just add it to your authorized_keys file:

### Run bash on the container

When you need to run any command on the Bit server, you first need to get bash on the container:

```sh
$ docker exec -it bit /bin/bash
```

Now each command you run, runs on the server.

### Tail server logs

To run the `tail` command and get the server's logs, you should first [get bash on the container](#run-bash-on-the-container). Then `tail` Bit's log:

```sh
$ tail -f /root/Library/Caches/Bit/logs/debug.log
```

## Contributing

Contributions are always welcome, no matter how large or small.

## License

MIT License.
