// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Crowdfunding {
    address private Owner;
    address payable private ownerWallet;
    uint256 Goal;
    bool IsActive;
    uint256 currentFunded;

    event fundEvent(address depositor, uint256 amount);

    event changeStatusEvent(bool status);

    constructor(uint256 _Goal) {
        Owner = msg.sender;
        ownerWallet = payable(msg.sender);
        Goal = _Goal;
        IsActive = true;
        currentFunded = 0;
    }

    function viewGoal() public view returns (uint256) {
        return Goal;
    }

    function viewStatus() public view returns (bool) {
        return IsActive;
    }

    function totalFunded() public view returns (uint256) {
        return currentFunded;
    }

    function fund(uint256 _amount) public payable notOwner {
        require(IsActive, "El proyecto ya no recibe aportes.");
        require(msg.value > uint256(0), "Debes enviar una cantidad mayor.");
        require(currentFunded + _amount <= Goal, "Tu aporte excede el Goal.");
        currentFunded += _amount;
        emit fundEvent(msg.sender, _amount);
        ownerWallet.transfer(msg.value);
    }

    function changeStatus() public onlyOwner {
        IsActive = !IsActive;
        emit changeStatusEvent(IsActive);
    }

    modifier onlyOwner() {
        require(msg.sender == Owner, "Solo el Owner tiene permisos.");
        _;
    }

    modifier notOwner() {
        require(msg.sender != Owner, "El Owner no tiene permisos.");
        _;
    }
}
