// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Context} from '@openzeppelin/contracts/utils/Context.sol';

abstract contract AggrOwnable is Context {
    address[] public aggrParty;
    uint256 public looserIndex;

    modifier OnlyAggrOwner() {
        require(aggrParty[looserIndex % aggrParty.length] == _msgSender(), 'AO: fuck yourself');
        _;
        fuckOff();
    }

    constructor () {
        aggrParty.push(_msgSender());
    }


    function initiateParty(address[] memory _aggrParty) OnlyAggrOwner external {
        require(aggrParty.length == 1, 'AO: party is full');
        for (uint256 i = 0; i < _aggrParty.length; ++i) {
            aggrParty.push(_aggrParty[i]);
        }
    }

    function changeMyAddress(address aggrBoss) OnlyAggrOwner external {
        aggrParty[looserIndex % aggrParty.length] = aggrBoss;
    }

    function looser() external view returns(address) {
        return aggrParty[looserIndex % aggrParty.length];
    }

    function fuckOff() private {
        looserIndex++;
    }
}
