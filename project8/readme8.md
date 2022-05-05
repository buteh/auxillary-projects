# Project 8

## NSLOOKUP
* Domain names are used to identify internet resources such as computers, networks and services with a name that easier to memorise than an IP address.
* When you have a single server and load increases you can fix the load issue by increasing the capacity(CPU/RAM) and this is called *VERTICAL SCALING*. This has its draw back as there is a limit to the amount of resource you can add to a single server.
* The alternative to the above solution is adding more servers thus distributing the load across multiple servers and this is called *HORIZONTAL SCALING*. This is better because you have the ability to scale up or down depending on the traffic on your site.

## LOAD BALANCING
* A load balancer is needed when we have multiple servers to be accessed thus this stands as a bridge responsible for distibuting the traffic accross your different servers.
* Different Algorithms Used for Load balancing
    1. Round Robin : Request are distributed across the group of servers sequentially
    1. Least Connections: Request is sent to the server with the fewest connections to clients.
    1. Least time: Sends request to a server in the cluster with the fastest response time and least connections.
    1. Hash: Distributes request based on a defined key which could be an IP add ot request url.
    1. IP Hash: Ip address is used to determine receiving server.
    1. Random with Two Choices: Picks two options and picks the one with the least connections algorithm.
* Session persistence is the ability to stick a user to a particular server when a session is established by that user. This is handled by the load balancer and it can also be called *sticky sessions*.
* LAYER 4 LOAD BALANCING:
    This type of load balancing is done based on source and target IP address and the content been transported is not inspected nor plays any part in the load balancing.
* LAYER 7 LOAD BALANCING:
    In this type of load balancing the content i.e transport packets are inspected and decision of load balancing can be dine based on that hence making it a more complex/intelligent way of load balancing though it is a more expensive operation.
    Devices that do Layer7 load balancing are usually referred to as *reverse-proxy servers*.

## SETTING UP THE LOAD BALANCER
* A new instance with ubuntu is spin up in AWS and the the following commands below are run in sequence
```
#Install apache2
- sudo apt update
- sudo apt install apache2 -y
- sudo apt-get install libxml2-dev

#Enable following modules:
- sudo a2enmod rewrite
- sudo a2enmod proxy
- sudo a2enmod proxy_balancer
- sudo a2enmod proxy_http
- sudo a2enmod headers
- sudo a2enmod lbmethod_bytraffic

#Restart apache2 service
- sudo systemctl restart apache2

Then make sure apache is up and running
- sudo systemctl status apache2
```
* Configure Load balancing 
```
sudo vi /etc/apache2/sites-available/000-default.conf

#Add this configuration into this section <VirtualHost *:80>  </VirtualHost>

<Proxy "balancer://mycluster">
               BalancerMember http://<WebServer1-Private-IP-Address>:80 loadfactor=5 timeout=1
               BalancerMember http://<WebServer2-Private-IP-Address>:80 loadfactor=5 timeout=1
               ProxySet lbmethod=bytraffic
               # ProxySet lbmethod=byrequests
        </Proxy>

        ProxyPreserveHost On
        ProxyPass / balancer://mycluster/
        ProxyPassReverse / balancer://mycluster/

#Restart apache server

sudo systemctl restart apache2
```
* The log files in the web server are in the */var/log/httpd/* directory

* sudo umount -f /var/log/httpd (Command to unmount a dir)
* Apache Load balancing Algorithms are:
    - Request counting
    - Weighted traffic counting
    - Pending request counting
    - Heartbeat traffic counting
* On the web servers you can tail the log:
    - sudo tail -f /var/log/httpd/access_log
* To configure DNS on the Load balancer
```
#Open this file on your LB server

sudo vi /etc/hosts

#Add 2 records into this file with Local IP address and arbitrary name for both of your Web Servers

<WebServer1-Private-IP-Address> web1
<WebServer2-Private-IP-Address> web2
```
* Now edit the load balancer config file with the dns names:
    - sudo vi /etc/apache2/sites-available/000-default.conf
    ```
    BalancerMember http://web1:80 loadfactor=5 timeout=1
    BalancerMember http://web2:80 loadfactor=5 timeout=1
    BalancerMember http://web3:80 loadfactor=5 timeout=1
    ```
* curl (Means: Client Url)