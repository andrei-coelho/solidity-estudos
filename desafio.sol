// SPDX-License-Identifier: MIT
// Author: Andrei Coelho 
pragma solidity >=0.8.0;

contract Desafio {

    uint public number;
    uint private multiply = 1;
    address public owner;

    event changedValue(address sender, uint value, string type_value);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getMoney() public payable onlyOwner returns(uint){
        require(msg.value > 0);
        uint val = msg.value;
        payable(owner).transfer(val);
        return val;
    }

    function setNumber(uint num) public payable returns(string memory) {

        uint wei_value_tax = 25000000000000000 * multiply;
        require(msg.value >= wei_value_tax);
        emit changedValue(msg.sender, wei_value_tax, "wei");

        multiply = multiply * 2;
        number = num;
        
        if(num > 5){
            return "E maior que cinco!";
        }
        return "E menor ou igual a cinco!";

    }

}

