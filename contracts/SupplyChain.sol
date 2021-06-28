// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Supplier.sol";
import "./Transporter.sol";
import "./Manufacturer.sol";
import "./Distributor.sol";
import "./Pharma.sol";

contract SupplyChain is
    Supplier,
    Transporter,
    Manufacturer,
    Distributor,
    Pharma
{
    constructor() {}
}
