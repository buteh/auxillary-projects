# Project 11 (Ansible Configurartion Management)
* Configuration management is a way to make computer systems, servers, software in a desired consistent state. It is a way to make sure that system perform as it is supposed to as changes are made over time.
* Configuration management keeps you from making small or large changes that go undocumented. These kind of misconfigurartion are identified and manages in Kubernetes.
* VPC (Virtual Private Network)
* __Jump Server:__ This is also refered to as a Bastion Host is usually used as an intermediate server to reach/access an internal network
* In AWS launch 3 servers, 1 for Jenkins and acting as the ansible controller and two web servers.
* SSH in the Jenkins-ansible server and run the commands below
```
- sudo apt update
- sudo apt install ansible (Install ansible)
- sudo apt install default-jdk-headless (jdk is a prerequisite for jenkins download)

INSTALL THE JENKINS SERVER
- wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -  (This adds the repositories keys to the system and this should return with OK)
- sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' (This append the Debian package repository address to the server’s sources.list:)
- sudo apt update
- sudo apt-get install jenkins
```
* In the browser:  <Jenkins-Ansible-Server-Public-IP>:8080
* sudo cat /var/lib/jenkins/secrets/initialAdminPassword (Get the Jenkins server password).
* Create a new free style project and call is ansible-config-mgt
* **WEBHOOK:** Please note that a webhook is set in a repo to allow external services to be notified when certain events happen. When the specific event happens, github will send a post event to each url specified.
* Create a webhook in Jenkins and put in the url of git hub with a *github-webhook* suffix. (example: http://34.235.88.172:8080/github-webhook/)
* Screen shot below:
![Webhook Set Up](/images/proj11/webhook-setup.png)
* From the jenkins server
    - cd /var/lib/jenkins/jobs/ansible/builds/3/archive/
    - cat README.md
    (Shows the change that we made).
* On visual studio code install *Remote Development* pack.
* Restart VS code after installing a
plugging.
* Clone repository created in github in VS code
* Then run the following commands below
```
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ git checkout -b prj-11
Switched to a new branch 'prj-11'
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ mkdir playbooks
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ ls
LICENSE         README.md       playbooks
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ mkdir inventory
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ ls -lart
total 16
drwxr-xr-x   4 omon  staff   128 13 May 07:57 ..
-rw-r--r--   1 omon  staff  1062 13 May 07:57 LICENSE
-rw-r--r--   1 omon  staff    72 13 May 07:57 README.md
drwxr-xr-x  13 omon  staff   416 13 May 08:11 .git
drwxr-xr-x   2 omon  staff    64 13 May 08:12 playbooks
drwxr-xr-x   2 omon  staff    64 13 May 08:12 inventory
drwxr-xr-x   7 omon  staff   224 13 May 08:12 .
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ touch playbooks/common.yml
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ touch inventory/dev.yml
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ touch inventory/staging.yml
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ touch inventory/uat.yml
Omoaregbas-MacBook-Pro-2:ansible-config-mgt omon$ touch inventory/prod.yml
```
* The commmands above have created a new branch called *prj-11*, created two directories *inventory* and *playbooks* and created config files in both directories.
![VS Code](/images/proj11/vscode-setup.png)
* On jenkins/ansible server generate public keys:
    - ssh-keygen (This will generate the keys in ~/.ssh/ folder).
* Created 5 servers 2 RedHat Webservers, 1 RedHat DB server, 1 RedHat NFS server and 1 Ubuntu Load balancer.
* Name each server respectively
    - sudo vi /etc/hosts
    - sudo vi /etc/hostname
    - sudo reboot
    - Example below:
    ![Hosts file](/images/proj11/setservername1.png)
    ![HostName file](/images/proj11/setservername2.png)

* On all target machines
    * cd .ssh
    * ls (There should be authorized_keys)
    * sudo vi authorized_keys
    * Paste the key from the id_rsa.pub above to this location and save.




