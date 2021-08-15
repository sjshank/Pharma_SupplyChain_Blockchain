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
        approved,
        expired,
        sold
    }

    event UpdatedMedicineSubBatchStatusOnReceived(
        address subContractId,
        address medicineId,
        uint256 packageStatus,
        uint256[] transactionBlocksDP
    );

    event UpdatedMedicineSaleStatus(
        address subContractId,
        address medicineId,
        uint256 saleStatus
    )

    modifier onlyPharma {
        require(UsersDetails[msg.sender].userRole == roles.pharma, "OPCC"); //"Only Pharma can call this function."
        _;
    }

    function submitCustomerAndMedicineSaleDetails(
        address _subContractId,
        string memory _customerName,
        uint256 _customerAge,
        string memory _doctorName,
        uint256 _quantity,
        uint256 _amountPaid,
        address _medicineId,
        uint256 _medicineStatus
    ) public onlyPharma {
        require(
            MedicineSaleStatusAtPharma[_subContractId] >= status.approved,
            "M_MUST_AT_APRD"
        ); //"Medicine must be at Pharma."
        MedicineSaleStatusAtPharma[_subContractId] = status(_medicineStatus);
        pushCustomerDetails(
            _customerName,
            _customerAge,
            _doctorName,
            _quantity,
            _amountPaid,
            _medicineId,
            msg.sender,
            Medicine(_medicineId).getMaterialID()
        );
    }

    function updateSaleStatus(address _subContractId, uint256 _medicineStatus)
        public
        onlyPharma
    {
        require(
            MedicineSaleStatusAtPharma[_subContractId] >= status.approved,
            "M_MUST_AT_APRD"
        ); //"Medicine must be at Pharma."
        MedicineSaleStatusAtPharma[_subContractId] = status(_medicineStatus);
        emit UpdatedMedicineSaleStatus(
            _subContractId,
            MedicineDP(_subContractId).getMedicineID(), 
            _medicineStatus
            );
    }

    function getTotalMedicineSubBatchesDeliveredCount()
        public
        view
        returns (uint256)
    {
        return TotalMedicineSubBatchesDelivered;
    }

    //Reject received medicine sub batch if damaged/expired
    function rejectMedicineSubBatch(address _subContractId) public onlyPharma {
        bool result = MedicineDP(_subContractId)
        .rejectMedicineSubBatchAtReceiver();
        if (result) {
            emit UpdatedMedicineSubBatchStatusOnReceived(
                _subContractId,
                MedicineDP(_subContractId).getMedicineID(),
                MedicineDP(_subContractId).getMedicineSubBatchStatus(),
                MedicineDP(_subContractId).getTransactionBlocksDP()
            );
        }
    }

    //Approve received medicine sub batch
    function approveMedicineSubBatch(address _subContractId) public onlyPharma {
        bool result = MedicineDP(_subContractId)
        .approveMedicineSubBatchAtReceiver();
        if (result) {
            MedicineSaleStatusAtPharma[_subContractId] = status(0);
            emit UpdatedMedicineSubBatchStatusOnReceived(
                _subContractId,
                MedicineDP(_subContractId).getMedicineID(),
                MedicineDP(_subContractId).getMedicineSubBatchStatus(),
                MedicineDP(_subContractId).getTransactionBlocksDP()
            );
        }
    }
}
