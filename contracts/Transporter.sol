// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
// import "./RawMaterials.sol";
// import "./Medicine.sol";
// import "./MedicineDP.sol";

contract Transporter is User {
    modifier onlyTransporter {
        require(
            UsersDetails[msg.sender].userRole == roles.transporter,
            "OTCC." //Only Transporter can call this function
        );
        _;
    }

    // //Load package for transporting package/material/medicine/product from one location to another
    // //@param _packageID Registered materialID/PackageID/BatchID/MedicineID Address
    // //@param _transporterType trnsporter type supporting different transport option Uint
    // //@param _subContractID sub contract ID for consignment tx happened between Dist-Pharma or Wholesaler-Dist
    // function loadConsignment(
    //     address _packageID,
    //     uint256 _transporterType,
    //     address _subContractID
    // ) public onlyTransporter {
    //     require(_transporterType > 0, "Define Transporter type");

    //     //Supports supplier to manufacturer transport
    //     if (_transporterType == 1) {
    //         RawMaterials(_packageID).pickRawMaterialPackage(msg.sender);
    //     } else if (_transporterType == 2) {
    //         //Supports manufacturer to distributor transport
    //         Medicine(_packageID).pickMedicinePackageForDistributor(msg.sender);
    //     } else if (_transporterType == 3) {
    //         //Supports distributor to pharma transport
    //         MedicineDP(_subContractID).pickPackageDP(_packageID, msg.sender);
    //     }
    // }
}
