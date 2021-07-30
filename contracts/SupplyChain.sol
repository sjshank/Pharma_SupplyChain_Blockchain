// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Supplier.sol";
import "./Manufacturer.sol";
import "./Distributor.sol";
import "./Pharma.sol";
import "./User.sol";
import "./RawMaterials.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";

contract SupplyChain is Supplier, Manufacturer, Distributor, Pharma {
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
    function getListOfRegisteredRawMateriaAddress(address _address)
        public
        view
        returns (address[] memory)
    {
        return SupplierRegisteredRawMaterialList[_address];
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
            uint256[] memory transactionDates
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
            address manufacturer,
            string memory description,
            string memory medicineName,
            string memory location,
            address materialId,
            uint256 quantity,
            address shipper,
            address distributor,
            uint256 packageStatus,
            uint256[] memory transactionBlocks
        )
    {
        return Medicine(_batchId).getManufacteredMedicineDetails();
    }

    //Get all the shipped medicine list for distributor
    function getAllShippedMedicineList(address _distributor)
        public
        view
        returns (address[] memory)
    {
        return MedicineBatchShipmentList[_distributor];
    }

    /*************** MANUFACTURER SECTION ***************************** */

    /*************** DISTRIBUTOR SECTION ***************************** */

    //Get list of medicine bacthes transferred to pharma by distributor
    function getAllTransferredMedicineBatches(address _pharma)
        public
        view
        returns (address[] memory)
    {
        return MedicineBatchesTransferredToPharma[_pharma];
    }

    //Get sub contract details generated while transferring medicine batch from dist tot pharma
    function getMedicineBatchSubContractDetails(address _subContractId)
        public
        view
        returns (
            address medicineId,
            address shipper,
            address distributor,
            uint256 packageStatus,
            uint256 medicineStatus
        )
    {
        (
            address _medicineId,
            address _shipper,
            address _distributor,
            uint256 _packageStatus
        ) = MedicineDP(_subContractId).getMedicineDPSubContractDetails();
        return (
            _medicineId,
            _shipper,
            _distributor,
            _packageStatus,
            uint256(MedicineSaleStatusAtPharma[_medicineId])
        );
    }

    /*************** DISTRIBUTOR SECTION ***************************** */

    /*************** PHARMA SECTION ***************************** */

    //Retrieve medicine sale status updated by pharma for supplied medicineID.
    function getMedicineSaleStatusByID(address _medicineID)
        public
        view
        returns (uint256)
    {
        return uint256(MedicineSaleStatusAtPharma[_medicineID]);
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
