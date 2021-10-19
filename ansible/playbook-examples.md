


## Install httpd

- https://www.middlewareinventory.com/blog/ansible-playbook-example/#What_is_Ansible_Playbook


## Install httpd && tomcat

- https://www.middlewareinventory.com/blog/ansible-playbook-example/#What_is_Ansible_Playbook

```yml
### example_install_httpd_and_tomcat.yml
---
  # Play1 - WebServer related tasks
  - name: Play Web - Create apache directories and username in web servers
    hosts: webservers
    become: yes
    become_user: root
    tasks:
      - name: create username apacheadm
        user:
          name: apacheadm
          group: users,admin
          shell: /bin/bash
          home: /home/weblogic

      - name: install httpd
        yum:
          name: httpd
          state: installed

  # Play2 - Application Server related tasks
  - name: Play app - Create tomcat directories and username in app servers
    hosts: appservers
    become: yes
    become_user: root
    tasks:
      - name: Create a username for tomcat
        user:
          name: tomcatadm
          group: users
          shell: /bin/bash
          home: /home/tomcat

      - name: create a directory for apache tomcat
        file:
          path: /opt/oracle
          owner: tomcatadm
          group: users
          state: present
          mode: 0755
```

```bash
### 運行方式
ansible-playbook example_install_httpd_and_tomcat.yml -i /path/to/ansible_hosts
# -i: 可以指定自定義的 hosts file 位置, 預設為 /etc/ansible/hosts
```


## Install xxx with variable usage

- https://www.middlewareinventory.com/blog/ansible-playbook-example/#What_is_Ansible_Playbook

```yml
### example install_with_vairable_usage.yml
---
  - name: Playbook
    hosts: webservers
    become: yes
    become_user: root
    vars:  ## 使用變數的法1
       key_file:  /etc/apache2/ssl/mywebsite.key
       cert_file: /etc/apache2/ssl/mywebsite.cert
       server_name: www.mywebsite.com
    vars_files:
        - apacheconf.yml  ## 使用變數的法2
    tasks:
      - name: ensure apache is at the latest version
        yum:
          name: httpd
          state: latest
      ### SOME MORE TASKS WOULD COME HERE ###
      # you can refer the variable you have defined earlier like this #
      # "{{key_file}}"  (or) "{{cert_file}}" (or) "{{server_name}}" #
      ##
      - name: ensure apache is running
        service:
          name: httpd
          state: started
```

## Install LAMP

- https://www.middlewareinventory.com/blog/ansible-playbook-example/#What_is_Ansible_Playbook

```yml
### example_install_lamp.yml
### 不知道怎麼解釋... 僅留存
---
- name: Setting up LAMP Website
  user: vagrant
  hosts: testserver
  become: yes
  tasks:
    - name: latest version of all required packages installed
      yum:
        name:
          - firewalld
          - httpd
          - mariadb-server
          - php
          - php-mysql
        state: latest

    - name: firewalld enabled and running
      service:
        name: firewalld
        enabled: true
        state: started

    - name: firewalld permits http service
      firewalld:
        service: http
        permanent: true
        state: enabled
        immediate: yes

    - name: Copy mime.types file
      copy:
        src: /etc/mime.types
        dest: /etc/httpd/conf/mime.types
        remote_src: yes

    - name: httpd enabled and running
      service:
        name: httpd
        enabled: true
        state: started

    - name: mariadb enabled and running
      service:
        name: mariadb
        enabled: true
        state: started

    - name: copy the php page from remote using get_url
      get_url:
        url: "https://www.middlewareinventory.com/index.php"
        dest: /var/www/html/index.php
        mode: 0644

    - name: test the webpage/website we have setup
      uri:
        url: http://{{ansible_hostname}}/index.php
        status_code: 200
```


## using tar

- https://www.middlewareinventory.com/blog/ansible-archive-module-examples/

只接收 3 個參數:

- path : src path on target hosts
- dest : tar filename of dest path on target hosts
- format : tar file/dir
    - 資料夾預設為: `tar.gz`
    - 檔案預設為: `gz`

