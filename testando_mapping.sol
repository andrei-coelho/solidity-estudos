// SPDX-License-Identifier: MIT
// Author: Andrei Coelho 
pragma solidity >=0.8.0;

contract Program {

    mapping(address => uint) internal userLevel;

    constructor(){
        userLevel[msg.sender] = 3;
    }

    function cadastroUsuarioComum() public  {
        userLevel[msg.sender] = 1;
    }

    function cadastrandoSubAdministrador(address endereco) public returns(string memory) {
        
        require(userLevel[msg.sender] > 1, "Invalid Permission");
        if(userLevel[endereco] == 1){
            userLevel[endereco] = 2;
            return "Usuario teve seus privilegios aumentados!";
        }
        return "Usuario nao foi cadastrado pois ele ja tem permissao ou ele ainda nao eh um usuario";

    }   


}