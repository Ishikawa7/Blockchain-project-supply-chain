//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./Attore.sol";

contract Distributore is Attore {

    string public catena_di_appartenenza;
    event info(string messaggio,address address_, string nome, string indirizzo, string catena_di_appartenenza);   
    
    constructor(string memory _nome, string memory _indirizzo, string memory _catena_appartenenza, address _address) 
    Attore(_nome, _indirizzo, _address) {
        catena_di_appartenenza = _catena_appartenenza;
    }
    
}