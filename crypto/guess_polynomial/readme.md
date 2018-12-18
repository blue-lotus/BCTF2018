# Title

Guess Polynomial

## Description

nc ip 1337

# Category

Crypto

# deploy

```shell
cd deploy
docker build -t guesspoly .
docker run --name="guesspoly" -d -p 1337:1337 guesspoly
```

# flag

BCTF{One_T1m3_10_Gue33_Coeff_1s_0K!}

# WP

This is a challenge about [positional notation](https://en.wikipedia.org/wiki/Positional_notation), there is only one representation for base-K when all the coefficients are smaller than K. So we just need to input big number.