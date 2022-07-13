//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./Apicoltore.sol";
import "./Utility.sol";

contract Lotto {
    
    enum Stato_lotto{
        
        Prodotto_da_apicoltore,     // 0
        In_vendita,                 // 1
        Comprato,                   // 2
        fuori_supply_chain          // 3
    }
    
    struct Trasferimento {
        address da;
        address a;
        Utility.Data data;
    }

    uint public codice_lotto;                                  // codice lotto
    address public address_proprietario_corrente;              // Address del proprietario corrente
    Apicoltore public apicoltore_originario;                   // apicoltore che lo ha prodotto
    string public fioritura;                                   // tipo fioritura
    Utility.Data public data_produzione;                       // data produzione
    uint public prezzo;                                        // prezzo
    Stato_lotto public stato_lotto;                            // Stato corrente del lotto
    Utility.Indicazioni_geografiche public luogo_produzione;   // Indicazioni_geografiche
    
    Stato_lotto public stato;
    
    mapping (uint => Trasferimento) storia_lotto;
    
    //definizione eventi
    event Comprato(string messaggio, uint codice_lotto);      
    event In_vendita_per_consumatore_finale(string messaggio, uint codice_lotto); 
    event Prodotto_da_apicoltore(string messaggio, uint codice_lotto);
    event In_vendita(string messaggio, uint codice_lotto);
    
    constructor(
        Apicoltore _apicoltore_originario,
        string memory _fioritura,
        Utility.Data memory _data_produzione,
        Utility.Indicazioni_geografiche memory _luogo_produzione,
        uint _codice_lotto
        )
        {
        
            address_proprietario_corrente = _apicoltore_originario.address_();
            codice_lotto = _codice_lotto;
            apicoltore_originario = _apicoltore_originario;
            fioritura = _fioritura;
            data_produzione = _data_produzione;
            prezzo = 0;
            luogo_produzione = _luogo_produzione;
            
            stato = Stato_lotto.Prodotto_da_apicoltore;
            
            Trasferimento memory t;
            t.da = address(0x0);
            t.a = address(0x0);
            t.data = _data_produzione;
            storia_lotto[0] = t;
            
            // Emesso evento relativo al cambio di stato
            emit Prodotto_da_apicoltore("Prodotto lotto ",codice_lotto);
        }
        
    function metti_in_vendita(uint _prezzo, address address_proprietario) public{
        require((stato_lotto != Stato_lotto.In_vendita) && (stato_lotto != Stato_lotto.fuori_supply_chain) , "Lotto gia' in vendita");
        require(address_proprietario == address_proprietario_corrente, "Non sei il proprietario del lotto");
        stato_lotto = Stato_lotto.In_vendita;
        prezzo = _prezzo;
        emit In_vendita("Lotto messo in vendita", codice_lotto);
    }
    
    function imposta_acquistato(address _address_nuovo_proprietario) public returns (address vecchio_proprietario){
        require(stato_lotto == Stato_lotto.In_vendita, "Lotto non in vendita");
        stato_lotto = Stato_lotto.Comprato;
        prezzo = 0;
        vecchio_proprietario = address_proprietario_corrente;
        address_proprietario_corrente = _address_nuovo_proprietario;
        emit Comprato("Lotto comprato",codice_lotto);
        return vecchio_proprietario;
    }
    
    function messa_in_vendita_finale(address address_proprietario) public{
        require(address_proprietario == address_proprietario_corrente, "Non sei il proprietario del lotto");
        require(stato_lotto != Stato_lotto.fuori_supply_chain, "Lotto gia' fuori supply chain");
        stato_lotto = Stato_lotto.fuori_supply_chain;
        prezzo = 0;
        emit In_vendita_per_consumatore_finale("Lotto in vendita per consumatore finare (fuori supply chain)",codice_lotto);
    }

    
}