// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract VotingSystem is Ownable {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;
    uint public candidateCount;

    event CandidateAdded(uint id, string name);
    event VoteCast(uint candidateId, address voter);

    function addCandidate(string calldata name) external onlyOwner {
        require(bytes(name).length > 0, "Name cannot be empty");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
        emit CandidateAdded(candidateCount, name);
    }

    function vote(uint candidateId) external {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");
        require(!voters[msg.sender], "Already voted");
        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
        emit VoteCast(candidateId, msg.sender);
    }

    function getCandidate(uint candidateId) public view returns (string memory name, uint voteCount) {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[candidateId];
        return (candidate.name, candidate.voteCount);
    }

    function getTotalCandidates() public view returns (uint) {
        return candidateCount;
    }
}