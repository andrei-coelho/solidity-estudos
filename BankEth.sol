// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
 * Simulador de um banco de investimentos em ethereum 
 */
contract BankEth {


    // Carteiras cadastradas no banco
    mapping (address => uint) private Wallets;


    /**
     * Usuário entra com um valor mínimo acima de 1 ETH
     */
    function enterToFund() public payable {
        
        require(msg.value > 1000000000000000000, "A value greater than 1 ETH is required");
        Wallets[msg.sender] = msg.value;

    }

    /**
     * Usuário pode transferir saldos para outros usuários
     * que estão cadastrados no banco
     */
    function transferTo(address to, uint value) public {
        
        uint val = Wallets[msg.sender];
        require(val > 0 && val >= value, "You dont have money");
        require(msg.sender != to, "You cant send money to yourself");

        uint valto = Wallets[to];
        require(valto > 0, "This account dont exists");

        Wallets[msg.sender] = val - value;
        Wallets[to] = valto + value;
    }

    /**
     * Usuário saca um valor desejado compatível com o seu saldo
     * Esse valor é enviado para a sua carteira na rede Ethereum
     */
    function saque(uint value) public {
       
        address payable me = payable(msg.sender);
       
        uint val = Wallets[me];
        require(val > 0 && val >= value, "You dont have money");
        Wallets[me] = val - value;
       
        (bool sent, bytes memory data) = me.call{value: value}("");
        require(sent, "Failed to send Ether");
    }

    /**
     * Mostra o seu saldo atual dentro do fundo
     */
    function meuSaldo() public view returns(uint){
        return Wallets[msg.sender];
    }

    /**
     * Mostra o saldo do fundo
     */
    function saldoFund() public view returns(uint){
        return address(this).balance;
    }


}