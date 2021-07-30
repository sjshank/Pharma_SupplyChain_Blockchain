// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Medicine.sol";

/**************************************************
 * TransporterType
 * 1 - Supplier to Manufacturer
 * 2 - Manufacturer to Distributor
 * 3 - Distributor to Pharma
 **************************************************/

contract MedicineDP {
    address owner;

    enum status {
        atCreator,
        picked,
        delivered
    }

    //Medicine id
    address public medicineID;
    //Medicine shipper/transporter
    address shipper;
    //Medicine distributor/sender
    address distributor;
    //Medicine at Pharmaceutical/reciever
    address pharma;
    //medicine package status
    status public packageStatus;

    //Initiate new Medicine package by manufacturer with necessary details.
    constructor(
        address _medicineID,
        address _distributor, //sender
        address _shipper,
        address _pharma // receiver
    ) {
        owner = _distributor;
        medicineID = _medicineID;
        distributor = _distributor;
        pharma = _pharma;
        shipper = _shipper;
        packageStatus = status(0);
    }

    function getMedicineDPSubContractDetails()
        public
        view
        returns (
            address _medicineID,
            address _shipper,
            address _distributor,
            uint256 _packageStatus
        )
    {
        return (medicineID, shipper, distributor, uint256(packageStatus));
    }

    //Pick medicine package/batch for transferring Dist to Pharma by Shipper/Transporter. Only Shipper/Transporter can call this.
    //@param _medicineID Medicine Batch/Package ID Address
    //@param _shipper Registered Shipper/Transporter user Address
    function pickPackageDP(address _medicineID) public {
        require(
            packageStatus == status(0),
            "M_MST_AT_D"
        );
        packageStatus = status(1);
        Medicine(_medicineID).pickMedicinePackageForPharma(pharma);
    }

    //Receive & Update medicine package/batch for tranfering Dist to Pharma by Shipper/Transporter. Only Pharma can call this.
    //@param _medicineID Medicine Batch/Package ID Address
    //@param _receiver Registered Pharma user Address
    function receivedPackageDP(address _medicineID) public {
        require(
            packageStatus == status(1),
            "M_MST_AT_P."
        );
        packageStatus = status(2);
        Medicine(_medicineID).updatePackageStatusOnReceivedByPharma();
    }
}
