// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing OpenZeppelin's Ownable contract for ownership control.
import "@openzeppelin/contracts/access/Ownable.sol";

// Importing the Chainlink AggregatorV3Interface for fetching price data.
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// The main contract for creating a will.
contract MyWill is Ownable {

    // Address of the heir who is entitled to receive the funds after conditions are met.
    address public heir;
    // Total amount of Ether stored in the will.
    uint256 public money;
    // Timestamp of the last time the owner marked themselves as 'alive'.
    uint256 public lastPing;
    // Chainlink price feed instance for converting ETH to USD.
    AggregatorV3Interface internal priceFeed;

    // Constructor to initialize the will with the heir's address and initial balance.
    constructor(address _heir) payable Ownable(msg.sender) {
        heir = _heir; // Setting the heir address.
        money += msg.value; // Storing the initial Ether sent to the contract.
        iAmAlive(); // Mark the owner as alive upon contract creation.
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); // Setting the price feed address (e.g., ETH/USD price feed on mainnet).
    }

    // Modifier to restrict access to functions only for the heir.
    modifier onlyHeir() {
        require(msg.sender == heir, "You are not the heir to this will.");
        _;
    }

    // Function to change the heir. Only the contract owner can call this function.
    function changeHeir(address _heir) public onlyOwner {
        heir = _heir; // Updating the heir's address.
        iAmAlive(); // Mark the owner as alive whenever the heir changes.
    }

    // Function to mark the owner as alive by updating the last ping timestamp.
    function iAmAlive() public onlyOwner {
        lastPing = block.timestamp; // Storing the current timestamp.
    }

    // Function to get the last ping timestamp.
    function getLastPing() public view returns(uint256) {
        return lastPing; // Returning the last ping timestamp.
    }

    // Function to check if a year has passed since the last ping.
    function yearPassed() public view returns(bool) {
        return block.timestamp >= lastPing + 365 days; // Returning true if a year has passed.
    }

    // Function to deposit additional Ether into the will. Only the contract owner can call this function.
    function deposit() public payable onlyOwner {
        money += msg.value; // Adding the deposited amount to the total money in the will.
        iAmAlive(); // Mark the owner as alive upon deposit.
    }

    // Function to drain the will's money and send it to the heir. Only the heir can call this function.
    function drain() public onlyHeir {
        require(money > 0, "There's no money in the will."); // Ensure there is money to transfer.
        require(yearPassed() == true, "A year has not passed since the last ping."); // Check if a year has passed.
        payable(heir).transfer(money); // Transferring the money to the heir.
    }

    // Private function to get the latest price of ETH from the price feed.
    function getLatestPrice() private view returns (int256) {
        (
            , // roundId
            int256 price,
            , // startedAt
            , // updatedAt
            // answeredInRound
        ) = priceFeed.latestRoundData();
        return price; // Returning the current ETH price.
    }

    // Private function to convert ETH amount in Wei to USD.
    function convertEthToUsd(uint256 ethAmountInWei) private view returns (uint256) {
        int256 ethPrice = getLatestPrice(); // Getting the current ETH price.
        uint256 ethPriceInUsd = uint256(ethPrice) * 1e10; // Scaling ETH price to 18 decimals.
        uint256 ethAmountInUsd = (ethAmountInWei * ethPriceInUsd) / 1 ether; // Calculating ETH amount in USD.
        return ethAmountInUsd; // Returning the ETH amount in USD.
    }

    // Function to get details about the will, including owner, heir, money, last ping, and whether a year has passed.
    function getDetails() public view returns (address, address, uint256, uint256, bool) {
        return (
            owner(),
            heir,
            money,
            lastPing,
            yearPassed()
        );
    }
}
