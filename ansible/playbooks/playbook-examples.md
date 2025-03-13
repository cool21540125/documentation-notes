# format example

```yaml
---
- name: xxx
  user: xxx
  hosts: xxx
  vars: # 使用外部檔案的話, 涉及 include / roles
    xxx: xxx
    dns_server: 10.1.250.10
  tasks:
    - inlinefile:
        path: /etc/resolve.conf
        line: "nameserver {{ dns_server }}"
    - firewalld:
        port: 1000-1020/tcp
        permanent: true
        state: disabled
    - firewalld:
        service: https
        permanent: true
        state: enabled
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
### 等同於 tar -cf
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
### 等同於 tar -czf (gzip)
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
        path: /apps/tomcat/logs/catalina.2019-07-24.log ## zip a file
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
        path: ## 可改為 list, 打包多個地方的檔案
          - /apps/tomcat/logs/*
          - /var/log/tomcat/*
        dest: /apps/tomcat/logfiles.tar.bz2
        format: bz2
        exclude_path: ## 可排除特定檔案
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
    - name: Find files ending with extensions
      become: true
      find: ## 1. Ansible find module
        paths: /apps/tomcat/logs ## 2. 在這個路徑底下
        file_type: file
        # find files with different extensions
        patterns: ## 3. 找出底下的東西
          - '.*\.log$'
          - '.*\.out$'
          - '.*\.txt$'
        use_regex: yes
        age: 1d
        age_stamp: mtime
      register: output ## 4. 將找到的檔案, 儲存到名為 output 的變數

    - name: archive the files
      become: yes
      become_user: tomcat
      archive: ## 5. Ansible archive module (用來 打包壓縮/歸檔)
        remove: yes
        # Receive Each Element from the Loop
        path: "{{ item.path }}" ## 7. 從 output 逐一取出的檔案路徑
        # Creating a file with Date filename-DDMMYY.bz2 format
        dest: "{{ item.path }}-{{ansible_date_time.date.replace('-','')}}.bz2" ## 9. 設定存放路徑檔名
        format: bz2 ## 8. 將該路徑檔案做 bz2
      # Loop Statement, Goes through the find command output array
      with_items: "{{ output.files }}" ## 6. 逐一迭代 output 變數的檔案
```

> `ansible_date_time.date.replace('-','')` 為 Ansible 內建的變數. Log Management 管理上很常用到這個
