// const SupplyChain = artifacts.require("SupplyChain");

// contract("SupplyChain - User Section", function (accounts) {
//   before(async () => {
//     this.supplyChain = await SupplyChain.deployed();
//   });

//   it("should deploy supplyChain contract", () => {
//     console.log("*******************************************************************************");
//     assert(this.supplyChain.address != '');
//     console.log("*******************************************************************************");
//   });

//   it("should register new user with proper role", async () => {
//     console.log("*******************************************************************************");
//     const supUser = await this.supplyChain.registerUser(accounts[1], 'user_SUP', 'koradi', 1, {
//       from: accounts[0]
//     })
//     const _regUserEvt = supUser.logs[0] && supUser.logs[0].args;
//     console.log("supUserRegEvt-----", _regUserEvt);
//     console.log("*******************************************************************************");
//   });

//   it("should throw error as accounts[2] is not admin/owner who deployed contract. Only admin has rights to register user", async () => {
//     console.log("*******************************************************************************");
//     const gUser = await this.supplyChain.registerUser(accounts[1], 'Guest', 'Guest', 0, {
//       from: accounts[2]
//     });
//     console.log("gUser-----", gUser);
//     console.log("*******************************************************************************");
//   });

//   it("should retrieve registered user based on passed address", async () => {
//     console.log("*******************************************************************************");
//     const regSupUser = await this.supplyChain.getUserInfo(accounts[1]);
//     console.log("Supplier User----", regSupUser);
//     console.log("*******************************************************************************");
//   });

//   it("should retrieve registered user count", async () => {
//     console.log("*******************************************************************************");
//     const userCount = await this.supplyChain.getUsersCount();
//     console.log("total users----", userCount);
//     console.log("*******************************************************************************");
//   });

//   it("should revoke registered user role", async () => {
//     console.log("*******************************************************************************");
//     const supUser = await this.supplyChain.registerUser(accounts[3], 'user_SUP_sample', 'mauza', 1);
//     console.log("Sample Sup user registered ---- ", supUser);
//     const supUserRoleRvkd = await this.supplyChain.revokeUserRole(accounts[3]);
//     const _supUserRoleRvkdEvt = supUserRoleRvkd.logs[0] && supUserRoleRvkd.logs[0].args;
//     console.log("supUserRoleRvkdEvt-----", _supUserRoleRvkdEvt);
//     console.log("*******************************************************************************");
//   });

//   it("should throw error when trying to revoke unregistered user role", async () => {
//     console.log("*******************************************************************************");
//     const supUser = await this.supplyChain.registerUser(accounts[8], 'user_SUP_sample_1', 'mauza_1', 1);
//     console.log("Sample Sup user registered ---- ", supUser);
//     const supUserRoleRvkd = await this.supplyChain.revokeUserRole(accounts[7]);
//     const _supUserRoleRvkdEvt = supUserRoleRvkd.logs[0] && supUserRoleRvkd.logs[0].args;
//     console.log("supUserRoleRvkdEvt-----", _supUserRoleRvkdEvt);
//     console.log("*******************************************************************************");
//   });

// });



