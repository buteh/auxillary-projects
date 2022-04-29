### Jenkins

* It is a self contained automation software that can be used different task such as building, testing and deploying software

* It can be installed via native system packages, docker or even standalone by any machine with java runtime environment.

## Installing Jenkins on my MacOs Mojave
* The command from the site jenkins.io for Mac OS *brew install jenkins-lts* did not work so I had to use the -k flag as shown below to make this work
```
 * brew install -k jenkins-lts 
 * Install the latest LTS version: brew install jenkins-lts
* Install a specific LTS version: brew install jenkins-lts@YOUR_VERSION
* Start the Jenkins service: brew services start jenkins-lts
* Restart the Jenkins service: brew services restart jenkins-lts
* Update the Jenkins version: brew upgrade jenkins-lts
```
The default password after installation is captured in screenshot below

![Password](/images/jenkins/password)

## Common tools needed to have for to run Jenkins for Java and C#

1. Git
    * In the global config put the path to your git home 
    ```
    Omoaregbas-MacBook-Pro-2:jenkins omon$ which git
    /usr/local/bin/git
    ``` 
    */usr/local/bin/git* is the git home
1. Java
    * To find the git home on your local Mac machine 
    ```
    Omoaregbas-MacBook-Pro-2:jenkins omon$ $(dirname $(readlink $(which javac)))/java_home
    /Library/Java/JavaVirtualMachines/sapmachine-jdk-11.0.11.jdk/Contents/Home
    ```
    */Library/Java/JavaVirtualMachines/sapmachine-jdk-11.0.11.jdk/Contents/Home* Enter this path also for JDK in the global config in jenkins.
1. Maven
    * Set the path like above
    ```
    /usr/local/Cellar/maven/3.6.1/
    ```
1. Nuget

## Automating Projects
* We will be dealing with two main ways of building Java projects
1. Freestyle Projects
1. Pipeline Projects
## Jenkins Freestyle project
* Specifying the git repo and setting up the variables for java, and build tool i.e maven or ant and running the build.

## Jenkins pipeline project
* Creating a new item but with the option pipeline which gives a different UI from the freestyle build mentioned above. 
* Note that you need to specify a node when building pipelines
```
node('built-in') {
    git 'https://github.com/executeautomation/SeleniumWithCucucumber.git'
    mvnHome = tool 'Local Maven Installation'
    echo "${mvnHome}"
    sh "${mvnHome}bin/mvn verify"
}
```

* You can add reporting to your builds by downloading the cucumber reports plugin in Jenkins and this will give the options to view reports for projects with cucumber test

* You can also add steps to a build when using the piple mode to build project and this will be a change to the way the script above is done:
```
node('built-in') {
    stage('git checkout') {
         git 'https://github.com/executeautomation/SeleniumWithCucucumber.git'
    }
   
    stage('set mvn home and run mvn goal') {
        mvnHome = tool 'Local Maven Installation'
        echo "${mvnHome}"
        sh "${mvnHome}/bin/mvn verify"
    }
    
    stage('generate test report') {
        cucumber buildStatus: 'null', customCssFiles: '', customJsFiles: '', failedFeaturesNumber: -1, failedScenariosNumber: -1, failedStepsNumber: -1, fileIncludePattern: '**/*.json', pendingStepsNumber: -1, skippedStepsNumber: -1, sortingMethod: 'ALPHABETICAL', undefinedStepsNumber: -1
    }
    
    
}
```

## Jenkins with C#/.Net
* As with java we have a pom.xml file where all references are defined in the xml file but with a C# project, all the references are in the references Nuget package.

* The test framework in here is Nunit which is different from Junit in Java.

* To build a .NET project you need to install MSbuild plugin in Jenkins

## Understanding ABC of Docker (Youtube lecture)
* It is a software containerization platform, everything in docker is basically a container i.e it hold everything as a container.
* A container contains:
    1. The operating system
    1. Software that you build
    1. Dependencies to run the software(pre-requisite softwares)
    1. Environment variables

* A container is an isolated place where an application can run without affectiing the rest of the system and without the system affecting the application. If you were inside a container it will look like you were in a different phycial device or virtual machine.

# Docker commands
* *docker run ubuntu* this command is used to install ubuntu OS, run is a command used to download software.
* *docker run -it ubuntu bash* this is how to log into the installed container "-it" means login in interactive mode.
* You can check the logs of your container using commend *docker logs <containerId>*
* Listing all docker containers *docker ps -a*
* Removing containers *docker rm <containerId>* and note that you need to stop a container before you remove it using command *docker stop <containerId>*
* Stoping and removing a container does not mean the image has been removed List images in docker using command *docker images*
* remove an image using command *docker rmi <imageId>*
* You can get the syntax to download docker images from *https://hub.docker.com/*
* Below are sample commands run to set up docker and mysql and link both containers to communicate:
```
* docker pull mysql
* docker images
* docker run --name easql -e MYSQL_ROOT_PASSWORD=abc123 -d mysql:latest
* docker ps -a
* docker pull wordpress
* docker images
* docker run --name ealocal --link eamysql:mysql -p 8080:80 -d wordpress
* docker run --name ealocal --link easql:mysql -p 8080:80 -d wordpress
* docker ps -a
* docker port cbef0a3ffc30
```
### Docker Compose
This is a tool for running multiple container docker applications. You use a compose file to configure you application services and you can then use a single command you create and start all services from configuration.

* You create yml file to run docker compose

* *docker-compose up* is used to start the services defined in a yml file.

* *docker-compose down* is used to stop the services defined in a yml file.

* *docker-compose ps* this displays running services.

* *NOTE::: I HAVE A SAMPLE DOCKER COMPOSE YML FILE IN MY PERSON REPO....SO OMON GO THERE FOR TIPS*

## Jenkins with Docker for mail server
* From hub docker, search for maildev by djfarrelly you will find command to download the container using docker.

* to Start the server use command *docker run -p 1080:80 -p 1025:25 djfarrelly/maildev*
    - 1080:80 is used to forward the container/host webapp server to port 80 so it can be reached via the internet
    - 1025:25 is used to forward the smtp server to port 25.
    - djfarrelly/maildev is the container name

* 

## Pipeline as a code
* This is maintained in a source code repo which is different from the traditional freestyle job with config file.

* Code must contain a file names Jenkinsfile in its root directory

* lts: Long time support
* Pipeline as code can be written in two ways:
    1. Declarative pipelines
    2. Scripted pipelines.
## Issues faced
* I ran into issues building using the pipeline option as it could not locate mvn. Even though it was configured on jenkins. This was fixed by specifying the bin directory which is where mvn is located in the maven directory. Command is in section *Setting up a build pipeline*

