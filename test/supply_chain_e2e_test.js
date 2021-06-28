const SupplyChain = artifacts.require("SupplyChain");
const BigNumber = require('bignumber.js');


/*
* This test class register all required user with resp. role, perform all the transaction needed to build & transport medicine to the pharmaceutical, update sale status.
* accounts[0] - Admin
* accounts[1] - Supplier
* accounts[2] - Manufacturer
* accounts[3] - Distributor
* accounts[4] - Pharma
* accounts[9] - Transporter/Shipper
* accounts[6] - Dummy address used
*/


contract("---------->>>>> Pharmaceutical Supply Chain Test Class <<<<<------------", function (accounts) {
  before(async () => {
    this.supplyChain = await SupplyChain.deployed();
    this.admin = accounts[0];
    this.supplier = accounts[1];
    this.manufacturer = accounts[2];
    this.distributor = accounts[3];
    this.pharma = accounts[4];
    this.transporter = accounts[9];

    this.materialPackageId = undefined;
    this.medicineBatchId = undefined;
  });



  it("should deploy supplyChain contract", () => {
    console.log("*******************************************************************************");
    assert(this.supplyChain.address != '');
    console.log("*******************************************************************************");
  });



  it("should register all the required users with related role by Admin", async () => {
    console.log("*******************************************************************************");
    await this.supplyChain.registerUser(this.supplier, 'SUPPLIER', 'Bidar', 1, {
      from: this.admin
    });
    await this.supplyChain.registerUser(this.manufacturer, 'MANUFACTURER', 'Rangareddy', 3, {
      from: this.admin
    });
    await this.supplyChain.registerUser(this.distributor, 'DISTRIBUTOR', 'Lingampally', 5, {
      from: this.admin
    });
    await this.supplyChain.registerUser(this.pharma, 'PHARMA', 'Hyderabad', 6, {
      from: this.admin
    });
    await this.supplyChain.registerUser(this.transporter, 'TRANSPORTER', 'Hyderabad', 2, {
      from: this.admin
    });
    const _totalUsers = new BigNumber(await this.supplyChain.getUsersCount());
    assert.equal(_totalUsers.toNumber(), 5);
    console.log("*******************************************************************************");
  });


  it("Supplier should create new Raw Material", async () => {
    const rawMaterialPkg = await this.supplyChain.createRawMaterialPackage("paracetamol", "LEBEN SCIENCE", "Bidar", 200, this.transporter, this.manufacturer, { from: this.supplier });
    const _rawMaterialPkgnEvt = rawMaterialPkg.logs[0] && rawMaterialPkg.logs[0].args;
    assert(_rawMaterialPkgnEvt != undefined);
    this.materialPackageId = _rawMaterialPkgnEvt && _rawMaterialPkgnEvt.MaterialID;
    assert(this.materialPackageId != undefined);
  });


  it("should transport Raw Material from Supplier to Manufacturer by Transporter & update status by Manufacturer on recieved", async () => {
    await this.supplyChain.loadConsignment(this.materialPackageId, 1, accounts[6], { from: this.transporter });
    await this.supplyChain.updateRecievedRawMaterialPackageStatus(this.materialPackageId, { from: this.manufacturer });
    const _status = new BigNumber(await this.supplyChain.getReceivedRawMaterialPackageAtManufacturerStatus(this.materialPackageId, { from: this.manufacturer }));
    assert.equal(_status.toNumber(), 2);
  });


  it("Manufacturer should create a new Medicine Batch using recieved material package from supplier & transport to distributor", async () => {
    const medicineBatch = await this.supplyChain.createMedicinePackage(this.materialPackageId, "Crocin 650 against fever", "Crocin 650", 50, this.transporter, this.distributor, { from: this.manufacturer });
    const _medicineBatchEvt = medicineBatch.logs[0] && medicineBatch.logs[0].args;
    assert(_medicineBatchEvt != undefined);
    this.medicineBatchId = _medicineBatchEvt && _medicineBatchEvt.MedicineID;
    assert(this.medicineBatchId != undefined);
  });


  it("should transport Medicine Batch from Manufacturer to Distributor by Transporter & update status by Distributor on recieved", async () => {
    await this.supplyChain.loadConsignment(this.medicineBatchId, 2, accounts[6], { from: this.transporter });
    await this.supplyChain.updateRecievedMedicinePackageStatus(this.medicineBatchId, { from: this.distributor });
    const _status = new BigNumber(await this.supplyChain.getReceivedMedicinePackageAtDistributorStatus(this.medicineBatchId, { from: this.distributor }));
    assert.equal(_status.toNumber(), 2);
  });


  it("Distributor should transfer Medicine Batch recieved from Manufacturer & transport to Pharma. Capture Transaction as a Sub Contract", async () => {
    const medicineBatchTransfr = await this.supplyChain.transferMedicineFromDistributorToPharma(this.medicineBatchId, this.pharma, this.transporter, { from: this.distributor });
    const _medicineBatchTransfrEvt = medicineBatchTransfr.logs[0] && medicineBatchTransfr.logs[0].args;
    assert(_medicineBatchTransfrEvt != undefined);
    const subContract = await this.supplyChain.getMedicineSubContractDP(this.medicineBatchId, { from: this.distributor });
    assert.equal(subContract, _medicineBatchTransfrEvt.SubContractID);
    await this.supplyChain.loadConsignment(this.medicineBatchId, 3, subContract, { from: this.transporter });
    const _status = new BigNumber(await this.supplyChain.getReceivedMedicinePackageAtDistributorStatus(this.medicineBatchId, { from: this.pharma }));
    assert.equal(_status.toNumber(), 3);
  });

  it("Pharma should verify & update recieved Medicine batch status. Also, track medicine sale status", async () => {
    const subContract = await this.supplyChain.getMedicineSubContractDP(this.medicineBatchId, { from: this.distributor });
    await this.supplyChain.updateRecievedMedicineBatchStatus(this.medicineBatchId, subContract, 1, { from: this.pharma });
    const _status1 = new BigNumber(await this.supplyChain.getMedicineSaleStatusByID(this.medicineBatchId, { from: this.pharma }));
    assert.equal(_status1.toNumber(), 1);
    await this.supplyChain.updateMedicineSaleStatus(this.medicineBatchId, 3, { from: this.pharma });
    const _status = new BigNumber(await this.supplyChain.getMedicineSaleStatusByID(this.medicineBatchId, { from: this.pharma }));
    assert.equal(_status.toNumber(), 3);
  });

});