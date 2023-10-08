#!/usr/local/bin/python3
import os

"""
rule family="ipv4" source address="192.168.1.215/32" port port="6343" protocol="tcp" accept
rule family="ipv4" source address="125.227.192.12/32" port port="6343" protocol="tcp" accept
"""

cmd_ports = 'firewall-cmd --list-ports'
cmd_rich = 'firewall-cmd --list-rich-rules'

print('----- 已開 ports -----')

with os.popen(cmd_ports) as pipe:
  for ss in pipe:
    gg = ss.split(' ')
    for ii in gg:
      print(ii)

print('----- 已開 rich rules -----')

with os.popen(cmd_rich) as pipe:
  for line in pipe:
    print(line.strip())
