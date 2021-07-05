#!/bin/bash

hardhat verify --network rinkeby "0x88FfA6861A0c268AD4D62456467eb77Ef2A11c50"
hardhat verify --network rinkeby --constructor-args scripts/arguments.js "0x8c69a89E958001711bE1DB94990CEE89DB6b830b"

