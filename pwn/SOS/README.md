# String on the Stack - BCTF 2018

## Vulnerability

An overflow when inputing the string. When size < 16, the string object would use its remaining space as buffer, thus it causes overflow on the stack.

## Exploit

To stop the input process, we can read until the stack boundary and `read` would return 0. Then we process the regular ROP attack.
