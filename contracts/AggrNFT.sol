// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import {AggrBaseNFT} from './AggrBaseNFT.sol';

contract AggrNFT is AggrBaseNFT {
    IERC20 public token;
    uint256 private price;
    address private rich;

    constructor (string memory swearing, IERC20 _token, uint256 _price, address _rich)
    AggrBaseNFT(swearing) {
        token = _token;
        price = _price;
        rich = _rich;
    }

    function getPrice() external view returns(uint256) {
        return price;
    }

    function makeAggression(address to, uint256 id, uint256 amount) external {
        require(amount >= price, 'AN: funds are not enough');
        token.transferFrom(_msgSender(), rich, amount);
        _mint(_msgSender(), id);
        _transfer(_msgSender(), to, id);
    }

    function removeAggression(uint256 id, uint256 amount) external {
        require(amount >= price * 10, 'AN: funds are not enough');
        token.transferFrom(_msgSender(), rich, amount - (price * 2));
        token.transferFrom(_msgSender(), _getRednecks(id), price * 2);
        _burn(id);
    }
}
