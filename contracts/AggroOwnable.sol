// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Context} from '@openzeppelin/contracts/utils/Context.sol';

abstract contract AggroOwnable is Context {
    address[] public aggroParty;
    uint256 public looserIndex;

    modifier OnlyAggroOwner() {
        require(aggroParty[looserIndex % aggroParty.length] == _msgSender(), 'AO: fuck yourself');
        _;
        fuckOff();
    }

    constructor () {
        aggroParty.push(_msgSender());
    }


    function initiateParty(address[] memory _aggroParty) OnlyAggroOwner external {
        require(aggroParty.length == 1, 'AO: party is full');
        for (uint256 i = 0; i < _aggroParty.length; ++i) {
            aggroParty.push(_aggroParty[i]);
        }
    }

    function changeMyAddress(address aggroBoss) OnlyAggroOwner external {
        aggroParty[looserIndex % aggroParty.length] = aggroBoss;
    }

    function looser() external view returns(address) {
        return aggroParty[looserIndex % aggroParty.length];
    }

    function fuckOff() private {
        looserIndex++;
    }
}
