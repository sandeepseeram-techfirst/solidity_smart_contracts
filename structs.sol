/* we can create a Solidity mapping that maps, or defines a relationship with, a unique eventID to the struct we just defined 
that is associated with that event. */

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract Web3RSVP {
   struct CreateEvent {
       bytes32 eventId;
       string eventDataCID;
       address eventOwner;
       uint256 eventTimestamp;
       uint256 deposit;
       uint256 maxCapacity;
       address[] confirmedRSVPs;
       address[] claimedRSVPs;
       bool paidOut;
   }

    mapping(bytes32 => CreateEvent) public idToEvent;

}