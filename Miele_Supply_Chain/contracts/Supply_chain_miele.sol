//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./Lotto.sol";
import "./Apicoltore.sol";
import "./Distributore.sol";
import "./Utility.sol";

contract Supply_chain_miele{

    uint progressivo_lotti = 0;
    
    mapping (uint => Lotto) lotti;
    
    mapping (address => Apicoltore) apicoltori;
    
    mapping (address => Distributore) distributori;
    

    function aggiungi_apicoltore(string memory _nome, string memory _indirizzo, string memory _informazioni) public {
        Apicoltore apicoltore = new Apicoltore(_nome, _indirizzo, _informazioni, msg.sender);
        require(!(apicoltori[msg.sender] == apicoltore) ,"Indirizzo gia' registrato come apicoltore");
        apicoltori[msg.sender] = apicoltore;
    }
    
    function aggiungi_distributore(string memory _nome, string memory _indirizzo, string memory _catena_appartenenza) public {
        Distributore distributore = new Distributore(_nome, _indirizzo, _catena_appartenenza, msg.sender);
        require(!(distributori[msg.sender] == distributore) ,"Indirizzo gia' registrato come distributore");
        distributori[msg.sender] = distributore;
    }
    
    function registra_lotto_miele_prodotto(
            string memory _fioritura,
            Utility.Data memory _data_produzione,
            Utility.Indicazioni_geografiche memory _luogo_produzione
        ) public
    {
        Apicoltore a = apicoltori[msg.sender];
        require(address(a) != address(0x0),'Indirizzo non registrato come apicoltore');
        Lotto nuovo_lotto = a.produci_lotto_miele(_fioritura, _data_produzione, _luogo_produzione, progressivo_lotti);
        lotti[progressivo_lotti] = nuovo_lotto;
        progressivo_lotti++;
        
    }
    
    function registra_messa_in_vendita(uint _codice_lotto, uint _prezzo) public {
        Attore a = apicoltori[msg.sender];
        if (address(a) == address(0x0)){
            a = distributori[msg.sender];
        }
        Lotto l = lotti[_codice_lotto];
        require((address(l) !=  address(0x0)), "Lotto non esistente");
        require((address(a) !=  address(0x0)), "Non sei registrato come apicoltore o distributore");
        require(_prezzo >0, "Prezzo non valido");
        lotti[_codice_lotto].metti_in_vendita(_prezzo, a.address_());
    }
    
    function registra_acquisto(uint _codice_lotto) public payable {
        Attore a = apicoltori[msg.sender];
        if (address(a) == address(0x0)){
            a = distributori[msg.sender];
        }
        Lotto l = lotti[_codice_lotto];
        require((address(l) !=  address(0x0)), "Lotto non esistente");
        require((address(a) !=  address(0x0)), "Non sei registrato come apicoltore o distributore");
        require(msg.sender != l.address_proprietario_corrente(), "Non puoi comprare tu stesso");
        require(msg.value >= l.prezzo(), "Fondi non sufficienti");
        uint resto = msg.value - l.prezzo();
        address payable vecchio_proprietario = payable(l.imposta_acquistato(msg.sender));
        if (resto > 0){
            (payable(l.address_proprietario_corrente())).transfer(resto);
        }
        vecchio_proprietario.transfer(msg.value - resto);
    }
    
    function registra_messa_in_vendita_finale(uint _codice_lotto) public{
        Distributore d = distributori[msg.sender];
        Lotto l = lotti[_codice_lotto];
        require((address(l) !=  address(0x0)), "Lotto non esistente");
        require((address(d) !=  address(0x0)), "Non sei registrato come distributore");
        lotti[_codice_lotto].messa_in_vendita_finale(d.address_());
    }
    
// FUNZIONI PER OTTENERE I DATI

    function ottieni_apicoltore(address address_) public view returns(
        string memory nome,
        string memory indirizzo,
        string memory informazioni
    )
    {
        Apicoltore a = apicoltori[address_];
        require(address(a) != address(0x0),"Apicoltore inesistente");
        return (
            a.nome(),
            a.indirizzo(),
            a.informazioni()
            );
    }
    
    function ottieni_distributore(address address_) public view returns(
        string memory nome,
        string memory indirizzo,
        string memory catena_appartenenza
    )
    {
        Distributore d = distributori[address_];
        require(address(d) != address(0x0) ,"Distributore inesistente");
        return (
            d.nome(),
            d.indirizzo(),
            d.catena_di_appartenenza()
            );
    }
    
    function ottieni_lotto(uint _id_lotto) public view returns(
        uint    codice_lotto,                        
        address address_proprietario_corrente,             
        address address_apicoltore_originario,               
        string  memory fioritura,                              
        uint    prezzo,                         
        Lotto.Stato_lotto stato_lotto,
        uint giorno_produzione,
        uint mese_produzione,
        uint anno_produzione,
        string memory citta_di_produzione
    )
    {
        Lotto l = lotti[_id_lotto];
        require(address(l) != address(0x0) ,"Lotto inesistente");
        (uint giorno, uint mese, uint anno) = l.data_produzione();
        (, string memory cit) = l.luogo_produzione();
        return(
            l.codice_lotto(),
            l.address_proprietario_corrente(),
            l.address_proprietario_corrente(),
            l.fioritura(),
            l.prezzo(),
            l.stato_lotto(),
            giorno,
            mese,
            anno,
            cit
        );
    }

}
  
  
  
  
  
  