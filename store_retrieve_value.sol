// SPDX-License-Identifier: GPL-3.0
// First project (contract called store) is a DApp for storing and retrieving data from the blockchain 

pragma solidity >=0.7.0 <0.9.0;

contract store {
    string public myCust;

    function setCustName(string memory CustName) public {
        myCust = CustName;

    }
    function getCustName() public view returns(string memory){
        return myCust;
    }
}