#!/usr/local/bin/python3
# coding: utf-8
# 2019/07/31
# https://www.cnblogs.com/jsonhc/p/7280293.html

log_file = "/var/log/nginx/access.log"

with open(log_file) as f:
    contexts = f.readlines()

# define ip dict###
ip = {}
flow = {}
sum = 0.0

for line in contexts:
    # count row size of flow
    size = line.split()[9]
    # print ip
    ip_attr = line.split()[0]
    # count total size of flow
    sum = int(size) + sum
    if ip_attr in ip.keys():
    # count of ip plus 1
        ip[ip_attr] = ip[ip_attr] + 1
    # size of flow plus size
        flow[ip_attr] = flow[ip_attr] + int(size)
    else:
    # if ip not repeated
    # define initial values of count of ip and size of flow
        ip[ip_attr] = 1
        flow[ip_attr] = int(size)

print(ip)
print(flow)
print(str(sum // 1024.0 // 1024.0), 'MB')
