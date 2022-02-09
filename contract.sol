// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Test {

    uint number = 1111;
    address public user;

    function setUser() public{
        user = msg.sender;
    }

}