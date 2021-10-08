# Windows Docker Issues 


## bind docker port error, no permission

1. [Unable to bind ports: Docker-for-Windows & Hyper-V excluding but not using important port ranges](https://github.com/docker/for-win/issues/3171)

如果端口不可用，最简单的方式就是检查下哪些可用:

```bash
netsh interface ipv4 show excludedportrange protocol=tcp

```