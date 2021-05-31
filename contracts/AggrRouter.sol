// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import {AggrOwnable} from './AggrOwnable.sol';

interface IAggrNFT {
    function getPrice() external view returns(uint256);
    function mint(address to, uint256 id, uint256 amount) external;
    function burn(uint256 id, uint256 amount) external;
}

contract AggrRouter is AggrOwnable {
    uint256 private price = 1;
    bool public lock = false;

    IERC20 public token;
    IAggrNFT public nft;
    address payable rich;

    constructor (IERC20 _token, IAggrNFT _nft, address payable _rich) {
        token = _token;
        nft = _nft;
        rich = _rich;
    }

    function buy() payable external {
        require(!lock, 'AR: contract lock');
        token.transfer(_msgSender(), price * msg.value);
    }

    function buyAndMint(address to, uint256 id) payable external {
        require(!lock, 'AR: contract lock');
        uint256 nftPrice = nft.getPrice();
        require(price * msg.value >= nftPrice, 'AR: funds are not enough');
        token.approve(address(nft), nftPrice);
        nft.mint(to, id, nftPrice);
    }

    function robCaravan() external {
        token.transfer(rich, token.balanceOf(address(this)));
        rich.transfer(address(this).balance);
        lock = true;
    }
}
