import { ethers, upgrades } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  const ownerAddress = deployer.address;

  console.log("Deployer address:", ownerAddress);

  // Deploy VersionControl contract
  const VersionControl = await ethers.getContractFactory("VersionControl");
  console.log("Deploying VersionControl implementation...");
  const versionControl = await upgrades.deployProxy(VersionControl, [ownerAddress], {  kind: 'uups' });
  console.log("VersionControl deployed to:", await versionControl.getAddress());

  // Deploy IdentityManagement contract
  const IdentityManagement = await ethers.getContractFactory("IdentityManagement");
  console.log("Deploying IdentityManagement implementation...");
  const identityManagement = await upgrades.deployProxy(IdentityManagement, [ownerAddress], {  kind: 'uups' });
  console.log("IdentityManagement deployed to:", await identityManagement.getAddress());

  // Deploy ContributionTracker contract
  const ContributionTracker = await ethers.getContractFactory("ContributionTracker");
  console.log("Deploying ContributionTracker implementation...");
  const contributionTracker = await upgrades.deployProxy(ContributionTracker, [ownerAddress, await versionControl.getAddress(), await identityManagement.getAddress()], {  kind: 'uups' });
  console.log("ContributionTracker deployed to:", await contributionTracker.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
