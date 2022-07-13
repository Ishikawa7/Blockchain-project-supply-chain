//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

abstract contract Attore  {
    
    address public address_;
    string public nome;
    string public indirizzo;
    
    constructor(string memory _nome, string memory _indirizzo, address _address) {
        
        address_= _address;
        nome = _nome;
        indirizzo = _indirizzo;
    }
    
}