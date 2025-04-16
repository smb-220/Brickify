// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./DealerlessAuction.sol";
import "./Property.sol";

contract DealerlessMarket is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => DealerlessAuction) public auctions;
    mapping(uint256 => string) private _tokenURIs;

    event LandRegistered(uint256 indexed tokenId, string uri);
    event AuctionCreated(uint256 indexed tokenId, address auction);
    event AuctionEnded(uint256 indexed tokenId, address winner, uint256 price);
    event DelegateEvent(address indexed from, address indexed tenant, uint256 indexed itemId);

    constructor() ERC721("BrickifyMarket", "BRICK") {}

    function registerLand(string memory uri) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _mint(owner(), newTokenId);
        _setTokenURI(newTokenId, uri);
        createAuction(newTokenId);
        
        emit LandRegistered(newTokenId, uri);
        return newTokenId;
    }

    function createAuction(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(address(auctions[tokenId]) == address(0), "Auction already exists");
        
        auctions[tokenId] = new DealerlessAuction(payable(owner()));
        emit AuctionCreated(tokenId, address(auctions[tokenId]));
    }

    function endAuction(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        DealerlessAuction auction = auctions[tokenId];
        
        auction.auctionEnd();
        address winner = auction.highestBidder();
        uint256 winningBid = auction.highestBid();
        
        _transfer(owner(), winner, tokenId);
        emit AuctionEnded(tokenId, winner, winningBid);
    }

    function auctionStatus(uint256 tokenId) public view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return auctions[tokenId].ended();
    }

    function highestBid(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return auctions[tokenId].highestBid();
    }

    function pendingReturn(uint256 tokenId, address bidder) public view returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return auctions[tokenId].pendingReturn(bidder);
    }

    function bid(uint256 tokenId) public payable {
        require(_exists(tokenId), "Token does not exist");
        auctions[tokenId].bid{value: msg.value}(msg.sender);
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId), "URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }
}

contract DealerlessRental {
    DealerlessMarket private _market;
    mapping(uint256 => Property) private _rentalProperties;

    event RentalReady(uint256 indexed itemId, uint256 rent, uint256 deposit);
    event TenantRequested(uint256 indexed itemId, address tenant, uint256 fromTime, uint256 toTime);
    event TenantApproved(uint256 indexed itemId, address tenant);

    constructor(address marketAddress) {
        _market = DealerlessMarket(marketAddress);
    }

    function getRental(uint256 itemId) public view returns (Property) {
        return _rentalProperties[itemId];
    }

    function readyToRent(uint256 itemId, uint256 rent, uint256 deposit) public {
        require(_market.ownerOf(itemId) == msg.sender, "Only owner can list for rent");
        _rentalProperties[itemId] = new Property(msg.sender, rent, deposit);
        emit RentalReady(itemId, rent, deposit);
    }

    function requestForTenantRight(uint256 itemId, uint256 fromTime, uint256 toTime) public {
        require(_market.ownerOf(itemId) != msg.sender, "Owner cannot be tenant");
        require(address(_rentalProperties[itemId]) != address(0), "Property not available for rent");
        require(_rentalProperties[itemId].isAvailable(), "Property already rented");
        
        _rentalProperties[itemId].createTenantRightAgreement(msg.sender, fromTime, toTime);
        emit TenantRequested(itemId, msg.sender, fromTime, toTime);
    }

    function approveTenantRight(address tenant, uint256 itemId) public onlyOwner(itemId) returns (bool) {
        require(_rentalProperties[itemId].tenant() == tenant, "No request from this tenant");
        
        (bool success, ) = address(_market).call(
            abi.encodeWithSignature("approveTenantRight(address,uint256)", tenant, itemId)
        );
        
        if (success) {
            _rentalProperties[itemId].setStatusApproved();
            emit TenantApproved(itemId, tenant);
        }
        
        return success;
    }

    function setTenantRight(uint256 itemId) public returns (bool) {
        (bool success, ) = address(_market).call(
            abi.encodeWithSignature("setTenantRight(uint256)", itemId)
        );
        
        if (success) {
            _rentalProperties[itemId].confirmAgreement();
        }
        
        return success;
    }

    modifier onlyOwner(uint256 tokenId) {
        require(_market.ownerOf(tokenId) == msg.sender, "Only property owner");
        _;
    }
}