# Ansible 

* Ansible is a popular IT automation engine that automates task that are either cubersome or repetitive or complex like configuration managment, clould provisioning, software deployment, and intra-service orchestration.
Benefits of Ansible in DevOps is to response and scale in pace with the demand.

Do we need Ansible? Why

* Ansible is very useful and you would appreciate it with the example when there are 4 or 5 web servers to be configured and deployed, and when there are more than 4 database servers to be configured and deployed. There are applications in the web servers and it connects the database servers at the backend. Now the traditional situation demands that you separately configure these servers and manage them.

* However, these servers will have various application updates. Even a system admin cannot handle if there are more servers and their configurations will not be identical. These tasks are complex to do and to manage the number of servers without putting a lot of effort into system admin as well as by developers who are developing the applications. Just imagine other servers which the organization has such as DNS, NTP, AD, Email, etc

* This is where Ansible comes into the picture. Infrastructure automation and orchestrations can be done by Ansible. All the similar servers can be handled and managed in one go by Ansible.

### Setup Lab

* Create three Machines (Using RedHat on AWS EC2 Instances): ansible-controller, ansible-target-1, ansible-target-2
#######################################################################

### Not Mandatory
* Connect to your vms using SSH
* Rename the hostname: sudo vi /etc/hostname
* In the open file, type the name you want to give the host. Eg Ansible-controller.
* Another place to modify is /etc/host file: sudo vi /etc/hosts
* Edit the host name eg: Ansible-controller

![Host Name File](/images/ansible/hostname_shot.png)

![Hosts File](/images/ansible/hosts_shot.png)

* Restart your system: shutdown now -r
* Repeat the same step for Ansible-target-1, Ansible-target-2


#########################

## Install Ansible on the Ansible-controller
* sudo yum update
* sudo yum install ansible
* Verify that Ansible is installed: ansible --version

## Ansible Inventory
* Ansible is agentless because it can connect to multiple servers using SSH for linux and powershell for Windows. Ansible can start managing remote machines immediately without any agent software installed.

* The information about this target systems are stored in the inventory file. If you do not create inventory file, Ansible will store it in the default location /etc/ansible/hosts

## Inventroy parameters are
* ansible_host - To specify the Address of the server
* ansible_connection - ssh/winrm/localhost
* ansible_port - 22/5986
* ansible_user - root/administrator
* ansible_ssh_pass - Password

### Example:
* web ansible_host=server1.example.com ansible_connection=ssh ansible_user=root
* db ansible_host=server2.example.com ansible_connection=winrm ansible_user=admin
* mail ansible_host=server3.example.com ansible_connection=ssh ansible_user=p@#
* web2 ansible_host=server4.example.com ansible_connection=winrm
Demo - Ansible Inventory

### Configure SSH Connection on the server
* Ansible-controller> cd .ssh
* Ansible-controller .ssh> ls
* There should be two files: Authorized-keys and known_hosts
* cat known_hosts - to view the content
* cat authorized-key - to view the content

### To generate a key for ssh connection
* Ansible-controller .ssh> ssh-keygen
* Ansible-controller .ssh> ls
* There should be id_rsa, id_rsa.pub cat id_rsa.pub
* Copy the key in the id_rsa.pub to the client machine
* sudo vi id_rsa.pub
* Copy the key

### On the client machine
* Connect to the client machine
* Ansible-target-1> cd .ssh
* Ansible-target-1 .ssh> ls
* There should be authorized_keys
* Ansible-target-1 .ssh> sudo vi authorized_keys
* Paste the key from the id_rsa.pub above to this location and save


### Test connectivity
* Ansible-controller> ssh target_server_IP address

### Test connectivity to Ansible
* Ansible-controller> create a folder called "test-project"
* Ansible-controller> cd test-project
* Ansible-controller test-project> cat > inventory.txt
* Press enter key
* Type: Ansible-target-1 ansible_host=Ansible-target-1IP_address ansibl_ssh_pass=password
* Press enter key
* Ansible-controller test-project> cat inventory.txt - To read the inventory fie
* Ansible-controller test-project> ansible Ansible-target-1 -m ping -i inventory.txt - To ping ansible on the target machine and verify the ansible controller can communitace with terget machine

