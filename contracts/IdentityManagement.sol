// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract IdentityManagement is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    mapping(address => uint256) private addressToSid;
    mapping(uint256 => address) private sidToAddress;
    uint256 private nextSid;

    event SidRegistered(address indexed userAddress, uint256 sid);
    event SidTransferred(uint256 indexed sid, address indexed oldAddress, address indexed newAddress);

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        nextSid = 1; // Start SIDs from 1
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function register() public {
        require(addressToSid[msg.sender] == 0, "User already registered");
        uint256 sid = nextSid++;
        addressToSid[msg.sender] = sid;
        sidToAddress[sid] = msg.sender;
        emit SidRegistered(msg.sender, sid);
    }

    function transferSid(address newAddress) public {
        uint256 sid = addressToSid[msg.sender];
        require(sid != 0, "User not registered");
        require(addressToSid[newAddress] == 0, "New address already registered");
        addressToSid[newAddress] = sid;
        sidToAddress[sid] = newAddress;
        delete addressToSid[msg.sender];
        emit SidTransferred(sid, msg.sender, newAddress);
    }

    function getSid(address userAddress) public view returns (uint256) {
        return addressToSid[userAddress];
    }

    function getAddress(uint256 sid) public view returns (address) {
        return sidToAddress[sid];
    }
}
