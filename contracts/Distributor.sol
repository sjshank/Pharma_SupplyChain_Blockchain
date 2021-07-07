// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";

contract Distributor is User {
    mapping(address => address[]) MedicinePackagesReceivedAtDistributor; // Track list of medicine batches received by each ditributor.
    mapping(address => address[]) MedicinesTransferredToPharma; // Track list of medicine batches transferred to diff Pharma by 1 distributor.
    mapping(address => address) MedicineBatchTxToPharmaContract; // Track each transaction happened between Dist to Pharma w.r.t to Medicine transferred.

    modifier onlyDistributor {
        require(UsersDetails[msg.sender].userRole == roles.distributor, "ODCC"); //"Only Distributor can call this function."
        _;
    }

    event MedicineTransferredDPInitiated(
        address MedicineID,
        address indexed Pharma,
        address indexed Transporter,
        address indexed SubContractID
    );

    //Recieve & update medicine package shippment status for supplied package ID by tagged/associated receiver/distributor. Update MedicinePackagesReceivedAtDistributor mapping
    //@param _medicineID Medicine/Package/batch ID Address
    function updateRecievedMedicinePackageStatus(address _medicineID)
        public
        onlyDistributor
    {
        Medicine(_medicineID).updatePackageStatusOnReceivedByDistributor(
            msg.sender
        );
        MedicinePackagesReceivedAtDistributor[msg.sender].push(_medicineID);
    }

    //Retrieve medicine/package shippment status using packageID. Only Distributor can call this.
    //@param _medicineID Medicine/Batch/Package ID Address
    function getReceivedMedicinePackageAtDistributorStatus(address _medicineID)
        public
        view
        returns (uint256)
    {
        return Medicine(_medicineID).getMedicineStatus();
    }

    //Retrieve number of medicine packages received to particular distributor. Only Distributor can call this.
    function getReceivedMedicinePackagesCount()
        public
        view
        onlyDistributor
        returns (uint256)
    {
        return MedicinePackagesReceivedAtDistributor[msg.sender].length;
    }

    //Retrieve  medicine/package ID using index registered by Manufacturer. Only Distributor can call this.
    //@param _index Uint
    function getReceivedMedicinePackageIDByIndex(uint256 _index)
        public
        view
        onlyDistributor
        returns (address)
    {
        return MedicinePackagesReceivedAtDistributor[msg.sender][_index];
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
        require(
            UsersDetails[_pharma].userRole == roles.pharma,
            "PHARMA_NT_REG"
        ); //Only Registered Pharma is allowed.
        require(
            UsersDetails[_transporter].userRole == roles.transporter,
            "TRANS_NT_REG"
        ); //Only Registered Transporter/Shipper is allowed.
        require(
            Medicine(_medicineID).getMedicineStatus() == 2,
            "Package must be at Distributor"
        );
        MedicineDP medicineDPData = new MedicineDP(
            _medicineID,
            msg.sender,
            _transporter,
            _pharma
        );
        MedicinesTransferredToPharma[msg.sender].push(address(medicineDPData));
        MedicineBatchTxToPharmaContract[_medicineID] = address(medicineDPData);
        emit MedicineTransferredDPInitiated(
            _medicineID,
            _pharma,
            _transporter,
            address(medicineDPData)
        );
    }

    //Retrieve number of medicine packages transferred to diff pharmas by 1 distributor. Only Distributor can call this.
    function getTransferredMedicineCountAtDP()
        public
        view
        onlyDistributor
        returns (uint256)
    {
        return MedicinesTransferredToPharma[msg.sender].length;
    }

    //Retrieve  medicine/package ID using index registered by Manufacturer. Only Distributor can call this.
    //@param _index Uint
    function getTransferredMedicineTxIDByIndex(uint256 _index)
        public
        view
        onlyDistributor
        returns (address)
    {
        return MedicinesTransferredToPharma[msg.sender][_index];
    }

    //Retrieve SubContract ID of Medicine Batch Transfer in between Distributor to Pharma
    //@param _medicineID Medicine BatchID/MedicineID Address
    function getMedicineSubContractDP(address _medicineID)
        public
        view
        onlyDistributor
        returns (address)
    {
        return MedicineBatchTxToPharmaContract[_medicineID];
    }
}
