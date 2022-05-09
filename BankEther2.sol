// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract BankEther2 {

    struct Account {
        uint balance;
        uint limitToWithdraw;
        uint dateToWithdraw;
    }

    address owner;

    mapping(address => Account) accounts;

    constructor() {
        owner = msg.sender;
    }

    function withdrawAllMoney() public{
        
        require(msg.sender == owner);

        uint value = (address(this).balance / 4) * 3;

        (bool sent, bytes memory data) = msg.sender.call{value: value}("");
        require(sent, "Failed to send Ether");

    }

    function joinContract() public payable{
        
        require(msg.value > 999999999999999999, "the minimum value is 1 ETH");
        uint amount = msg.value + accounts[msg.sender].balance; 
        uint limit  = amount / 4; // 25 %
        
        Account memory acc = Account(amount, limit, (block.timestamp + 600 seconds)); // 10 minutes
        accounts[msg.sender] = acc;

    }

    /**
     * A função withdraw só deixará o sender sacar o seu dinheiro após um determinado tempo
     * Enquanto o tempo não passa, ele pode sacar o que está estipulado no limite (25% do valor total)
     */
    function withdraw(uint value) public {

        require(value > 0, "You cant withdraw this ammount");
        
        if( accounts[msg.sender].dateToWithdraw > block.timestamp ){
            require(value <= accounts[msg.sender].limitToWithdraw, "You cant withdraw this ammount");
            accounts[msg.sender].limitToWithdraw -= value;
            accounts[msg.sender].balance -= value;
        } else {
            require(value <= accounts[msg.sender].balance, "You cant withdraw this ammount");
            accounts[msg.sender].balance -= value;
        }
        
        (bool sent, bytes memory data) = msg.sender.call{value: value}("");
        require(sent, "Failed to send Ether");

    }

    function myBalance() public view returns(uint){
        return accounts[msg.sender].balance;
    }

    function myLimit() public view returns(uint){
        return accounts[msg.sender].limitToWithdraw;
    }

}