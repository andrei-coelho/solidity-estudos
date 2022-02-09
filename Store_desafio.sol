// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

contract Store {

    address owner;
    uint lastid = 0;

    struct Prod {
        string  name;
        uint256 price;
        uint16  quant;
    }

    mapping(uint => Prod) products;
    address[] addresses;

    // Events
    event itemAddedEvent(uint _id, string _name, uint256 _price);
    event itemRemovedEvent(uint _id, string _name, uint256 _price);
    event itemBoughtEvent(uint _id, string _name, uint256 _price, address _buyer);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    // Endpoints
    function addItem(string memory _name, uint256 _price) public onlyOwner {
        require(_price > 0, "O preco nao pode ser negativo");
        lastid += 1;
        Prod memory prod = Prod(_name, _price, 1);
        products[lastid] = prod;
        emit itemAddedEvent(lastid, _name, _price);
    }
    
    function removeItem(uint _id) public onlyOwner {
        require(products[_id].quant > 0, "Este item nao esta mais em estoque");
        products[_id].quant = 0;
        Prod memory prod = products[_id];
        emit itemRemovedEvent(_id, prod.name, prod.price);
    }
    
    function buyItem(uint _id) payable public {
       
        require(_id <= lastid, "Este item nao existe");
        Prod storage prod = products[_id];
        require(prod.quant > 0, "Este item nao esta disponivel");
        require(prod.price == msg.value, "O valor do produto nao corresponde ao valor enviado");
       
        (bool sent, bytes memory data) = owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
       
        prod.quant = 0;
        addresses.push(msg.sender);
        emit itemBoughtEvent(_id, prod.name, prod.price, msg.sender);

    }
    
    function getItem(uint _id) public view returns(uint id, string memory name, uint256 price){
        Prod memory prod = products[_id];
        return (_id, prod.name, prod.price);
    }

}