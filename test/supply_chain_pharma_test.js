// const SupplyChain = artifacts.require("SupplyChain");
// const BigNumber = require('bignumber.js');


// /*
// * This test class register accounts[4] as a Pharma for receiving Medicine batches from accounts[3] Distributor & updating sale status. 
// * accounts[0] - Admin
// * accounts[1] - Supplier
// * accounts[2] - Manufacturer
// * accounts[3] - Distributor
// * accounts[9] - Transporter
// */

// contract("SupplyChain - Pharmaceutical Section", function (accounts) {
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
//     console.log("------>>> Supplier registered & Raw material created----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should register new manufacturer, transporter & load consignment of registered raw material to manufacturer. Update package status on recieved.", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.registerUser(accounts[2], 'user_MANU', 'Nagpur Urban', 3, {
//       from: accounts[0]
//     });
//     await this.supplyChain.registerUser(accounts[9], 'user_SHPR', 'Nagpur Rural', 2, {
//       from: accounts[0]
//     });
//     const packageID = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(0, { from: accounts[1] });   // get package id of 1st registered raw material. By Supplier
//     await this.supplyChain.loadConsignment(packageID, 1, accounts[6], { from: accounts[9] });  // load/ship consignment of 1st registered raw material & update status. By transporter.
//     await this.supplyChain.updateRecievedRawMaterialPackageStatus(packageID, { from: accounts[2] }); // Update package/material status once recieved by Manufacturer.
//     const statusAfterConsignmentrecieved = new BigNumber(await this.supplyChain.getReceivedRawMaterialPackageAtManufacturerStatus(packageID, { from: accounts[2] })); // check status whether package is recieved or not. By Manufacturer.
//     console.log("statusAfterRawMaterialConsignmentrecieved----->>>>", statusAfterConsignmentrecieved.toNumber());
//     console.log("------>>> Manufacturer, Transporter registered & raw material package transported to Manufacturer and status updated----->>>>>");
//     console.log("*******************************************************************************");
//   });


//   it("should create a new medicine batch by manufacturer using recieved registered material id", async () => {
//     console.log("*******************************************************************************");
//     const materialID = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(0, { from: accounts[1] });
//     const medicineBatch = await this.supplyChain.createMedicinePackage(materialID, "Crocin 650 against fever", "Crocin 650", 50, accounts[9], accounts[3], { from: accounts[2] });
//     const medicineId = medicineBatch.logs[0].args.MedicineID;
//     console.log("Generated MedicineID---->", medicineId);
//     console.log("------>>> New medicine batch created ----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should register new distributor", async () => {
//     console.log("*******************************************************************************");
//     const distUser = await this.supplyChain.registerUser(accounts[3], 'user_DIST', 'Mumbai', 5, {
//       from: accounts[0]
//     });
//     console.log("------>>> New distributor registered ----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should transport medicine batch from manufacturer to distributor. Update package status on recieved", async () => {
//     console.log("*******************************************************************************");

