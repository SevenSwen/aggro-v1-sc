import { ethers, waffle } from 'hardhat'
import dotenv from 'dotenv'
dotenv.config()

async function main() {
    // We get the contract to deploy
    const AggrNFT = await ethers.getContractFactory("AggrNFT");
    const AggrRouter = await ethers.getContractFactory("AggrRouter");
    const AggrToken = await ethers.getContractFactory("AggrToken");
    console.log("Deploying...");
    const token = await AggrToken.deploy();
    console.log("AggrToken deployed to:", token.address);
    const router = await AggrRouter.deploy(token.address, process.env.DEPLOYER_ACCOUNT);
    console.log("AggrRouter deployed to:", router.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
