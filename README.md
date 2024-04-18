# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js --network netWorkName
CONTRACT_ADDRESS="0x2968F0F9250A9f470D866Cf17e8e593bfeFb2827"

npx hardhat verify --network tMorph 0x2968F0F9250A9f470D866Cf17e8e593bfeFb2827 "constructorValue"
```
