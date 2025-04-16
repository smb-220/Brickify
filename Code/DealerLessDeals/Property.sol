// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Property {
    address public owner;
    uint public deposit;
    uint public rent;
    address public tenant;
    string public house;

    struct LeasePeriod {
        uint fromTimestamp;
        uint toTimestamp;
    }

    enum State { Available, Created, Approved, Started, Terminated }
    State public state;

    LeasePeriod public leasePeriod;

    modifier onlyTenant() {
        require(msg.sender == tenant, "Caller is not the tenant!");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner!");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid contract state!");
        _;
    }

    constructor(address _owner, uint _rent, uint _deposit) {
        owner = _owner;
        rent = _rent;
        deposit = _deposit;
        state = State.Available;
    }

    function isAvailable() public view returns (bool) {
        return (state == State.Available);
    }

    function createTenantRightAgreement(
        address _tenant,
        uint fromTimestamp,
        uint toTimestamp
    ) public inState(State.Available) {
        require(_tenant != address(0), "Invalid tenant address");
        tenant = _tenant;
        leasePeriod = LeasePeriod(fromTimestamp, toTimestamp);
        state = State.Created;
    }

    function setStatusApproved() public onlyOwner inState(State.Created) {
        require(owner != address(0), "Invalid owner address");
        state = State.Approved;
    }

    function confirmAgreement() public onlyTenant inState(State.Approved) {
        state = State.Started;
    }

    function clearTenant() public onlyOwner {
        tenant = address(0);
        state = State.Terminated;
    }
}

