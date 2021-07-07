// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Owner {
    //Owner address
    address public owner;

    //Initiate contract
    constructor() {
        owner = msg.sender;
    }

    //Validate owner/owner using modifier
    modifier onlyOwner {
        require(msg.sender == owner, "OWCC"); //Only owner can call this.
        _;
    }
}
