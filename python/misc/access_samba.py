import smb
from smb.SMBConnection import SMBConnection
import tempfile     # 
import shutil       # 

share_name = 'fromSMB'
user_name = 'swrd'
password = 'password123'
server_IP = '192.168.124.133'
server_machine_name = 'SMB Server133'
local_machine_name = 'SMB Client101'

conn = SMBConnection(user_name, password, local_machine_name, server_machine_name, use_ntlm_v2 = True)

# Server 端啟動 smb, nmb 服務後(smdb, nmdb)
# smdb daemon 使用 TCP/445 作 SMB Connection, 另外也使用 TCP/139 供 NetBIOS over TCP
assert conn.connect(server_IP, 445)
# assert conn.connect(server_IP, 139)

# List all files at the root of the share
files = conn.listPath(share_name, "/")

for item in files:
    print (item.filename)

print('---------')


conn.close()
