# Project 7
 ## WHAT IS NAS
 * NAS stands for *Network Attached Storage* which is a file level file storage server that is connected to a network. Basically a computer/server connected to a network with the sole purpose of providing file based storage using protocols like NFS(Network file System by sun microsystems),SMB(Server message block by Microsoft) or AFP(Apple filing protocol by Apple)

 ## WHAT IS SAN
 * SAN stands for *Storage Area Network* which is a computer network that provides access to data storage devices(block-level data storage).

 ## WHAT IS BLOCK-LEVEL STORAGE
 * This is a concept of cloub hosted data storage where the cloud services emulate the behaviour of a traditional block device such as a physical hard disk.

 ## SETTING UP THE NFS SERVERS
 * In AWS, I have spin up 4 RH servers, 3 webservers and 1 NFS server.
 * In AWS, I have created 3 Volumes and attached them to the NFS server.
 * From the terminal, will be running the following commands to create three logical volumes to the NFS server.
    ```
    - lsblk (To list all block volumes attached to this instance/server)
    - sudo gdisk /dev/xvdf (This is the command that uses the gdisk utility to create a single partitions on each of the the disk/volume where /dev/xvdf is one of them)
    - sudo yum install lvm2 -y (This is to instal the lvm2 package and the -y tag is to automatically answer yes to all prompts)
    - sudo lvmdiskscan (This command is to check for available partitions)
    - sudo pvcreate /dev/xvdf1 (The pvcreate utility is used to create physical volumes and I had to repeat this for all volumes). Notes you can also run it once for all volumes... sudo pvcreate /dev/xvdf1 /dev/xvdg1 /dev/xvdh1
    - sudo pvs (This will list the available phycal volumes)
    - sudo vgcreate webdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1 (This command creates a volume group called webdata-vg and assigned the three physical volumes to it.)
    - sudo vgs (This list the logical volumes available)..Please note the file system uses some of the space on the disk hence you do not get the exact amount of mem created on these disk
    - sudo lvcreate -n lv-apps -L 9G webdata-vg, sudo lvcreate -n lv-logs -L 9G webdata-vg, sudo lvcreate -n lv-opt -L 9G webdata-vg (These three command created the logical volumes(lv-apps,lvlogs,lv-opt) and attach them to a volume group)
    - sudo lvs (This list all logical volumes)
    - lsblk (Same as above but now you will see that the physical volumes have been assigned to volume groups and logical volume grouos respectively)
    - sudo vgdisplay -v #view complete setup - VG, PV, and LV (This command gives a more detailed information about all that has been configured so far.)
    - sudo mkfs -t xfs /dev/webdata-vg/lv-apps , sudo mkfs -t xfs /dev/webdata-vg/lv-logs sudo mkfs -t xfs /dev/webdata-vg/lv-opt (These commands are used to reformat the logical volumes as xfs)
    - sudo mkdir /mnt/logs, sudo mkdir /mnt/apps, sudo mkdir /mnt/opt (These are mount points created in the /mnt folder).
    - sudo mount /dev/webdata-vg/lv-apps /mnt/apps/, sudo mount /dev/webdata-vg/lv-logs /mnt/logs/, sudo mount /dev/webdata-vg/lv-opt /mnt/opt/ (These commands are used to mount the logical volumes to the mount points)
    - Now install NFS server using the following commands below:
        sudo yum -y update
        sudo yum install nfs-utils -y
        sudo systemctl start nfs-server.service
        sudo systemctl enable nfs-server.service
        sudo systemctl status nfs-server.service
    -  sudo chown -R nobody: /mnt/apps,  sudo chown -R nobody: /mnt/logs,  sudo chown -R nobody: /mnt/opt (Command to change owner of the mount points)
    - sudo chmod -R 777 /mnt/apps, sudo chmod -R 777 /mnt/logs, sudo chmod -R 777 /mnt/opt (Change mode read, write and execute for the mount points).
    - sudo systemctl restart nfs-server.service (Restart nfs service)
    - sudo vi /etc/exports (Edit file and paste code below in it with the subnet CIDR)
        /mnt/apps 172.31.16.0/20(rw,sync,no_all_squash,no_root_squash)
        /mnt/logs 172.31.16.0/20(rw,sync,no_all_squash,no_root_squash)
        /mnt/opt 172.31.16.0/20(rw,sync,no_all_squash,no_root_squash)
    - sudo exportfs -arv (The webservers will be able to connect and see the mount points)
    - rpcinfo -p | grep nfs (Check the ports used by NFS)
    - In AWS configure security groups allowing the ports 2049 & 111 for both TCP and UDP protocols 
    ```

    ## SETING UP THE MYSQL SERVER
    * In AWS I have an ubuntu server spinned up
    * Installing mysql after ssh into the box command: 
        ```
        - sudo apt upgrade
        - sudo apt install mysql-server -y 
        - sudo mysql
        - create database tooling;
        - create user 'webaccess'@'172.31.16.0/20' identified by 'password'; (Creates a user called webaccess and the IP is the public IP CIDR address of the DB instance)
        - grant all privileges on tooling.* to 'webaccess'@'172.31.16.0/20'; (Granting privileges for user to the DB)
        -flush privileges;

        ```

    ## SETTING UP THE WEBSERVERS
    ```
    - sudo yum -y update
    - sudo yum install nfs-utils nfs4-acl-tools -y (Install NFS client)
    - sudo mkdir /var/www (Create mount point on web server)
    - sudo mount -t nfs -o rw,nosuid 172.31.25.111:/mnt/apps /var/www (Mount that on the /mnt/apps folder created on the NFS server where 172.31.25.111 is the private IP address of the NFS server).
    - df -h (disk free is used to check that NFS was mounted successfully)
    - sudo vi /etc/fstab (To make sure that these changes remain on the webserver after reboot edit file and paste below):
    172.31.25.111:/mnt/apps /var/www nfs defaults 0 0
    - Run steps in guide
        1. sudo yum install httpd -y
        2. sudo dnf install https://dl.fedoraproject.   org/pub/epel/epel-release-latest-8.noarch.rpm
        3. sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
        4. sudo dnf module reset php
        5. sudo dnf module enable php:remi-7.4
        6. sudo dnf install php php-opcache php-gd php-curl php-mysqlnd
        7. sudo systemctl start php-fpm
        8. sudo systemctl enable php-fpm
        9. sudo setsebool -P httpd_execmem 1
    - sudo mount -t nfs -o rw,nosuid 172.31.25.111:/mnt/logs /var/log/httpd (Mount the apache log folder on the logs folder in the NFS server)
    - sudo vi /etc/fstab (For same reason as above, paste command: 172.31.25.111:/mnt/logs /var/www nfs defaults 0 0)
    - sudo yum install git
    - git clone https://github.com/darey-io/tooling.git
    - sudo cp -r tooling/html/* /var/www/html/ (Copy all files in the tooling folder cloned into the /var/ww/html folder)
    - sudo vi /var/www/html/functions.php (update the config with the DB username and password and private IP address)
    - mysql -h 172.31.26.75 -u webaccess -p tooling < tooling-db.sql (To connect to the remote DB server but note this will fail cos the mysql tooling has not been installed yet )
    - sudo yum install mysql -y
    - sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf (This has to be done on the DB server and set binding address to 0.0.0.0)
    - sudo systemctl restart mysql (DB server)
    - mysql -h 172.31.26.75 -u webaccess -p tooling < tooling-db.sql (Ran from the tooling directory, to run the script on the DB)
    - sudo mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.backup (changing the default home page)
    - sudo chmod 777 /var/www/html
    - sudo setenforce 0
    - sudo vi /etc/sysconfig/selinux
        (SELINUX=disabled)
    - curl -v localhost (This is used to check if the webserver is working)
    ```

    ## Questions
    * When a mount point is created from a server to a remote server, does it mean that content there does not use up memory resources?