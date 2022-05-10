# Project 10 Load balancing NGINX

* TLS is a new version of SSL and they are a protocol used to encrypt data been passed between client and server over the internet. This is usually used to avoid MIMT (Man in the Middle attack).

* Edit apache LB config file
```
- sudo vi /etc/apache2/sites-available/000-default.conf
-   
    #<Proxy "balancer://mycluster">
         #BalancerMember http://web1:80 loadfactor=5 timeout=1
         #BalancerMember http://web2:80 loadfactor=5 timeout=1
         #BalancerMember http://web3:80 loadfactor=5 timeout=1
         # ProxySet lbmethod=bytraffic
        # ProxySet lbmethod=byrequests
    #</Proxy>

    (Comment out the balancer section)
- sudo systemctl restart apache2
- Confirm on browser you can not reach site via the LB config
```
* A host file is used to map domain names to IP addresses.
* A host file has priority over a DNS server. So when you type in a domain name in a browser the operating system first checks the hostfile to the corresponding domain and then if there is no entry it will query the configures DNS server to resolve the domain name to an IP address.
* Created a domain in godaddy
* In AWS in route53 create a hosted zone with the domain name created and copy the name servers generated to my domain config in go daddy.
* I created a record from route53 and put the public IP address of my ubuntu loadbalancer. 
* In my nginx load balancer, create a load balancing config
    ```
    - sudo vi /etc/nginx/sites-available/load_balancer.conf
    - Pasted this in:
        upstream myproject {
                server 172.31.22.223 weight=5;
                server 172.31.20.215 weight=5;
                server 172.31.31.85 weight=5;
        }

        server {
                listen 80;
                server_name acedcare.co.uk www.acedcare.co.uk;
                location / {
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_pass http://myproject;
                        }
        }
    - cd /etc/nginx/site-enabled
    - sudo ln -s ../sites-available/load_balancer.conf . (Created a symbolic link from the newly created file to site enabled folder).
    - sudo systemctl restart nginx
    - sudo systemctl reload nginx
    - sudo systemctl status nginx
    ```
* Go to browser and use domain name to reach your site.
* Installing certbot this is used to make the site secure
    - sudo systemctl status snapd (Make sure snapd is installed)
    - sudo snap install --classic certbot (Install certbot)
    - sudo certbot --nginx -d acedcare.co.uk -d www.acedcare.co.uk
    Now reload site
* Certificate generated for the site is valid 90 days by default.
* To create a cronjob that runs periodically to update the cert.
    - crontab -e (To create a job in linux, this will prompt for which editor you want)
    - * */12 * * *   root /usr/bin/certbot renew > /dev/null 2>&1 (Place that in the the crontab file....note that dev null means that this command should not generate any logs.)
* sudo ln -s /snap/bin/certbot /usr/bin/certbot (Performed when snap is used to install certbot)
* sudo nginx -t (Command used to check if nginx config. file has no errors)