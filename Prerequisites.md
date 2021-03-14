# Prerequisites for Hyperledger Fabric

### Virtual Machine (VirtualBox)
* Ubuntu 20.04 - 4GB RAM, 40GB Storage
* Ubuntu 20.04 - 2GB RAM, 20GB Storage

### OpenSSH
```
sudo apt install openssh-server
sudo systemctl status ssh
```

### RemoteSSH Virtual Machine (Note down the IPv4 Address(inet))
```
sudo apt install net-tools
ifconfig 
``` 
* In VirtualBox Select VirtualBox VM 
  * Settings > Network
  * Advanced > Port Forwarding
  * Add new port forwarding rule (replace &lt;IP Address&gt; with ip acquired in ifconfig)  

|Name|Protocol|Host IP|Host Port|Guest IP|Guest Port|
|:-------:|:--------:|:---------:|:---------:|:------------:|:---------:|
| OpenSSH |TCP|127.0.0.1|2222|&lt;IP Address&gt;|22  
<br>

* Download Visual Studio Code Remote - SSH Extension By Microsoft
* Press `cmd/ctrl + Shift + p` to open Command Palette 
* Type > `Remote-SSH: Open Configuration File`
* Select `~/.ssh/config` and write this (replace Name &lt;name&gt; with required name & &lt;username_of_vm&gt;)
  
``` 
Host <name>
  HostName 127.0.0.1
  User <username of VM>
  Port 2222 
```
* Then again press  `cmd/ctrl + Shift + p` & select > `Remote-SSH: Connect Current Window` to Host & select the Host which is defined in config file.
* Select continue for fingerprint and type the password.
* After RemoteSSH is connected with VM, select explorer in vscode and select open folder and press Ok, create new directory in the home directory of VM called 'fabric', this is the workspace where all fabric code and binaries lies.
* Now either from vscode terminal or a host terminal/cmd ssh the vm using below command and install all prerequisites.  
```
ssh <username>@127.0.0.1 -p 2222
```  
### Install Prerequisites
> __Git__  
```
sudo apt install git -y
```  

> __cURL__  
```
sudo apt install curl
```  

> __Docker__  

 _Update the apt package index and install packages to allow apt to use a repository over HTTPS:_  
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common 
```   
 
 _Add Docker’s official GPG key:_  
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```  
 
 _Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint._  
 
```
sudo apt-key fingerprint 0EBFCD88
```  
 
 _Use the following command to set up the stable repository_  
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
```  
 
 _Install docker engine_  
```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```  
 
 _You can check the version of Docker you have installed with the following command from a terminal prompt:_  
```
docker --version
```  
 
 _Make sure the docker daemon is running._  
```
sudo systemctl start docker
```  
 
 _Optional: If you want the docker daemon to start when the system starts, use the following:_  
```
sudo systemctl enable docker
```  
 
 _Add your user to the docker group.(replace &lt;username&gt; with VM username)_  
```
sudo usermod -a -G docker <username>
``` 
  
__Reboot the VM__  
 After rebooting check whether docker commands are working without sudo (eg - `docker ps`)

> __Docker Compose__

_Run this command to download the current stable release of Docker Compose (replace &lt;version&gt; with latest version):_  
```
sudo curl -L "https://github.com/docker/compose/releases/download/<version>/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```  

