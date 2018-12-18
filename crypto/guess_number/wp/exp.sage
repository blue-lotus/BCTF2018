import ast
q = 1461501637330902918203684832716283019655932542983L
d = 22
l = 9
bound = q / (2 ** (l+1))

data = open('data').read()
data=data.split('\n')
t,u = map(ast.literal_eval,data)

m = []
for i in range(d):
    tmp = [0] * (d+2)
    tmp[i] = q
    m.append(tmp)
m.append(t+[1/(2**(l+1)), 0])
m.append(u+[0, bound])

ma = matrix(QQ, m)
mb = ma.LLL()

num = -mb[1][-2] * (2**(l+1))
if num<0:
    num = num+q
print num
