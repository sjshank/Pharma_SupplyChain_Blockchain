// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";
import "./Customer.sol";

contract Pharma is User, Customer {
    mapping(address => status) MedicineSaleStatusAtPharma; // Track sale status of each medicine ID received/sold/expired/damage at Pharma.
    uint256 public TotalMedicineSubBatchesDelivered;

    enum status {
        notFound,
        approved,
        expired,
        damaged,
        sold
    }

    modifier onlyPharma {
        require(UsersDetails[msg.sender].userRole == roles.pharma, "OPCC"); //"Only Pharma can call this function."
        _;
    }

    //Recieve & update medicine package shippment status for supplied package ID by tagged/associated receiver/distributor. Update MedicinePackagesReceivedAtDistributor mapping
    //@param _packageID Medicine/Package/batch ID Address
    function updateRecievedMedicineBatchStatus(
        address _medicineID,
        address _subContractID,
        uint256 _medicineSaleStatus
    ) public onlyPharma {
        MedicineDP(_subContractID).receivedPackageDP(_medicineID);
        MedicineSaleStatusAtPharma[_medicineID] = status(_medicineSaleStatus);
        TotalMedicineSubBatchesDelivered = TotalMedicineSubBatchesDelivered + 1;
    }

    function submitCustomerAndMedicineSaleDetails(
        string memory _customerName,
        uint256 _customerAge,
        string memory _doctorName,
        uint256 _quantity,
        uint256 _amountPaid,
        address _medicineId,
        address _materialId,
        uint256 _medicineStatus
    ) public onlyPharma {
        require(
            MedicineSaleStatusAtPharma[_medicineId] >= status.approved,
            "M_MUST_AT_APRD"
        ); //"Medicine must be at Pharma."
        MedicineSaleStatusAtPharma[_medicineId] = status(_medicineStatus);
        pushCustomerDetails(
            _customerName,
            _customerAge,
            _doctorName,
            _quantity,
            _amountPaid,
            _medicineId,
            msg.sender,
            _materialId
        );
    }

    function updateSaleStatus(address _medicineID, uint256 _medicineStatus)
        public
        onlyPharma
    {
        MedicineSaleStatusAtPharma[_medicineID] = status(_medicineStatus);
    }

    function getTotalMedicineSubBatchesDeliveredCount()
        public
        view
        returns (uint256)
    {
        return TotalMedicineSubBatchesDelivered;
    }
}
