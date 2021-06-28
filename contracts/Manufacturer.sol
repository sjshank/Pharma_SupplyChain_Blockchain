// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./RawMaterials.sol";
import "./Medicine.sol";

contract Manufacturer is User {
    mapping(address => address[]) RawMaterialPackagesReceivedAtManufacturer;
    mapping(address => address[]) MedicinesManufactured;

    //Event
    event MedicinePackageInitialize(
        address indexed MedicineID,
        address indexed Manufacturer,
        address Distributor,
        address indexed Transporter
    );

    modifier onlyManufacturer {
        require(
            UsersDetails[msg.sender].userRole == roles.manufacturer,
            "OMCC"
        ); //Only Manufacturer can call this function.
        _;
    }

    //Recieve & update raw material package shippment status for supplied package ID by tagged/associated receiver/manufacturer. Update RawMaterialPackagesReceivedAtManufacturer mapping
    //@param _packageID Material/Package/batch ID Address
    function updateRecievedRawMaterialPackageStatus(address _packageID)
        public
        onlyManufacturer
    {
        RawMaterials(_packageID).UpdatePackageStatusOnReceived(msg.sender);
        RawMaterialPackagesReceivedAtManufacturer[msg.sender].push(_packageID);
    }

    //Retrieve material/package shippment status using packageID. Only Manufacturer can call this.
    //@param _packageID Address
    function getReceivedRawMaterialPackageAtManufacturerStatus(
        address _packageID
    ) public view returns (uint256) {
        return RawMaterials(_packageID).getRawMaterialsStatus();
    }

    //Retrieve number of raw material packages received to particular manufacturer. Only Manufacturer can call this.
    function getReceivedRawMaterialPackagesCount()
        public
        view
        onlyManufacturer
        returns (uint256)
    {
        return RawMaterialPackagesReceivedAtManufacturer[msg.sender].length;
    }

    //Retrieve raw material/package ID using index registered by Manufacturer. Only Manufacturer can call this.
    //@param _index Uint
    function getReceivedRawMaterialPackageIDByIndex(uint256 _index)
        public
        view
        onlyManufacturer
        returns (address)
    {
        return RawMaterialPackagesReceivedAtManufacturer[msg.sender][_index];
    }

    //Initialize Medicine batch with required details, transporter & distributor. Emit event with new package details.
    //@param _materialID Raw Material information Address
    //@param _desc Medicine description String
    //@param _medicineName Medicine name String
    //@param _quantity Medicine Quantity Uint
    //@param _transporter Transporter/Shipper Address
    //@param _distributor Reciever/Distributor Address
    function createMedicinePackage(
        address _materialID,
        string memory _medicineName,
        string memory _desc,
        uint256 _quantity,
        address _transporter,
        address _distributor
    ) public onlyManufacturer {
       require(
            UsersDetails[_transporter].userRole == roles.transporter,
            "TRANS_NT_REG"
        ); //Only Registered Transporter/Shipper is allowed.
        Medicine medicineData = new Medicine(
            msg.sender,
            _materialID,
            _desc,
            _medicineName,
            _quantity,
            _transporter,
            _distributor
        );
        //populate medicine ID
        address _medicineID = medicineData.medicineId();
        //Push medicine address to list registered by manudacturer
        MedicinesManufactured[msg.sender].push(address(medicineData));
        //Emit event after medicine registration
        emit MedicinePackageInitialize(
            _medicineID,
            msg.sender,
            _distributor,
            _transporter
        );
    }

    //Retrieve number of medicine packages registered by manufacturer. Only manufacturer can call this.
    function getRegisteredMedicinePackagesCount()
        public
        view
        onlyManufacturer
        returns (uint256)
    {
        return MedicinesManufactured[msg.sender].length;
    }

    //Retrieve medicine ID using index registered by manufacturer. Only manufacturer can call this.
    //@param index Uint
    function getRegisteredMedicineIDByIndex(uint256 index)
        public
        view
        onlyManufacturer
        returns (address)
    {
        return MedicinesManufactured[msg.sender][index];
    }

    //Retrieve medicine package status using package/medicine ID. Only manufacturer can call this.
    //@param _packageID Address
    function getRegisteredMedicinePackageStatusByID(address _medicineID)
        public
        view
        onlyManufacturer
        returns (uint256)
    {
        return Medicine(_medicineID).getMedicineStatus();
    }
}
