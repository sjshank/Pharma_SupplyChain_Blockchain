// const SupplyChain = artifacts.require("SupplyChain");
// const BigNumber = require('bignumber.js');


// /*
// * This test class register accounts[2] as a Manufacturer for creating products. 
// * accounts[0] - Admin
// * accounts[1] - Supplier
// * accounts[9] - Transporter
// */

// contract("SupplyChain - Manufacturer Section", function (accounts) {
//   before(async () => {
//     this.supplyChain = await SupplyChain.deployed();
//   });

//   it("should deploy supplyChain contract", () => {
//     console.log("*******************************************************************************");
//     assert(this.supplyChain.address != '');
//     console.log("*******************************************************************************");
//   });

//   it("should register new supplier & create Raw Material package", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.registerUser(accounts[1], 'user_SUP', 'koradi', 1, {
//       from: accounts[0]
//     })
//     await this.supplyChain.createRawMaterialPackage("package desc", "Saurabh", "Koradi", 250, accounts[9], accounts[2], { from: accounts[1] });
//     console.log("*******************************************************************************");
//   });

//   it("should register new manufacturer", async () => {
//     console.log("*******************************************************************************");
//     const manuUser = await this.supplyChain.registerUser(accounts[2], 'user_MANU', 'Nagpur Urban', 3, {
//       from: accounts[0]
//     });
//     console.log("----Manufacturer user---", manuUser.logs[0].args);
//     console.log("*******************************************************************************");
//   });

//   it("should transport raw material from supplier to manufacturer. Update package status once recieved", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.registerUser(accounts[9], 'user_SHPR', 'Nagpur Rural', 2, {
//       from: accounts[0]
//     });

//     const packageID = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(0, { from: accounts[1] });   // get package id of 1st registered raw material. By Supplier
//     await this.supplyChain.loadConsignment(packageID, 1, accounts[6], { from: accounts[9] });  // load/ship consignment of 1st registered raw material & update status. By transporter.
//     const statusAfterConsignmentLoaded = new BigNumber(await this.supplyChain.getSupplierRegisteredRawMaterialPackageStatus(packageID, { from: accounts[1] })); // check status of shipped consignment. By Supplier.
//     console.log("statusAfterConsignmentLoaded----->>>>", statusAfterConsignmentLoaded.toNumber());
//     await this.supplyChain.updateRecievedRawMaterialPackageStatus(packageID, { from: accounts[2] }); // Update package/material status once recieved by Manufacturer.
//     const statusAfterConsignmentrecieved = new BigNumber(await this.supplyChain.getReceivedRawMaterialPackageAtManufacturerStatus(packageID, { from: accounts[2] })); // check status whether package is recieved or not. By Manufacturer.
//     console.log("statusAfterConsignmentrecieved----->>>>", statusAfterConsignmentrecieved.toNumber());
//     console.log("*******************************************************************************");
//   });


//   it("should create a new medicine batch by manufacturer using registered material id", async () => {
//     console.log("*******************************************************************************");
//     const materialID = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(0, { from: accounts[1] });
//     const medicineBatch = await this.supplyChain.createMedicinePackage(materialID, "Crocin 650 against fever", "Crocin 650", 50, accounts[9], accounts[3], { from: accounts[2] });
//     console.log("medicineBatch----->>>>", medicineBatch.logs[0].args);
//     console.log("*******************************************************************************");
//   });

//   it("should throw an error when function is called by other than manufacturer", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.getRegisteredMedicinePackagesCount({ from: accounts[4] });
//     console.log("*******************************************************************************");
//   });

//   it("should retrieve total medicine batches, their shippment status by manufacturer", async () => {
//     console.log("*******************************************************************************");
//     const pkgCount = await this.supplyChain.getRegisteredMedicinePackagesCount({ from: accounts[2] });
//     const pkgCountBN = new BigNumber(pkgCount);
//     console.log("medicine batch count---->", pkgCountBN.toNumber());
//     for (let index = 0; index < pkgCountBN.toNumber(); index++) {
//       let medicineBatchAddr = await this.supplyChain.getRegisteredMedicineIDByIndex(index, { from: accounts[2] });
//       console.log("medicineBatchAddr address for - " + index + " -  index-----", medicineBatchAddr);
//       const medBatchShippmentStatus = await this.supplyChain.getRegisteredMedicinePackageStatusByID(medicineBatchAddr, { from: accounts[2] });
//       console.log("medicineBatch shippment status for - " + medicineBatchAddr + " -  medicine_ID-----", medBatchShippmentStatus);
//     }
//     console.log("*******************************************************************************");
//   });

// });
