//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./Lotto.sol";
import "./Attore.sol";
import "./Utility.sol";

// contratto base della supply chain, contiene tutte le strutture dati con cui verranno mantenute le informazioni
contract Apicoltore is Attore{

    string public informazioni;
    //si possono aggiungere tutte le informazioni necessarie
    
    
    constructor(string memory _nome, string memory _indirizzo, string memory _informazioni, address _address) 
    Attore(_nome, _indirizzo, _address) {
        informazioni = _informazioni;
    }
    
    
    function produci_lotto_miele(
        string memory _fioritura,
        Utility.Data memory _data_produzione,
        Utility.Indicazioni_geografiche memory _luogo_produzione,
        uint _codice_lotto
    ) 
        public
        returns (Lotto lotto_prodotto)
    {
        return Lotto(new Lotto(this, _fioritura, _data_produzione, _luogo_produzione, _codice_lotto));
    }
    

}