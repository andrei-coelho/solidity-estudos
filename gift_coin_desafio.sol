// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

contract GiftCoin {
  // keep track of all the addresses that have coins
  mapping (address => uint) coins; 
  // keep track of who the owner of this contract is
	address public owner; 

    constructor(){
        owner = msg.sender;
    }
  
  // This is an event we'll broadcast when a gift is successfully sent from one account to another
  event GiftSent(
      address from,
      address to,
      uint amount
  );
  
  function sendGift(address receiver, uint amount) public {
    // TODO: We need to take coins from the account that sent this and gift them to the reciever address
    // only if the account that sent this has sufficient funds
    // If successful we'll broadcast the GiftSent event
    require(coins[msg.sender] >= amount, "Insufficient funds");
    coins[msg.sender] = coins[msg.sender] - amount;
    coins[receiver] = coins[receiver] + amount;
    emit GiftSent(msg.sender, receiver, amount);
  }
  
  // this function will create new coins and should be reserved for only the owner to call it
  function mintCoins(address target, uint256 mintedAmount) onlyOwner public {
		coins[target] += mintedAmount;
	}
  
	modifier onlyOwner {
    // TODO: Update this line to require that the owner be the one calling the contract 
		require(msg.sender == owner, "Permission Denied");
        _;
     // The _ is a placeholder for the body of the modified method
    _;
	}

  // returns the balance of the address in question
  function balanceOf(address addr) public view returns(uint) {
    return coins[addr];
  }
}