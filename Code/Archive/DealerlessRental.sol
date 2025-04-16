// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DealerlessRental {
    address public deployer;
    address payable public owner; // Property/NFT owner
    address public tenant;
    
    uint public rentAmount;
    uint public rentalStart;
    uint public rentalEnd;
    bool public isRented;
    
    mapping(address => uint) public pendingReturns;

    event RentStarted(address tenant, uint startTime, uint endTime);
    event RentEnded(address tenant);
    event RentWithdrawn(address by, uint amount);

    constructor(address payable _owner) {
        deployer = msg.sender;
        owner = _owner;
    }

    modifier onlyDeployer() {
        require(msg.sender == deployer, "Only deployer allowed");
        _;
    }

    modifier notRented() {
        require(!isRented, "Already rented");
        _;
    }

    modifier rentedOnly() {
        require(isRented, "Not currently rented");
        _;
    }

    function rent(uint durationInDays) external payable notRented {
        require(durationInDays > 0, "Invalid duration");
        require(msg.value > 0, "Rent amount must be greater than zero");

        rentAmount = msg.value;
        rentalStart = block.timestamp;
        rentalEnd = block.timestamp + (durationInDays * 1 days);
        tenant = msg.sender;
        isRented = true;

        emit RentStarted(msg.sender, rentalStart, rentalEnd);
    }

    function endRental() external rentedOnly {
        require(msg.sender == tenant || msg.sender == deployer || block.timestamp >= rentalEnd, "Unauthorized or rental period not over");
        
        // Transfer rent to owner
        pendingReturns[owner] += rentAmount;

        // Reset rental data
        rentAmount = 0;
        rentalStart = 0;
        rentalEnd = 0;
        tenant = address(0);
        isRented = false;

        emit RentEnded(msg.sender);
    }

    function withdrawRent() external {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No amount to withdraw");

        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RentWithdrawn(msg.sender, amount);
    }

    function currentTenant() public view returns (address) {
        return tenant;
    }

    function timeLeft() public view returns (uint) {
        if (block.timestamp >= rentalEnd || !isRented) {
            return 0;
        }
        return rentalEnd - block.timestamp;
    }
}