```yml
### 使用 tar 壓縮資料夾, tar -cvf (沒壓縮)
# 若 path 不存在就會報錯
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Compress Directory contents
      become: yes
      archive:
        path: /apps/tomcat
        dest: /apps/tomcat.tar  
        format: tar
```

```yml
### 使用 tar gz 壓縮資料夾, tar -czvf
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Compress Directory contents
      become: yes
      archive:
        path: /apps/tomcat
        dest: /apps/tomcat.tar.gz
        format: gz
```

```yml
###
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Compress the file using Default format
      become: yes
      archive:
        path: /apps/tomcat/conf/server.xml
        dest: /apps/tomcat/server.xml.gz
```

```yml
### 打包壓縮後, 移除原始檔
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Compress the file and remove
      become: yes
      archive:
        path: /apps/tomcat/logs/localhost-access.log
        dest: /apps/tomcat/localhost-access.log.gz
        remove: yes
```

```yml
### 使用 zip
# target host 需先安裝 zipfile package
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Compress Directory contents
      become: yes
      archive:
        path: /apps/tomcat/logs/catalina.2019-07-24.log   ## zip a file
        # path: /app/tomcat                                 ## zip a dir
        dest: /apps/tomcat/catalina.2019-07-24.log.zip
        format: zip
        remove: yes
```

```yml
### 使用 bzip
# target host 需先安裝 bzip package
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Compress the file using BZ2
      become: yes
      archive:
        path: /apps/tomcat/logs/catalina.2019-07-24.log
        dest: /apps/tomcat/catalina.2019-07-24.log.bz2
        format: bz2
    
    - name: Compress the Directory using BZ2
      become: yes
      archive:
        path: /apps/tomcat/
        dest: /apps/tomcat-bkp.tar.bz2
        format: bz2
```

```yml
### 打包壓縮許多檔案(使用 *)
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name: Using Wild card and choosing the catalina logs only
      become: yes
      archive:
        path: /apps/tomcat/logs/catalina*.log
        dest: /apps/tomcat/catalinalogs.tar.bz2
        format: bz2

    - name: Using Wild card and choosing the access logs only
      become: yes
      archive:
        path: /apps/tomcat/logs/*access*.txt
        dest: /apps/tomcat/accesslogs.tar.bz2
        format: bz2

    # Archive all the logs except access logs
    - name: Using wild card for Including and Excluding
      become: yes
      archive:
        path:   ## 可改為 list, 打包多個地方的檔案
        - /apps/tomcat/logs/*
        - /var/log/tomcat/*
        dest: /apps/tomcat/logfiles.tar.bz2
        format: bz2
        exclude_path:  ## 可排除特定檔案
        - /apps/tomcat/logs/*access*.txt
        - /var/log/tomcat/*access*.txt
```


```yml
### 
---
 - name: Ansible archive Examples
   user: vagrant
   hosts: testserver
   tasks:
    - name : Find files ending with extensions
      become: true
      find:  ## 1. Ansible find module
       paths: /apps/tomcat/logs  ## 2. 在這個路徑底下
       file_type: file
       # find files with different extensions 
       patterns:  ## 3. 找出底下的東西
         - '.*\.log$'
         - '.*\.out$'
         - '.*\.txt$'
       use_regex: yes
       age: 1d
       age_stamp: mtime
      register: output  ## 4. 將找到的檔案, 儲存到名為 output 的變數

    - name: archive the files
      become: yes
      become_user: tomcat
      archive:  ## 5. Ansible archive module (用來 打包壓縮/歸檔)
        remove: yes
        # Receive Each Element from the Loop
        path: "{{ item.path }}"  ## 7. 從 output 逐一取出的檔案路徑
        # Creating a file with Date filename-DDMMYY.bz2 format
        dest: "{{ item.path }}-{{ansible_date_time.date.replace('-','')}}.bz2"  ## 9. 設定存放路徑檔名
        format: bz2  ## 8. 將該路徑檔案做 bz2
      # Loop Statement, Goes through the find command output array
      with_items: "{{ output.files }}"  ## 6. 逐一迭代 output 變數的檔案
```

> `ansible_date_time.date.replace('-','')` 為 Ansible 內建的變數. Log Management 管理上很常用到這個