from pwn import *

import os
# p = process('python -u ../deploy/src/main.py', shell=True)
p = remote('47.91.109.4', 9999)
for i in range(5):
    data = p.recvuntil('Input your guess number: ', drop=True)
    data = data.strip()
    open('data', 'w').write(data)
    cmd = os.popen('sage exp.sage')
    ans = cmd.readline().strip()
    print(i, ans)
    p.sendline(ans)
print p.recv()
p.interactive()
