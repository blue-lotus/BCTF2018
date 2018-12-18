import random
import gmpy2
from flag import FLAG


def calc(coeff, x):
    num = coeff[0]
    for i in range(1, len(coeff)):
        num = num * x + coeff[i]
    return num


def main():
    for i in range(10):
        n = random.randint(100, 120)
        coeff = []
        for j in range(n):
            coeff.append(random.randint(0, gmpy2.next_prime(1 << n)))
        x = raw_input("Please input your number to guess the coeff: ")
        x = int(x)
        num = calc(coeff, x)
        print('This is the sum: ' + str(num))
        guess = raw_input("It is your time to guess the coeff!")
        guess = guess.strip().split()
        guess = map(int, guess)
        for j in range(n):
            if guess[j] != coeff[j]:
                print("Sorry for wrong guess!")
                exit(0)
    print(FLAG)


if __name__ == "__main__":
    main()
