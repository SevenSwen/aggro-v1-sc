// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import {AggrBaseNFT} from './AggrBaseNFT.sol';

contract AggrNFT is AggrBaseNFT {
    IERC20 public token;
    uint256 private price;
    address private rich;

    mapping(uint256 => address) public nftFrom;

    constructor (IERC20 _token, uint256 _price, address _rich) {
        token = _token;
        price = _price;
        rich = _rich;
    }

    function getPrice() external view returns(uint256) {
        return price;
    }

    function mint(address to, uint256 id, uint256 amount) external {
        require(amount >= price, 'AN: funds are not enough');
        token.transferFrom(_msgSender(), rich, amount);
        nftFrom[id] = _msgSender();
        _mint(to, id);
    }

    function burn(uint256 id, uint256 amount) external {
        require(amount >= price * 10, 'AN: funds are not enough');
        token.transferFrom(_msgSender(), rich, amount - (price * 2));
        token.transferFrom(_msgSender(), nftFrom[id], price * 2);
        _burn(id);
    }
}
