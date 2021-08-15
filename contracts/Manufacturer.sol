// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./RawMaterials.sol";
import "./Medicine.sol";

contract Manufacturer is User {
    mapping(address => address[]) MedicinesManufactured;
    mapping(address => address[]) public TaggedInspectorMedicineList;

    event MedicinePackageInitialize(
        address medicineId,
        address materialId,
        uint256 medicineBatchStatus,
        uint256[] transactionBlocks,
        uint256 materialPackageStatus
    );

    event UpdatedMedicineBatchInfo(
        string medicineName,
        string location,
        string description,
        uint256 quantity,
        address transporter,
        address distributor
    );

    event UpdatedPackageStatusOnReceived(
        address materialId,
        uint256 packageStatus
    );

    event UpdatedMedicineBatchStatus(
        address medicineId,
        uint256 packageStatus,
        uint256[] transactionBlocks
    );

    modifier onlyManufacturer {
        require(
            UsersDetails[msg.sender].userRole == roles.manufacturer,
            "OMCC"
        ); //Only Manufacturer can call this function.
        _;
    }

    //Initialize Medicine batch with required details, transporter & distributor. Emit event with new package details.
    //@param _materialID Raw Material information Address
    //@param _desc Medicine description String
    //@param _medicineName Medicine name String
    //@param _quantity Medicine Quantity Uint
    //@param _transporter Transporter/Shipper Address
    //@param _distributor Reciever/Distributor Address
    function createMedicinePackage(
        address _materialId,
        string memory _medicineName,
        string memory _description,
        string memory _location,
        uint256 _quantity,
        address _transporter,
        address _distributor,
        address _inspector
    ) public onlyManufacturer {
        Medicine medicineData = new Medicine(
            msg.sender,
            _materialId,
            _medicineName,
            _description,
            _location,
            _quantity,
            _transporter,
            _distributor,
            _inspector
        );
        //Push medicine address to list registered by manudacturer
        MedicinesManufactured[msg.sender].push(address(medicineData));
        //Emit event after medicine registration
        emit MedicinePackageInitialize(
            address(medicineData),
            _materialId,
            Medicine(address(medicineData)).getMedicineStatus(),
            Medicine(address(medicineData)).getTransactionBlocks(),
            RawMaterials(_materialId).getRawMaterialsStatus()
        );
    }

    function updateMedicineBatch(
        address _medicineId,
        string memory _medicineName,
        string memory _location,
        string memory _desc,
        uint256 _quantity,
        address _transporter,
        address _distributor
    ) public onlyManufacturer {
        bool result = Medicine(_medicineId).updateMedicineBatchDetails(
            _medicineName,
            _desc,
            _location,
            _quantity,
            _transporter,
            _distributor
        );
        if (result) {
            emit UpdatedMedicineBatchInfo(
                _medicineName,
                _desc,
                _location,
                _quantity,
                _transporter,
                _distributor
            );
        }
    }

    //Reject received material package if damaaged
    function rejectMaterialPackage(address _materialId)
        public
        onlyManufacturer
    {
        bool result = RawMaterials(_materialId).rejectPackageAtReceiver();
        if (result) {
            emit UpdatedPackageStatusOnReceived(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
        }
    }

    //Approve received material package
    function approveMaterialPackage(address _materialId)
        public
        onlyManufacturer
    {
        bool result = RawMaterials(_materialId).approvePackageAtReceiver();
        if (result) {
            emit UpdatedPackageStatusOnReceived(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
        }
    }

    //Send registered medicine batch for inspection
    function sendMedicineBatchForInspection(
        address _medicineId,
        address _inspector
    ) public onlyManufacturer {
        bool result = Medicine(_medicineId).sendMedicineForInspection();
        if (result) {
            TaggedInspectorMedicineList[_inspector].push(_medicineId);
            emit UpdatedMedicineBatchStatus(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }
}
