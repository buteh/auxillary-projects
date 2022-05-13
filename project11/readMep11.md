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
![Webhook Set Up](images/proj11/webhook-setup)
