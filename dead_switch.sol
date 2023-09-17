
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public presetBeneficiary;
    uint256 public lastActiveBlock;

    constructor(address _presetBeneficiary) {
        owner = msg.sender;
        presetBeneficiary = _presetBeneficiary;
        lastActiveBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function still_alive() external onlyOwner {
        lastActiveBlock = block.number;
    }

    function checkStatus() external view returns (bool) {
        return (block.number - lastActiveBlock) <= 10;
    }

    function triggerSwitch() external {
        require(block.number - lastActiveBlock > 10, "The owner is still alive.");
        address currentOwner = owner;
        owner = presetBeneficiary;
        presetBeneficiary = address(0); // Prevent the preset beneficiary from claiming the funds
        selfdestruct(payable(currentOwner));
    }
}
