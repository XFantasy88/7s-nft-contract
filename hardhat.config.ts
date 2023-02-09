import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.17",

  networks: {
    mumbai: {
      url: process.env.MUMBAI_RPC_URI,
      chainId: 80001,
      accounts: [process.env.PRIVATE_KEY ?? ""],
      timeout: 600000000,
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGON_MUMBAI_API_KEY ?? "",
    },
  },
};

export default config;
