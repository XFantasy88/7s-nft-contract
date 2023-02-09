import { ethers } from "hardhat";

async function main() {
  const NFT = await ethers.getContractFactory("XiDNFT");
  const nft = await NFT.deploy(
    "0x367db1215Bf0eFfdBc9a10d9Fd4dD9dD896f670e",
    "0xFEca406dA9727A25E71e732F9961F680059eF1F9",
    "0x0000000000000000000000000000000000000000",
    [1500000, 1750000, 2750000],
    [1000, 2000, 2000],
    "ipfs://QmVUigVykYVQgk6ZtjcaJ3xTNir6Xa758h7baUQQpzuJin"
  );

  await nft.deployed();
  console.log("NFT address: ", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
