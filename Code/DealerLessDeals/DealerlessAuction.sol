// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DealerlessAuction {
    address public deployer;
    address payable public beneficiary;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) private pendingReturns;

    bool public ended;

    event HighestBidIncreased(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(address payable _beneficiary) {
        deployer = msg.sender;
        beneficiary = _beneficiary;
    }

    /// Bid on the auction. Overbid will be refunded.
    function bid() external payable {
        require(!ended, "Auction already ended");
        require(msg.value > highestBid, "There already is a higher or equal bid");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw your overbid funds
    function withdraw() external returns (bool) {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");

        // Zero out before transfer to avoid reentrancy
        pendingReturns[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            // Restore on failure
            pendingReturns[msg.sender] = amount;
            return false;
        }

        return true;
    }

    /// View your pending returns
    function pendingReturn(address bidder) external view returns (uint) {
        return pendingReturns[bidder];
    }

    /// End the auction, transfer the highest bid to the beneficiary
    function auctionEnd() external {
        require(!ended, "Auction end already called");
        require(msg.sender == deployer, "Only deployer can end auction");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        (bool success, ) = beneficiary.call{value: highestBid}("");
        require(success, "Transfer to beneficiary failed");
    }
}
