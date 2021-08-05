
const SupplyChain = artifacts.require("SupplyChain");


// module.exports = function (deployer, network, accounts) {

//   deployer.deploy(Owner);
//   deployer.deploy(User).then(async (inst) => {
//     const result = await inst.registerAdmin(accounts[1], 'USER_ADMIN', 'India', 8, 'Active');
//     console.log(result.logs);
//     deployer.deploy(Supplier, User.address);
//   });
//   deployer.deploy(Manufacturer);
//   deployer.deploy(Distributor);
//   deployer.deploy(Pharma);
//   // deployer.deploy(Owner).then((inst) => {
//   // deployer.deploy(User).then((_inst) => {
//   //   deployer.deploy(RawMaterials).then((_inst) => {
//   //     deployer.deploy(Supplier).then((_inst) => {
//   //       deployer.deploy(Medicine).then((_inst) => {
//   //         deployer.deploy(Manufacturer).then((_inst) => {
//   //         });
//   //       });
//   //     });
//   //   });
//   // });
//   // })
// };


module.exports = function (deployer, network, accounts) {
  deployer.deploy(SupplyChain).then(async (inst) => {
    await inst.registerAdmin(accounts[1], 'USER_ADMIN', 'India', 8, 'Active');
    await inst.registerUser(accounts[2], 'USER_SUPPLIER', 'Maharashtra', 1, 'Active', { from: accounts[1] });
    await inst.registerUser(accounts[9], 'USER_SHPR', 'Nagpur', 2, 'Active', { from: accounts[1] });
    await inst.registerUser(accounts[3], 'USER_MANU', 'Koradi', 3, 'Active', { from: accounts[1] });
    await inst.registerUser(accounts[4], 'USER_DIST', 'Nagpur', 5, 'Active', { from: accounts[1] });
    await inst.registerUser(accounts[5], 'USER_PHARMA', 'Mumbai', 6, 'Active', { from: accounts[1] });




    await inst.createRawMaterialPackage("package desc", "Material 1", "Koradi", 250, accounts[9], accounts[3], { from: accounts[2] });
    await inst.createRawMaterialPackage("package desc", "Material 2", "Nagpur", 350, accounts[9], accounts[3], { from: accounts[2] });
    await inst.createRawMaterialPackage("package desc", "Material 3", "Hyderabad", 350, accounts[9], accounts[3], { from: accounts[2] });
    await inst.createRawMaterialPackage("package desc", "Material 4", "Hyderabad", 350, accounts[9], accounts[3], { from: accounts[2] });
    await inst.createRawMaterialPackage("package desc", "Material 5", "Hyderabad", 350, accounts[9], accounts[3], { from: accounts[2] });
    await inst.createRawMaterialPackage("package desc", "Material 6", "Hyderabad", 350, accounts[9], accounts[3], { from: accounts[2] });



    const result = await inst.getAllRegisteredUsers();
    console.log(result);
  });
}
// module.exports = function (deployer, network, accounts) {
//   deployer.deploy(Owner).then((inst) => {
//     deployer.deploy(User).then((_inst) => {
//       deployer.deploy(RawMaterials).then((_inst) => {
//         deployer.deploy(Medicine).then((_inst) => {
//           deployer.deploy(Manufacturer).then((_inst) => {
//           });
//         });
//       });
//     });
//   });
// };
