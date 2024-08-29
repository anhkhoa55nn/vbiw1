// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract ContributionCounter {
    struct Contribution {
        address contributor;
        uint256 amount;
    }

    address public owner; // owner của contract
    mapping(address => bool) public contributed; // mapping để kiểm tra người dùng đã tham gia chưa
    Contribution[] private contributions; // mảng lưu trữ thông tin của một đóng góp

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function contribute() external payable {
        require(!contributed[msg.sender], "You have already contributed.");
        require(msg.value > 0, "Contribution must be greater than 0.");

        contributed[msg.sender] = true;
        Contribution memory newContribution = Contribution({
            contributor: msg.sender,
            amount: msg.value
        });
        contributions.push(newContribution);
    }

    function getContributions() external view returns (Contribution[] memory) {
        // tạo một biến allContributions có kích thước cố định lưu trữ mảng contributions để có thể return
        Contribution[] memory allContributions = new Contribution[](contributions.length);
        for (uint256 i = 0; i < contributions.length; i++) {
            allContributions[i] = contributions[i];
        }
        return allContributions;
    }

    // thêm hàm rút tiền 
    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "No funds to withdraw.");
        (bool sent, ) = payable(owner).call{value: address(this).balance}("");
        require(sent, "Failed to send funds.");
    }
}
