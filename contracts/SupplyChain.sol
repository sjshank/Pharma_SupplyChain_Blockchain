// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Supplier.sol";
import "./Manufacturer.sol";
import "./Distributor.sol";
import "./Pharma.sol";
import "./Inspector.sol";
import "./Transporter.sol";
import "./User.sol";
import "./RawMaterials.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";

contract SupplyChain is
    Supplier,
    Manufacturer,
    Distributor,
    Pharma,
    Inspector,
    Transporter
{
    constructor() {}

    /*************** USER SECTION ***************************** */

    // Validate user based on address & username
    // @param _address User Address
    // @param _userName User Name
    function validateUser(address _address, string memory _userName)
        public
        view
        returns (UserInfo memory)
    {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        require(
            keccak256(bytes(UsersDetails[_address].userName)) ==
                keccak256(bytes(_userName)),
            "USR_NT_REG"
        ); //User not registered
        require(
            keccak256(bytes(UsersDetails[_address].userStatus)) ==
                keccak256(bytes("Active")),
            "USR_NT_ACTIVE"
        ); //User not active
        return getUserInfo(_address);
    }

    // Retrieve User information based on address
    // @param _address User Address
    function getUserInfo(address _address)
        public
        view
        returns (UserInfo memory)
    {
        return UsersDetails[_address];
    }

    //Function to retrieve all the registered users
    //Visibility - Public
    //Return type - list of user
    function getAllRegisteredUsers() public view returns (UserInfo[] memory) {
        return UserList;
    }

    /*************** USER SECTION ***************************** */

    /*************** SUPPLIER SECTION ***************************** */

    //Retrieve material/package status using packageID. Only supplier can call this.
    //@param _packageID Address
    function getSupplierRegisteredRawMaterialPackageStatus(address _packageID)
        public
        view
        returns (uint256)
    {
        return RawMaterials(_packageID).getRawMaterialsStatus();
    }

    //Retrieve list of registered raw material addresses for supplier address. Only supplier can call this.
    //@param _address Address
    function getListOfRegisteredRawMateriaAddress(address _supplier)
        public
        view
        returns (address[] memory)
    {
        return SupplierRegisteredRawMaterialList[_supplier];
    }

    //get list of material tagged to associated inspector
    function getTaggedInspectorMaterialList(address _inspector)
        public
        view
        returns (address[] memory)
    {
        return TaggedInspectorMaterialList[_inspector];
    }

    //get list of material tagged to associated shipper
    function getTaggedTransporterMaterialList(address _transporter)
        public
        view
        returns (address[] memory)
    {
        return TaggedTransporterMaterialList[_transporter];
    }

    //get list of material tagged to associated manufacturer
    function getTaggedManufacturerMaterialList(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return ManufacturerTaggedMaterialList[_manufacturer];
    }

    //get list of medicine tagged to associated inspector
    function getTaggedInspectorMedicineList(address _inspector)
        public
        view
        returns (address[] memory)
    {
        return TaggedInspectorMedicineList[_inspector];
    }

    //get list of medicine tagged to associated shipper
    function getTaggedTransporterMedicineList(address _transporter)
        public
        view
        returns (address[] memory)
    {
        return TaggedTransporterMedicineList[_transporter];
    }

    //get list of medicine tagged to associated distributor
    function getDistributorTaggedMedicineList(address _distributor)
        public
        view
        returns (address[] memory)
    {
        return DistributorTaggedMedicineList[_distributor];
    }

    //get list of medicine sub batch tagged to associated transporter
    function getTransporterTaggedMedicineSubBatchList(address _transporter)
        public
        view
        returns (address[] memory)
    {
        return TaggedTransporterMedicineSubBatchList[_transporter];
    }

    //get list of medicine sub batch tagged to associated pharma
    function getPharmaTaggedMedicineSubBatchList(address _pharma)
        public
        view
        returns (address[] memory)
    {
        return PharmaTaggedMedicineSubBatchList[_pharma];
    }

    //Retrieve registered raw material details for material id. Only supplier can call this.
    //@param _materialID Address
    function getRegisteredRawMaterialDetails(address _materialId)
        public
        view
        returns (
            address materialId,
            address supplier,
            string memory description,
            string memory producerName,
            string memory location,
            uint256 quantity,
            address shipper,
            address manufacturer,
            uint256 packageStatus,
            uint256[] memory transactionBlocks,
            address inspector
        )
    {
        return RawMaterials(_materialId).getSuppliedRawMaterialDetails();
    }

    //Get all the shipped raw material list for manufacturer
    function getAllShippedRawMaterialList(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return MaterialShipmentList[_manufacturer];
    }

    /*************** SUPPLIER SECTION ***************************** */

    /*************** MANUFACTURER SECTION ***************************** */

    //Retrieve list of manufactured medicines addresses for manufacturer address. Only manufacturer can call this.
    //@param _manufacturer Address
    function getManufacturedMedicinesAddress(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return MedicinesManufactured[_manufacturer];
    }

    //Retrieve medicine details for medicine id. Only manufacturer can call this.
    //@param _batchId Address
    function getMedicineDetailsByBatchId(address _batchId)
        public
        view
        returns (
            address medicineId,
            string memory medicineName,
            string memory description,
            string memory location,
            Medicine.Entity memory medicineEntity,
            address materialId,
            uint256 quantity,
            uint256 packageStatus,
            uint256[] memory transactionBlocks
        )
    {
        return Medicine(_batchId).getManufacteredMedicineDetails();
    }

    /*************** MANUFACTURER SECTION ***************************** */

    /*************** DISTRIBUTOR SECTION ***************************** */

    //Get list of medicine bacthes transferred to pharma by distributor
    function getAllTransferredMedicineBatches(address _distributor)
        public
        view
        returns (address[] memory)
    {
        return MedicineBatchesTransferred[_distributor];
    }

    //Get sub contract details generated while transferring medicine batch from dist tot pharma
    function getMedicineBatchSubContractDetails(address _subContractId)
        public
        view
        returns (
            address medicineSubContract,
            address medicineId,
            Medicine.MedicineInfo memory medicineInfo,
            Medicine.Entity memory medicineEntity,
            address pharma,
            uint256 packageStatus,
            uint256[] memory transactionBlocksDP
        )
    {
        return MedicineDP(_subContractId).getMedicineDPSubContractDetails();
    }

    /*************** DISTRIBUTOR SECTION ***************************** */

    /*************** PHARMA SECTION ***************************** */

    //Retrieve medicine sale status updated by pharma for supplied medicineID.
    function getMedicineSaleStatusByID(address _subContractId)
        public
        view
        returns (uint256)
    {
        return uint256(MedicineSaleStatusAtPharma[_subContractId]);
    }

    /*************** PHARMA SECTION ***************************** */

    /*************** CUSTOMER SECTION ***************************** */

    function getCustomerInfoByPharmaShop(address _pharma)
        public
        view
        returns (CustomerInfo[] memory)
    {
        return CustomerPharmaShopMap[_pharma];
    }

    /*************** CUSTOMER SECTION ***************************** */
}
