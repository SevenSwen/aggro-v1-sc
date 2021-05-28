import { ethers, waffle } from 'hardhat'
import { Fixture } from 'ethereum-waffle'
import {BigNumber, Wallet} from 'ethers'

import { Contract } from '@ethersproject/contracts'
import { constants } from 'ethers'

import {
    MockERC20,
} from '../../typechain'

interface TokensFixture {
    token0: MockERC20
    token1: MockERC20
    token2: MockERC20
}

export async function tokensFixture(): Promise<TokensFixture> {
    const tokenFactory = await ethers.getContractFactory('MockERC20')
    const tokenA = (await tokenFactory.deploy(BigNumber.from(2).pow(255))) as MockERC20
    const tokenB = (await tokenFactory.deploy(BigNumber.from(2).pow(255))) as MockERC20
    const tokenC = (await tokenFactory.deploy(BigNumber.from(2).pow(255))) as MockERC20

    const [token0, token1, token2] = [tokenA, tokenB, tokenC].sort((tokenA, tokenB) =>
        tokenA.address.toLowerCase() < tokenB.address.toLowerCase() ? -1 : 1
    )

    return { token0, token1, token2 }
}