#   YAML
* Ansible playbooks are text files written in a format known as yaml. Ansible playbooks are ansible orchestration language. It is in this file that we define what exactly we want ansible to do.
    * A *playbook* is a single YAML file 
    * A *play* defines a set of activities(task) to be run on hosts
    * A *task* is an action to be performed on a host and can range from:
        * Executint a command
        * Run a script
        * Install a package
        * Shutdown/Restart

* You can run ansible either using *ansible* or *ansible-playbook* commands.
    * Ansible command example
        * ansible all -m ping -i inventory.txt
            * The format is *ansible* the command 
            * *all* specifying all host, you can specify target servers/groups in this position
            * *-m* specifying the modules command
            * *ping* specifying we want to use the ping module
            * *-i* specifying the ansible inventory flag
            * *inventory.txt* specifying the actual inventory file been used.

    * Ansible playbook command example:
        * ansible-playbook playbook-pingtest.yaml -i inventory.txt
            * *playbook-pingtest.yaml* this is the playbook file that has been created in this directory with content below:
            
            ```
                -
                name: Test Connectivity to target servers
                hosts: all
                tasks:
                    - name: Ping test
                    ping:```
        
### Ansible Modules
* A few modules in a play book
 ```-
    name: 'Execute a script on all web server nodes and start httpd service'
    hosts: web_nodes
    tasks:
        -
            name: 'Update entry into /etc/resolv.conf'
            lineinfile:
                path: /etc/resolv.conf
                line: 'nameserver 10.1.250.10'
        -
            name: 'Create a new user'
            user:
                name: web_user
                uid: 1040
                group: developers
        -
            name: 'Execute a script'
            script: /tmp/install_script.sh
        -
            name: 'Start httpd service'
            service:
                name: httpd
                state: present
```
* In the above there is the service, user, lineinfile and script modules used.
* Note all ansible plays are indempotent.

### Ansible Variables
* Variables are referenced using {{ variable }} and this is called Jija2 templating. Variables can be defined in the actual yaml file as attribute vars for the playbook, in the hosts file or in a external yaml file that that has the same name as the host in the actual yml file for example in the example in the Ansible modules section you can define your variales in a file called web.yml because the host in that example is web as defined in the inventory file.
* Also wrap your variables in single quotes '{{ vaiable }}' though this is not required if the variable is not defined at the beginning of a declaration

### Ansible Conditionals
* Examples:
```
Runs a command for a specific server based on variable defined in inventory
-
    name: 'Execute a script on all web server nodes'
    hosts: all_servers
    tasks:
        -
            service: 'name=mysql state=started'
            when: ansible_host=="server4.company.com"

Echoes when a variable is met
-
    name: 'Am I an Adult or a Child?'
    hosts: localhost
    vars:
        age: 25
    tasks:
        -
            command: 'echo "I am a Child"'
            when: 'age < 18'
        -
            command: 'echo "I am an Adult"'
            when: 'age >= 18'

Enter an entry in conf file only if the entry is not present
-
    name: 'Add name server entry if not already entered'
    hosts: localhost
    tasks:
        -
            shell: 'cat /etc/resolv.conf'
            register: command_output
        -
            shell: 'echo "nameserver 10.0.250.10" >> /etc/resolv.conf'
            when: command_output.stdout.find("10.0.250.10") == -1
```

### Ansible loops

* This can be achieved by creating a directive on a task called loop or with_items and then reference the item in your task as thus {{ item }}.
* Examples:
```
This prints fruits
-
    name: 'Print list of fruits'
    hosts: localhost
    vars:
        fruits:
            - Apple
            - Banana
            - Grapes
            - Orange
    tasks:
        -
            command: 'echo "{{item}}"'
            with_items: '{{fruits}}'

Install a list of packages with loops

-
    name: 'Install required packages'
    hosts: localhost
    vars:
        packages:
            - httpd
            - binutils
            - glibc
            - ksh
            - libaio
            - libXext
            - gcc
            - make
            - sysstat
            - unixODBC
            - mongodb
            - nodejs
            - grunt
    tasks:
        -
            yum: 
                name: '{{ item }}' 
                state: present
            with_items: '{{ packages }}' 
```