_Apply executable permissions to the binary:_  
```
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

> __Node.js && NPM__  
```
sudo apt update && sudo apt upgrade
sudo apt install nodejs
node --version
sudo apt install npm
npm --version
```

> __Go__  
```
sudo apt update && sudo apt upgrade
```  

_Download latest golang a file from following url, replace <latest_archive> with latest archive from [GoLang Downloads](https://golang.org/dl/)_  
```
wget https://dl.google.com/go/<latest_archive>
```  

_Extract the tar file:_  
```
sudo tar -C /usr/local -xzf <latest_archive>
```

_Set up Go environment_  
```
sudo nano .profile
```  

Paste the below exports at the end of the .profile file and save it.
  ```
  export GOROOT=/usr/local/go
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
  ```
_source the .profile file_  
```
source .profile
```  

_Check the version_  
```
go version
```

> _Install Samples, Binaries, and Docker Images (in fabric directory which was created at the start)_   

For latest version:
```
curl -sSL https://bit.ly/2ysbOFE | bash -s
```
For specific version:
```
curl -sSL https://bit.ly/2ysbOFE | bash -s -- <fabric_version> <fabric-ca_version>
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.3.0 1.4.9
```

For testing all installations run fabric test network, which can be referred from [Fabric Docs](https://hyperledger-fabric.readthedocs.io/en/latest/test_network.html)

Adding bin folder of fabric samples to the PATH variable (it can also be added to .profile to make the permanent).
```
export PATH=$HOME/fabric/fabric-samples/bin:$PATH
```

> _Recommended VSCode Extensions_
1. [Docker for Visual Studio Code](https://code.visualstudio.com/docs/containers/overview) 
2. [Go for Visual Studio Code](https://code.visualstudio.com/docs/languages/go)
3. [Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense)
4. [Visual Studio IntelliCode](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.VSIntelliCode)
5. [YAML Language Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
6. [Bash IDE](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)
7. [Spelling Checker for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
8. [Prettier Formatter for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)


> _Directory structure to be followed in 'fabric' directory_
<pre>
.
+-- <b><span style="color:aqua">api</span></b>
|   +-- <span style="color:aqua">wallet</span>
|   +-- <span style="color:CornflowerBlue">connection-profile.json</span>
|   +-- <span style="color:CornflowerBlue">enroll-admin.json</span>
|   +-- <span style="color:CornflowerBlue">register-enroll-client-user.js</span>
|   +-- <span style="color:CornflowerBlue">server.js</span>
|   +-- <span style="color:CornflowerBlue">package-lock.json</span>
|   +-- <span style="color:CornflowerBlue">package.json</span>
+-- <b><span style="color:aqua">chaincode/supplychain/go</span></b>
|   +-- <span style="color:CornflowerBlue">chaincode.go</span>
|   +-- <span style="color:CornflowerBlue">go.mod</span>
|   +-- <span style="color:CornflowerBlue">go.sum</span>
+-- <b><span style="color:aqua">config</span></b>
|   +-- <span style="color:CornflowerBlue">configtx.yaml</span>
|   +-- <span style="color:CornflowerBlue">core.yaml</span>
|   +-- <span style="color:CornflowerBlue">orderer.yaml</span>
+-- <b><span style="color:aqua">network</span></b>
|   +-- <b><span style="color:aqua">configtx</span></b>
|       +-- <span style="color:CornflowerBlue">configtx.yaml</span>
|   +-- <span style="color:aqua">docker</span>
|       +-- <span style="color:aqua">base</span>
|           +-- <span style="color:CornflowerBlue">.env</span>
|           +-- <span style="color:CornflowerBlue">docker-compose-base.yaml</span>
|           +-- <span style="color:CornflowerBlue">peer-base.yaml</span>
|       +-- <span style="color:CornflowerBlue">docker-compose-ca.yaml</span>
|       +-- <span style="color:CornflowerBlue">docker-compose.yaml</span>
|   +-- <span style="color:aqua">organizations</span>
|   +-- <span style="color:CornflowerBlue">chaincode_lifecycle.sh</span>
|   +-- <span style="color:CornflowerBlue">create_artifacts.sh</span>
|   +-- <span style="color:CornflowerBlue">create_channel.sh</span>
|   +-- <span style="color:CornflowerBlue">start_ca.sh</span>
|   +-- <span style="color:CornflowerBlue">start_network.sh</span>
|   +-- <span style="color:CornflowerBlue">stop_ca.sh</span>
|   +-- <span style="color:CornflowerBlue">stop_network.sh</span>
|   +-- <span style="color:CornflowerBlue">teardown_ca.sh</span>
|   +-- <span style="color:CornflowerBlue">teardown_network.sh</span>
|   +-- <span style="color:CornflowerBlue">terminal_control.sh</span>
</pre>



<!-- 
sudo scp -P 2232 terminal_control.sh hlfabric@127.0.0.1:~/fabric
sudo scp -P 2232 -r network hlfabric@127.0.0.1:~/fabric

<span style="color:CornflowerBlue"></span> -->