// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";

contract Distributor is User {
    mapping(address => address[]) MedicineBatchesTransferredToPharma;

    modifier onlyDistributor {
        require(UsersDetails[msg.sender].userRole == roles.distributor, "ODCC"); //"Only Distributor can call this function."
        _;
    }

    event MedicineTransferredDPInitiated(
        address MedicineID,
        address indexed SubContractID,
        uint256 MedicineStatus
    );

    //Recieve & update medicine package shippment status for supplied package ID by tagged/associated receiver/distributor. Update MedicinePackagesReceivedAtDistributor mapping
    //@param _medicineID Medicine/Package/batch ID Address
    function updateRecievedMedicinePackageStatus(address _medicineID) private {
        Medicine(_medicineID).updatePackageStatusOnReceivedByDistributor();
    }

    //Transfer received Medicine batch(from Manufacturer) to Pharma using tagged/associated shipper/transporter only. Only Distributor can call this.
    //@param _medicineID Medicine Batch/Package ID Address
    //@param _pharma Registered Pharma user Address
    //@param _transporter Registered Shipper/Transporter user Address
    function transferMedicineFromDistributorToPharma(
        address _medicineID,
        address _pharma,
        address _transporter
    ) public onlyDistributor {
        updateRecievedMedicinePackageStatus(_medicineID);
        MedicineDP medicineDPData = new MedicineDP(
            _medicineID,
            msg.sender,
            _transporter,
            _pharma
        );
        // MedicinesTransferredToPharma[msg.sender].push(address(medicineDPData));
        MedicineDP(address(medicineDPData)).pickPackageDP(_medicineID);
        MedicineBatchesTransferredToPharma[_pharma].push(
            address(medicineDPData)
        );
        uint256 _status = Medicine(_medicineID).getMedicineStatus();
        emit MedicineTransferredDPInitiated(
            _medicineID,
            address(medicineDPData),
            _status
        );
    }
}
