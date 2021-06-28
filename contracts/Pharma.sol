// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";

contract Pharma is User {
    mapping(address => address[]) MedicinePackagesReceivedAtPharma; // Track list of medicine batches received by each pharma.
    mapping(address => status) MedicineSaleStatusAtPharma; // Track sale status of each medicine ID received/sold/expired/damage at Pharma.

    enum status {
        notFound,
        atPharma,
        sold,
        expire,
        damaged
    }

    //Event
    event MedicineStatusUpdated(
        address MedicineID,
        address indexed Pharma,
        uint256 MedicineStatus
    );

    modifier onlyPharma {
        require(UsersDetails[msg.sender].userRole == roles.pharma, "OPCC"); //"Only Pharma can call this function."
        _;
    }

    //Recieve & update medicine package shippment status for supplied package ID by tagged/associated receiver/distributor. Update MedicinePackagesReceivedAtDistributor mapping
    //@param _packageID Medicine/Package/batch ID Address
    function updateRecievedMedicineBatchStatus(
        address _medicineID,
        address _subContractID,
        uint256 _medicineStatus
    ) public onlyPharma {
        MedicineDP(_subContractID).receivedPackageDP(_medicineID, msg.sender);
        MedicinePackagesReceivedAtPharma[msg.sender].push(_medicineID);
        MedicineSaleStatusAtPharma[_medicineID] = status(_medicineStatus);
    }

    //Update medicine sale status for supplied medicineID. Only Pharma can call this.
    function updateMedicineSaleStatus(address _medicineID, uint256 _status)
        public
        onlyPharma
    {
        require(
            MedicineSaleStatusAtPharma[_medicineID] == status.atPharma,
            "M_MUST_AT_P"
        ); //"Medicine must be at Pharma."
        MedicineSaleStatusAtPharma[_medicineID] = status(_status);
        emit MedicineStatusUpdated(_medicineID, msg.sender, _status);
    }

    //Retrieve medicine sale status updated by pharma for supplied medicineID. Only Pharma can call this.
    function getMedicineSaleStatusByID(address _medicineID)
        public
        view
        onlyPharma
        returns (uint256)
    {
        return uint256(MedicineSaleStatusAtPharma[_medicineID]);
    }

    //Retrieve number of medicine batches received by each pharma. Only Pharma can call this.
    function getReceivedMedicineBatchesCount()
        public
        view
        onlyPharma
        returns (uint256)
    {
        return MedicinePackagesReceivedAtPharma[msg.sender].length;
    }

    //Retrieve  medicine/package ID using index received by Pharma. Only Pharma can call this.
    //@param _index Uint
    function getReceivedMedicineIDByIndex(uint256 _index)
        public
        view
        onlyPharma
        returns (address)
    {
        return MedicinePackagesReceivedAtPharma[msg.sender][_index];
    }
}