//     const medicineId = await this.supplyChain.getRegisteredMedicineIDByIndex(0, { from: accounts[2] });   // get medicine id of 1st registered medicine. By Manufacturer
//     //Pick package for Manu to Dist
//     await this.supplyChain.loadConsignment(medicineId, 2, accounts[6], { from: accounts[9] });  // load/ship consignment of 1st registered medicine batch & update status. By transporter.
//     await this.supplyChain.updateRecievedMedicinePackageStatus(medicineId, { from: accounts[3] }); // Update package/medicine status once recieved by Distributor.
//     const statusAfterConsignmentrecieved = new BigNumber(await this.supplyChain.getReceivedMedicinePackageAtDistributorStatus(medicineId, { from: accounts[3] })); // check status whether package is recieved or not. By Distributor.
//     console.log("statusAfterMedicineBatchConsignmentrecieved----->>>>", statusAfterConsignmentrecieved.toNumber());
//     console.log("------>>> Medicine batch transported to distributor using shipper & status updated ----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should register new pharma", async () => {
//     console.log("*******************************************************************************");
//     const pharmaUser = await this.supplyChain.registerUser(accounts[4], 'user_PHARMA', 'New Mumbai', 6, {
//       from: accounts[0]
//     });
//     console.log("----Pharma user---", pharmaUser.logs[0].args);
//     console.log("------>>> New Pharma registered ----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should initiate medicine batch transfer from Dist to Pharma only when package/medicine batch is with Dist.", async () => {
//     console.log("*******************************************************************************");
//     const medicineId = await this.supplyChain.getReceivedMedicinePackageIDByIndex(0, { from: accounts[3] });   // get medicine id of 1st medicine batch. By Distributor
//     const transferredMedbatchRes = await this.supplyChain.transferMedicineFromDistributorToPharma(medicineId, accounts[4], accounts[9], { from: accounts[3] }); // Update package/medicine status once recieved by Distributor.
//     console.log("transferredMedbatchRes & sub contract betwn Dist-Pharma ---->", transferredMedbatchRes.logs[0].args);
//     console.log("------>>> Medicine batch transferred to Pharm by Dist.----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should verify generated sub contract betwn Dist-Pharma for supplied medicine ID", async () => {
//     console.log("*******************************************************************************");
//     const _txID = await this.supplyChain.getTransferredMedicineTxIDByIndex(0, { from: accounts[3] });
//     const medicineId = await this.supplyChain.getReceivedMedicinePackageIDByIndex(0, { from: accounts[3] });
//     const subContrtId = await this.supplyChain.getMedicineSubContractDP(medicineId, { from: accounts[3] });
//     assert.equal(subContrtId, _txID);
//     console.log("------>>> Sub Contract ID verified between Dist-Pharma for MedicineID ----->>>>>");
//     console.log("*******************************************************************************");
//   });

//   it("should recieve & update medicine batch sale status transferred by Dist to Pharma", async () => {
//     console.log("*******************************************************************************");
//     const _medicineId = await this.supplyChain.getReceivedMedicinePackageIDByIndex(0, { from: accounts[3] });   // get medicine id of 1st medicine batch. By Distributor
//     await this.supplyChain.transferMedicineFromDistributorToPharma(_medicineId, accounts[4], accounts[9], { from: accounts[3] });
//     const medicineId = await this.supplyChain.getReceivedMedicinePackageIDByIndex(0, { from: accounts[3] });
//     const subContrtId = await this.supplyChain.getMedicineSubContractDP(medicineId, { from: accounts[3] });
//     //Pick package for Dist to Pharma
//     await this.supplyChain.loadConsignment(medicineId, 3, subContrtId, { from: accounts[9] });  // load/ship consignment of 1st registered medicine batch & update status. By transporter.
//     await this.supplyChain.updateRecievedMedicineBatchStatus(medicineId, subContrtId, 1, { from: accounts[4] });
//     const saleStatus = await this.supplyChain.getMedicineSaleStatusByID(medicineId, { from: accounts[4] });
//     assert.equal(saleStatus, 1); //true  1- AtPharma
//     console.log("------>>> Medicine batch recieved & verified by Pharma ----->>>>>");
//     await this.supplyChain.updateMedicineSaleStatus(medicineId, 3, { from: accounts[4] });
//     const _updatedSaleStatus = await this.supplyChain.getMedicineSaleStatusByID(medicineId, { from: accounts[4] });
//     assert.equal((new BigNumber(_updatedSaleStatus)).toNumber(), 3); //true  3- expire
//     // assert.equal(saleStatus, 2);//false  2- sold
//     console.log("------>>> Medicine sale status updated by Pharma ----->>>>>");
//     const medBatchesRecievedCount = new BigNumber(await this.supplyChain.getReceivedMedicineBatchesCount({ from: accounts[4] }));
//     console.log("medBatchesRecievedCount count is ----->>>>", medBatchesRecievedCount.toNumber());
//     console.log("*******************************************************************************");
//   });

// });

