// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./VersionControl.sol";
import "./IdentityManagement.sol";

contract ContributionTracker is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    struct Contribution {
        string ipfsHash;
        uint256 contributorSid;
        string description;
        uint256 timestamp;
        bool verified;
    }

    mapping(string => Contribution) public contributions; // Map ipfsHash to Contribution
    mapping(uint256 => string[]) public contributionsBySid; // Map sid to array of ipfsHashes

    address public versionControlProxy;
    address public identityManagementProxy;

    event ContributionRegistered(
        string ipfsHash,
        uint256 contributorSid,
        string description,
        uint256 timestamp
    );
    event ContributionVerified(string ipfsHash);

    function initialize(
        address initialOwner,
        address versionControlProxyAddress,
        address identityManagementProxyAddress
    ) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        versionControlProxy = versionControlProxyAddress;
        identityManagementProxy = identityManagementProxyAddress;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function registerContribution(
        string memory ipfsHash,
        string memory description
    ) public {
        uint256 contributorSid = IdentityManagement(identityManagementProxy)
            .getSid(msg.sender);
        require(contributorSid != 0, "User not registered");

        require(
            bytes(
                VersionControl(versionControlProxy)
                    .getVersion(ipfsHash)
                    .ipfsHash
            ).length != 0,
            "Version does not exist"
        );

        contributions[ipfsHash] = Contribution({
            ipfsHash: ipfsHash,
            contributorSid: contributorSid,
            description: description,
            timestamp: block.timestamp,
            verified: false
        });

        contributionsBySid[contributorSid].push(ipfsHash);

        emit ContributionRegistered(
            ipfsHash,
            contributorSid,
            description,
            block.timestamp
        );
    }

    function verifyContribution(string memory ipfsHash) public {
        Contribution storage contribution = contributions[ipfsHash];
        require(
            bytes(contribution.ipfsHash).length != 0,
            "Contribution does not exist"
        );
        require(!contribution.verified, "Contribution already verified");

        contribution.verified = true;

        emit ContributionVerified(ipfsHash);
    }

    function getContributionsBySid(
        uint256 sid
    ) public view returns (string[] memory) {
        return contributionsBySid[sid];
    }

    function getContribution(
        string memory ipfsHash
    ) public view returns (Contribution memory) {
        return contributions[ipfsHash];
    }
}
