import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

const INFURA_API_KEY = vars.get("INFURA_API_KEY");
const DEV_ACCOUNT_KEY = vars.get("DEV_ACCOUNT_KEY");

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    opsepolia: {
      url: `https://optimism-sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [`${DEV_ACCOUNT_KEY}`],
    },
  },
};

export default config;
