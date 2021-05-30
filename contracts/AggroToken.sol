// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract AggroToken is ERC20 {
    constructor() ERC20('Maximum AGGRessive token', 'AGGRO') {
        uint256 totalSupply = 987654321000 * 10**13;
        _mint(msg.sender, totalSupply);
    }

    function decimals() public view override returns (uint8) {
        return 13;
    }
}
