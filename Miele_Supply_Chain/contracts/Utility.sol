//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

library Utility  {
    
    struct Data {
        uint giorno;
        uint mese;
        uint anno;
    }
    
    struct Indicazioni_geografiche{
        string nazione;
        string citta;
    }
    
    // definizione funzione kill per distruggere il contratto
    function kill(address _proprietario) public {
        if (msg.sender == _proprietario) {
          address payable _address_proprietario_payable = _make_payable(_proprietario);
          selfdestruct(_address_proprietario_payable);
        }
    }
    
    // converte un indirizzo in un indirizzo payable
    function _make_payable(address x) internal pure returns (address payable) {
        return payable(x);
    }
    
}