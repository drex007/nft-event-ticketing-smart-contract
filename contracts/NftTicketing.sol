// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3 <0.9.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NftTicketing is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;


    constructor(uint _eventFee)
        ERC721("DigiPass", "DIP")
        Ownable(msg.sender)
    {
        eventFee = _eventFee;
    }
    //Variables

    bool public eventFundWithdrawalStatus = false;

    uint256 public eventFee;

    Counters.Counter public totalEventsCount;

    //events

    event CreateEventLog (address indexed  _eventOwner,uint _eventId, uint _dateCreated, uint _fee);
    event TicketPurchaseLog (address indexed  _buyer, uint _fee, uint _eventId);
    event EventWithdrawalLog (address indexed  _eventOwner, uint _dateCreated, uint _amount);



    //Structs

    struct EventStruct{
        uint eventId;
        uint eventPrice;
        string eventDescription;
        uint ticketCloseDate;
        string eventTitle;
        address eventOwner;
        uint dateOfEvent;
        uint ticketQuantity;
        uint ticketsMinted;
        string eventImageUrl;
        string ipfsUrl; 
        uint amountSold; 
        address[] buyers;
           }

    struct EventCreationStruct {
        uint eventPrice;
        uint ticketCloseDate;
        bool eventTitle;
        uint dateOfEvent;
        uint ticketQuantity;
        string eventImageUrl;
        string ipfsUrl; 
    }
    

    mapping (uint256 => EventStruct)  public eventList;
    

    function getContractBalance() public  view returns(uint){
        return address(this).balance;
    }



    function safeMint(uint eventId)
        public payable 
        
    {
        uint addressCount = 0;

        EventStruct storage currentEvent = eventList[eventId];
        require(currentEvent.eventPrice >= msg.value, "Amount must equal ticket price");
        require(currentEvent.ticketsMinted < currentEvent.ticketQuantity, "Ticket max reached");

         for (uint i = 0; i < currentEvent.buyers.length; i++) {
            if (currentEvent.buyers[i] == msg.sender) {
                addressCount++;
            }
        }
        require(addressCount < 2, "You have reached your max ticket purchase for this event");
        
        _safeMint(msg.sender, currentEvent.ticketsMinted);
        _setTokenURI(currentEvent.ticketsMinted, currentEvent.ipfsUrl);
        currentEvent.ticketsMinted = currentEvent.ticketsMinted + 1;
        currentEvent.amountSold = currentEvent.amountSold + msg.value;
        currentEvent.buyers.push(msg.sender);
        emit TicketPurchaseLog(msg.sender, currentEvent.eventPrice, eventId);
    }
    
    function confirmAddressInEvent (uint eventId, address addressToConfirm ) public  view returns(uint8) {
        uint8 addressFoundCount = 0 ;
         EventStruct storage currentEvent = eventList[eventId];

          for (uint i = 0; i < currentEvent.buyers.length; i++) {
            if (currentEvent.buyers[i] == addressToConfirm) {
                addressFoundCount++;
            }
          }
          return  addressFoundCount;

    }

  function createEvent(
        uint dateOfEvent,
        uint ticketCloseDate,
        string memory eventTitle,
        uint eventPrice,
        uint ticketQuantity,
        string memory eventImageUrl,
         string memory eventDescription,
        string memory ipfsUrl
        
        

    
    ) public payable {
        require(msg.value >= eventFee, "Insufficient fund");
        require(bytes(eventImageUrl).length > 0, "Event url cannot be empty");
        require(bytes(ipfsUrl).length > 0, "ipfs url cannot be empty");


        EventStruct memory eventVariable;
        
        eventVariable.eventId = totalEventsCount.current();
        eventVariable.eventOwner = msg.sender;
        eventVariable.dateOfEvent = dateOfEvent;
        eventVariable.ticketCloseDate = ticketCloseDate;
        eventVariable.eventDescription = eventDescription;
        eventVariable.eventTitle = eventTitle;
        eventVariable.eventPrice = eventPrice;
        eventVariable.ticketQuantity = ticketQuantity;
        eventVariable.ticketsMinted = 0;
        eventVariable.eventImageUrl = eventImageUrl;
        eventVariable.ipfsUrl = ipfsUrl;
        eventVariable.amountSold = 0;
        
        eventList[totalEventsCount.current()] = eventVariable;
        emit CreateEventLog(msg.sender,totalEventsCount.current(),block.timestamp, eventFee);
        totalEventsCount.increment();
        
    


    }




    function allowEventOwnersWithdraw(uint eventId) public payable returns(bool) {
        require(eventFundWithdrawalStatus == true, "Withdrawal is closed at the moment");
        EventStruct storage currentEvent =  eventList[eventId];
        uint amountToWithdraw = (90 * currentEvent.amountSold) / 100 ;
        require(currentEvent.eventOwner == msg.sender, "You don't own this event");
        require(currentEvent.amountSold >= eventFee, "Withdrawal amount be be greater or equal to eventFee");
        (bool success,) = payable(msg.sender).call{value: amountToWithdraw}("");

        if(success == true){
            currentEvent.amountSold = 0;
            emit EventWithdrawalLog(msg.sender, block.timestamp,  amountToWithdraw);
        }
        return success;


    }

    function toggleEventWithdrawalStatus() public  onlyOwner {
        eventFundWithdrawalStatus = !eventFundWithdrawalStatus;
        
    }

    function updateEventFee (uint256 fee) public payable  onlyOwner {
        eventFee =  fee;

    }

    function getAllEvents() public view returns (EventStruct[] memory) {
        EventStruct[] memory allEvents = new EventStruct[](totalEventsCount.current());
        for (uint256 i = 0; i < totalEventsCount.current(); i++) {
            allEvents[i] = eventList[i];
        }
        
        return allEvents;
    }

    function withdrawAllFromContract ()  public payable onlyOwner returns(bool){
        uint balance = address(this).balance;
         (bool success,) = payable(msg.sender).call{value: balance}("");
         return  success;

    }




}