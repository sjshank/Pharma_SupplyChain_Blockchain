// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Admin {
    //Admin address
    address public admin;

    //Initiate contract
    constructor() {
        admin = msg.sender;
    }

    //Validate owner/admin using modifier
    modifier onlyAdmin {
        require(msg.sender == admin, "OACC"); //Only Admin can call this.
        _;
    }
}
