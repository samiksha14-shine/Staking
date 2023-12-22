// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingContract {
    address public owner;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewardsBalance;
    uint256 public totalStaked;
    uint256 public totalRewards;

    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);
    event RewardClaimed(address indexed staker, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Stake amount must be greater than zero");
        stakedBalance[msg.sender] += amount;
        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0 && amount <= stakedBalance[msg.sender], "Invalid unstake amount");
        stakedBalance[msg.sender] -= amount;
        totalStaked -= amount;
        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender);
        rewardsBalance[msg.sender] += rewards;
        totalRewards += rewards;
        emit RewardClaimed(msg.sender, rewards);
    }

    function calculateRewards(address staker) internal view returns (uint256) {
        // Basic reward calculation logic (you can replace this with a more sophisticated algorithm)
        return (stakedBalance[staker] * 5) / 100; // 5% annual reward
    }

    function withdrawRewards() external {
        require(rewardsBalance[msg.sender] > 0, "No rewards to withdraw");
        uint256 amount = rewardsBalance[msg.sender];
        rewardsBalance[msg.sender] = 0;
        totalRewards -= amount;
        // Additional logic for transferring rewards to the staker's wallet
        // For simplicity, we'll just log the event here
        emit RewardClaimed(msg.sender, amount);
    }

}
