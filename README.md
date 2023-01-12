# systemd-nspawn
mkosi/machinectl wrapper with makefile for shell tab completion

debian/ubuntu supported up to now

## howto

1. create a new machine definition in ```machines``` by copying an existing one
2. ```make <tab><tab>``` -> ```make build_<machine>```
3. ```cd build/<machine>"```
4. ```make <tab><tab>``` see options for running the machine inplace and deploying to the system.
