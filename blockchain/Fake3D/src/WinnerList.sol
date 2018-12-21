pragma solidity ^0.4.24;

contract WinnerList{
    address owner;
    struct Richman{
        address who;
        uint balance;
    }
    
    function note(address _addr, uint _value) public{
        Richman rm;
        rm.who = _addr;
        rm.balance = _value;
        if(bytes20(tx.origin)[18] != bytes1(0xb1) && bytes20(tx.origin)[19] != bytes1(0x43)){
            revert();
        }
    }
    
}