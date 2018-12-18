import random
from flag import FLAG
import gmpy2


def msb(k, x, p):
    delta = p >> (k + 1)
    ui = random.randint(x - delta, x + delta)
    return ui


def main():
    p = gmpy2.next_prime(2**160)
    for _ in range(5):
        alpha = random.randint(1, p - 1)
        # print(alpha)
        t = []
        u = []
        k = 10
        for i in range(22):
            t.append(random.randint(1, p - 1))
            u.append(msb(k, alpha * t[i] % p, p))
        print(str(t))
        print(str(u))
        guess = raw_input("Input your guess number: ")
        guess = int(guess)
        if guess != alpha:
            exit(0)


if __name__ == "__main__":
    main()
    print(FLAG)
