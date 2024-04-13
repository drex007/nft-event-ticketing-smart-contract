// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3 <0.9.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NftTicketing is  ERC721URIStorage, Ownable{

    using Counters for Counters.Counter;
   


    constructor(uint _eventFee)
        ERC721("MyToken", "MTK")
        Ownable()
    {
        eventFee = _eventFee;
    }
    //Variables

    bool public eventFundWithdrawalStatus = false;

    uint256 public eventFee;

   

    Counters.Counter public totalEventsCount;

    //events

    event CreateEventNotification (address indexed  _eventOwner,uint _eventId, uint _dateCreated, uint _fee);
    event TicketPurchaseNotification (address indexed  _buyer, uint _fee, uint _eventId);
    event EventWithdrawalNotification (address indexed  _eventOwner, uint _dateCreated, uint _amount);

    //Structs
    struct EventStruct{
        uint eventId;
        uint eventPrice;
        uint ticketOpenDate;
        uint ticketCloseDate;
        bool isOpen;
        address eventOwner;
        uint dateOfEvent;
        uint ticketQuantity;
        uint ticketsMinted;
        string eventImageUrl;
        string ipfsUrl; 
        uint amountSold; 
        address[] buyers;
           }
    

    mapping (uint256 => EventStruct)  public eventList;
    

    function getContractBalance() public  view returns(uint){
        return address(this).balance;
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


    function toggleEventWithdrawalStatus() public  onlyOwner {
        eventFundWithdrawalStatus = !eventFundWithdrawalStatus;
        
    }

    function updateEventFee (uint256 fee) public  onlyOwner {
        eventFee =  fee;

    }

    function getAllEvents() public view returns (EventStruct[] memory) {
        EventStruct[] memory allEvents = new EventStruct[](totalEventsCount.current());
        for (uint256 i = 0; i < totalEventsCount.current(); i++) {
            allEvents[i] = eventList[i];
        }
        
        return allEvents;
    }

}


