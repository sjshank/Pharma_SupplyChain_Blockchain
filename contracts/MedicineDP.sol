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
        transferInitiated,
        pickedByTransporter,
        deliveredAtPharma,
        rejectedByPharma,
        approvedByPharma
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
    //transaction time
    uint256[] transactionBlocksDP;

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

    //Get medicineDP contract details along with medicine basic details
    function getMedicineDPSubContractDetails()
        public
        view
        returns (
            address _subContractId,
            address _medicineId,
            Medicine.MedicineInfo memory medicineInfo,
            Medicine.Entity memory medicineEntity,
            address _pharma,
            uint256 _packageStatus,
            uint256[] memory _transactionBlocksDP
        )
    {
        return (
            address(this),
            medicineID,
            Medicine(medicineID).getMedicineInfo(),
            Medicine(medicineID).getMedicineEntity(),
            pharma,
            uint256(packageStatus),
            transactionBlocksDP
        );
    }

    //Get the Medicine Id
    function getMedicineID() public view returns (address) {
        return medicineID;
    }

    //Get the Medicine sub batch package status.
    function getMedicineSubBatchStatus() public view returns (uint256) {
        return uint256(packageStatus);
    }

    //Get the Medicine sub batch transactions
    function getTransactionBlocksDP() public view returns (uint256[] memory) {
        return transactionBlocksDP;
    }

    //Pick medicine package/batch for transferring Dist to Pharma by Shipper/Transporter. Only Shipper/Transporter can call this.
    //@param _medicineID Medicine Batch/Package ID Address
    //@param _shipper Registered Shipper/Transporter user Address
    function pickPackageDP(address _medicineID) public {
        require(packageStatus == status(0), "M_MST_AT_D");
        packageStatus = status(1);
        Medicine(_medicineID).pickMedicinePackageForPharma(pharma);
    }

    //Receive & Update medicine package/batch for tranfering Dist to Pharma by Shipper/Transporter. Only Pharma can call this.
    //@param _medicineID Medicine Batch/Package ID Address
    //@param _receiver Registered Pharma user Address
    function receivedPackageDP(address _medicineID) public {
        require(packageStatus == status(1), "M_MST_AT_P.");
        packageStatus = status(2);
        Medicine(_medicineID).updatePackageStatusOnReceivedByPharma();
    }

    //initiate medicine sub batch transfer to pharma
    function initiateMedicineSubBatchTransfer() public returns (bool) {
        packageStatus = status(0);
        transactionBlocksDP.push(block.number);
        return true;
    }

    //Pick  medicine sub batch for shipment by shipper for Dist-Pharma
    function initiateMedicineSubBatchForShipment() public returns (bool) {
        return updateMedicineBatchStatus(1, 0);
    }

    //Deliver & update medicine batch by shipper for Dist-Pharma
    function deliverMedicineSubBatchToReceiver() public returns (bool) {
        return updateMedicineBatchStatus(2, 1);
    }

    //Delivered medicine batch rejected by Pharma
    function rejectMedicineSubBatchAtReceiver() public returns (bool) {
        return updateMedicineBatchStatus(3, 2);
    }

    //Delivered medicine batch approved by Pharma
    function approveMedicineSubBatchAtReceiver() public returns (bool) {
        return updateMedicineBatchStatus(4, 2);
    }

    function updateMedicineBatchStatus(
        uint256 _updatedStatus,
        uint256 _prevStatus
    ) private returns (bool) {
        if (packageStatus == status(_prevStatus)) {
            transactionBlocksDP.push(block.number);
            packageStatus = status(_updatedStatus);
            return true;
        } else {
            revert("IN_PROCESS");
        }
    }
}
