// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./RawMaterials.sol";
import "./Medicine.sol";

contract Manufacturer is User {
    mapping(address => address[]) MedicinesManufactured;
    mapping(address => address[]) MedicineBatchShipmentList;
    address[] public TotalMedicineBatchesShipped;

    event MedicinePackageInitialize(address indexed MedicineID);

    modifier onlyManufacturer {
        require(
            UsersDetails[msg.sender].userRole == roles.manufacturer,
            "OMCC"
        ); //Only Manufacturer can call this function.
        _;
    }

    //Recieve & update raw material package shippment status for supplied package ID by tagged/associated receiver/manufacturer. Update RawMaterialPackagesReceivedAtManufacturer mapping
    //@param _packageID Material/Package/batch ID Address
    function updateRecievedRawMaterialPackageStatus(address _materialId)
        private
    {
        RawMaterials(_materialId).UpdatePackageStatusOnReceived();
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
        string memory _location,
        string memory _desc,
        uint256 _quantity,
        address _transporter,
        address _distributor
    ) public onlyManufacturer {
        updateRecievedRawMaterialPackageStatus(_materialId);
        Medicine medicineData = new Medicine(
            msg.sender,
            _materialId,
            _desc,
            _medicineName,
            _location,
            _quantity,
            _transporter,
            _distributor
        );
        //populate medicine ID
        address _medicineID = medicineData.medicineId();
        //Push medicine address to list registered by manudacturer
        MedicinesManufactured[msg.sender].push(address(medicineData));
        //Emit event after medicine registration
        emit MedicinePackageInitialize(_medicineID);
    }

    function updateMedicineBatch(
        address _medicineID,
        string memory _medicineName,
        string memory _location,
        string memory _desc,
        uint256 _quantity,
        address _transporter,
        address _distributor
    ) public onlyManufacturer {
        Medicine(_medicineID).updateMedicineBatchDetails(
            _medicineName,
            _desc,
            _location,
            _quantity,
            _transporter,
            _distributor
        );
    }

    //Load & ship medicine batch from manufacturer to ditributor. Only manufacturer call this.
    function loadAndShipMedicineBatch(address _medicineID, address _distributor)
        public
        onlyManufacturer
    {
        Medicine(_medicineID).pickMedicinePackageForDistributor();
        if (Medicine(_medicineID).getMedicineStatus() == 1) {
            MedicineBatchShipmentList[_distributor].push(_medicineID);
        }
    }

    function getTotalMedicineBatchesShippedCount(address _distributor)
        public
        view
        returns (uint256)
    {
        return MedicineBatchShipmentList[_distributor].length;
    }
}
