#!/usr/local/bin/python3
# coding: utf-8
# 2019/07/31
# https://www.cnblogs.com/jsonhc/p/7280293.html

log_file = "/var/log/httpd/access_log"

with open(log_file) as f:
    contexts = f.readlines()

ip = {}
flow = {}
sum = 0.0

for line in contexts:
    size = line.split()[9]
    ip_attr = line.split()[0]
    try:
        sum = int(size) + sum
    except:
        continue
    if ip_attr in ip.keys():
        ip[ip_attr] = ip[ip_attr] + 1
        flow[ip_attr] = flow[ip_attr] + int(size)
    else:
        ip[ip_attr] = 1
        flow[ip_attr] = int(size)

print(ip)
print(flow)
print(str(sum // 1024.0 // 1024.0), 'MB')
