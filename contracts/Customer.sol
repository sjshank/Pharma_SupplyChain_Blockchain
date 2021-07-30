// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract Customer {
    mapping(address => CustomerInfo[]) CustomerMedicineMap;
    mapping(address => CustomerInfo[]) CustomerPharmaShopMap;
    // CustomerInfo[] public CustomerList;

    struct CustomerInfo {
        string customerName;
        uint256 customerAge;
        string doctorName;
        uint256 quantity;
        uint256 amountPaid;
        address medicineId;
        address materialId;
    }

    function pushCustomerDetails(
        string memory _customerName,
        uint256 _customerAge,
        string memory _doctorName,
        uint256 _quantity,
        uint256 _amountPaid,
        address _medicineId,
        address _pharma,
        address _materialId
    ) public {
        CustomerInfo memory newCustomer;
        newCustomer.customerName = _customerName;
        newCustomer.customerAge = _customerAge;
        newCustomer.doctorName = _doctorName;
        newCustomer.quantity = _quantity;
        newCustomer.amountPaid = _amountPaid;
        newCustomer.materialId = _materialId;
        newCustomer.medicineId = _medicineId;
        CustomerMedicineMap[_medicineId].push(newCustomer);
        CustomerPharmaShopMap[_pharma].push(newCustomer);
    }

    // function getCustomerInfoByMedicineId(address _medicineId)
    //     public
    //     view
    //     returns (CustomerInfo[] memory)
    // {
    //     return CustomerMedicineMap[_medicineId];
    // }

}
