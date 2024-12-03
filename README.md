# Ethereum Will by Arav Bhivgade

# WARNING - GO OVER AUDIT.REMIX.md & AUDIT.SOLIDITYSCAN.md IN THIS AND FIX THE ISSUES IDENTIFIED BY [Remix](https://remix.ethereum.org/) AND [SOLIDITY SCAN](https://solidityscan.com/) RESPECTIVELY WITHIN MY CONTRACT IF YOU PLAN ON USING IT IN PRODUCTION. I AM A BEGINEER AT THIS POINT AND THIS IS A SMALL PROJECT I MADE IN MY WEB3 BOOTCAMP.

## Overview
The `MyWill` contract is a simple Ethereum-based smart contract that allows the contract owner to create a will. The will includes the ability to transfer Ether to an heir after certain conditions are met, such as waiting for one year after the last owner's status update.

## Testing & Deployment 
- Watch this video by EatTheBlocks -> [Testing & Setup](https://youtu.be/yD3BsYlRLA4?si=cY2ozuiCRoOuwTCA)
- Or go to [Remix](https://remix.ethereum.org/) and paste the contract code in a new will.sol file in contracts folder and test it there
- Watch this video by Mehul - Codedamn -> [Deployment](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol)

## Features
- **Ownership Control**: Only the contract owner can change the heir or deposit additional Ether.
- **Heir Transfer**: The designated heir can claim the Ether after one year has passed since the owner's last status update.
- **Price Conversion**: Converts Ether to USD using the Chainlink price feed.
- **Last Ping**: Tracks the last time the owner marked themselves as alive.

## Prerequisites
- **Solidity Version**: `^0.8.20`
- **OpenZeppelin Contracts**: For access control and ownership functionalities.
- **Chainlink Contracts**: For price feed integration.

## Contract Functions

### Constructor
- **`constructor(address _heir)`**: Initializes the contract with the heir's address and accepts initial Ether deposit.

### Public Functions
- **`changeHeir(address _heir)`**: Changes the heir address (only callable by the owner).
- **`iAmAlive()`**: Marks the owner as alive by updating the `lastPing` timestamp (only callable by the owner).
- **`getLastPing()`**: Returns the timestamp of the last time the owner marked themselves as alive.
- **`yearPassed()`**: Checks if one year has passed since the last ping.
- **`deposit()`**: Allows the owner to deposit additional Ether (only callable by the owner).
- **`drain()`**: Transfers the balance of the will to the heir if one year has passed (only callable by the heir).
- **`getDetails()`**: Returns the details of the will (owner, heir, money, last ping, and if a year has passed).

### Private Functions
- **`getLatestPrice()`**: Fetches the current ETH price from the Chainlink price feed.
- **`convertEthToUsd(uint256 ethAmountInWei)`**: Converts an amount of Ether in Wei to USD based on the current ETH price.

## Imports
The contract imports the following external contracts for functionality:
- **Ownable** from [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol) to provide ownership management.
- **AggregatorV3Interface** from [Chainlink](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol) for fetching real-time ETH/USD prices.

## License
This contract is licensed under the MIT License.
