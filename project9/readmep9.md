# PROJECT 9
## CI/CD
* Continuous Integration:
    - This is a situation where multiple developers work on a particular code base and constantly commit code changes to a repo which handles automates building and testing each commit.
* Continuous Delivery:
    - This is a situation where your code/application is always ready to be deployed though a manual process is usually needed to deploy the application.
* Continuous Deployment:
    - In this situation you have a setup to automate builds, testing and deployments. Here, if all test pass, each build is pushed through the development pipeline into production.

## Install and Configure Jenkins Server
```
- sudo apt update 
- sudo apt install default-jdk-headless (Install the java jdk...You will notice that the headless version is used. This is the same as the normal jdk installed on a PC just that it does not have support  for display device, keyboard and mouse)
INSTALL THE JENKINS SERVER
- wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -  (This adds the repositories keys to the system and this should return with OK)
- sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' (This append the Debian package repository address to the server’s sources.list:)
- sudo apt update
- sudo apt-get install jenkins
```
* In AWS update the security group to allow TCP port 8080
* Now on a browser <Instance public IP address>:8080
* Get password:  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
* fork the tooling repo to my own repo.
* In the tooling project, go to settings, webhook and add url of Jenkins server.
* In Jenkins create a freestyle project, I called mine project9 and in source code management I attached my forked repo and added the login credentials aswell.
* In Jenkins configure to triggers to build whenever there is commit and create an archive. Screens shots below
* Please note that the archives are created in the folder below
 ```
 sudo ls /var/lib/jenkins/jobs/project9/builds/3/archive/
 ```
 ## Configure Jenkins to Copy Files to NFS Server
 * We have the artefacts created in the archive folder above but now we want to copy them to the NFS server mount point i.e /mnt/apps
 * Install *Push over SSH* in Jenkins
 * Configure Jenkins with credentials i.e copy the private key for connecting to the server
 On the NFS server do the follwing to allow files copied over:
 ```
 - sudo chmod 777 /mnt/apps
 - sudo chown nobody:nobody /mnt/apps
 ```