// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract VersionControl is Initializable {
    struct Version {
        string ipfsHash;
        string description;
        uint256 timestamp;
    }

    mapping(string => Version) public versions;
    string[] public versionHashes;

    event VersionCreated(
        string ipfsHash,
        string description,
        uint256 timestamp
    );

    function initialize() public initializer {
        
    }

    function createVersion(
        string memory ipfsHash,
        string memory description
    ) public {
        require(
            bytes(versions[ipfsHash].ipfsHash).length == 0,
            "Version with this IPFS hash already exists"
        );

        versions[ipfsHash] = Version({
            ipfsHash: ipfsHash,
            description: description,
            timestamp: block.timestamp
        });

        versionHashes.push(ipfsHash);

        emit VersionCreated(ipfsHash, description, block.timestamp);
    }

    function getVersion(
        string memory ipfsHash
    ) public view returns (Version memory) {
        return versions[ipfsHash];
    }

    function getAllVersionHashes() public view returns (string[] memory) {
        return versionHashes;
    }
}
