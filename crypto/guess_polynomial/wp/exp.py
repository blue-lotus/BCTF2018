from pwn import *
import gmpy2
context.log_level = 'DEBUG'
#p = process('python -u ../src/main.py', shell=True)
p = remote('192.168.222.148', 1337)
num = gmpy2.next_prime(1 << 120)


def getcoff(sum):
    ans = []
    while sum:
        ans.append(sum % num)
        sum = sum / num
    return ans[::-1]


for i in range(10):
    p.recvuntil('Please input your number to guess the coeff: ')
    p.sendline(str(num))
    p.recvuntil('This is the sum: ')
    sum = int(
        p.recvuntil('It is your time to guess the coeff!', drop=True).strip()
    )
    ans = getcoff(sum)
    payload = ''
    for item in ans:
        payload += str(item) + ' '
    p.sendline(payload)
p.interactive()
