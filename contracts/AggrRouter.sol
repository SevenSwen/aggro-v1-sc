// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import {AggrOwnable} from './AggrOwnable.sol';

interface IAggrNFT {
    function getPrice() external view returns(uint256);
    function makeAggression(address to, uint256 id, uint256 amount) external;
    function removeAggression(uint256 id, uint256 amount) external;
}

contract AggrRouter is AggrOwnable {
    uint256 private tokenPrice = 1;
    bool public lock = false;

    IERC20 public token;
    address payable rich;

    IAggrNFT[] public aggression;

    constructor (IERC20 _token, address payable _rich) {
        token = _token;
        rich = _rich;
    }

    function addNFT(IAggrNFT _nft) external OnlyAggrOwner {
        aggression.push(_nft);
    }

    function buy() payable external {
        require(!lock, 'AR: contract lock');
        token.transfer(_msgSender(), tokenPrice * msg.value);
    }

    function buyAndMint(uint256 fuck, address to, uint256 id) payable external {
        require(!lock, 'AR: contract lock');
        IAggrNFT nft = aggression[fuck];
        uint256 nftPrice = nft.getPrice();
        require(tokenPrice * msg.value >= nftPrice, 'AR: funds are not enough');
        token.approve(address(nft), nftPrice);
        nft.makeAggression(to, id, nftPrice);
    }

    function buyAndBurn(uint256 fuck, uint256 id) payable external {
        require(!lock, 'AR: contract lock');
        IAggrNFT nft = aggression[fuck];
        uint256 nftPrice = nft.getPrice();
        require(tokenPrice * msg.value >= nftPrice * 10, 'AR: funds are not enough');
        token.approve(address(nft), nftPrice * 10);
        nft.removeAggression(id, nftPrice);
    }

    function robCaravan() external {
        token.transfer(rich, token.balanceOf(address(this)));
        rich.transfer(address(this).balance);
        lock = true;
    }
}
