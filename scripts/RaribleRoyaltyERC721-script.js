const hre = require("hardhat");

const main = async () => {
  const RoyaltyNFT = await hre.ethers.getContractFactory("RoyaltyNFT");
  const royaltyNFT = await RoyaltyNFT.deploy();
  await royaltyNFT.deployed();
  console.log("RoyaltyNFT deployed to:", royaltyNFT.address);

  let txn;
  const royalty10Percent = 1000;
  const royalty20Percent = 2000;
  txn = await royaltyNFT.mintJamNFT("0xDfb5d126aCFBa7391f94a045FDAc08969Ea9B918", 1, "first", "https://i.imgur.com/TZEhCTX.png");
  await txn.wait();
  txn = await royaltyNFT.setRoyalties(1, "0xDfb5d126aCFBa7391f94a045FDAc08969Ea9B918", royalty10Percent);
  await txn.wait();
  console.log("Minted NFT #1");
  let returnedTokenUri = await royaltyNFT.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);
  txn = await royaltyNFT.mintJamNFT("0xDfb5d126aCFBa7391f94a045FDAc08969Ea9B918", 2, "second", "https://i.imgur.com/WVAaMPA.png");
  await txn.wait();
  txn = await royaltyNFT.setRoyalties(2, "0xDfb5d126aCFBa7391f94a045FDAc08969Ea9B918", royalty20Percent);
  await txn.wait();
  console.log("Minted NFT #2");
  returnedTokenUri = await royaltyNFT.tokenURI(2);
  console.log("Token URI:", returnedTokenUri);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();
