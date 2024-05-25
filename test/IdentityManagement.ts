import { ethers, upgrades } from "hardhat";

describe("IdentityManagement", function () {
  it("deploys", async function () {
    const IdentityManagement = await ethers.getContractFactory(
      "IdentityManagement"
    );

    const address = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';

    const instance = await upgrades.deployProxy(IdentityManagement, [address], {
      kind: "uups",
    });

    console.log("Contract deployed at:", await instance.getAddress());
  });
});
