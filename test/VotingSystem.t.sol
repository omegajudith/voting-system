// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingSystem.sol";

contract VotingSystemTest is Test {
    VotingSystem votingSystem;
    address owner = address(1);
    address voter1 = address(2);
    address voter2 = address(3);

    function setUp() public {
        vm.prank(owner);
        votingSystem = new VotingSystem();
    }

    function testAddCandidate() public {
        vm.prank(owner);
        votingSystem.addCandidate("Alice");
        (string memory name, uint voteCount) = votingSystem.getCandidate(1);
        assertEq(name, "Alice");
        assertEq(voteCount, 0);
        assertEq(votingSystem.getTotalCandidates(), 1);
    }

    function testFailAddCandidateNonOwner() public {
        vm.prank(voter1);
        votingSystem.addCandidate("Bob"); //this is expected to fail and Should revert
    }

    function testVote() public {
        vm.prank(owner);
        votingSystem.addCandidate("Alice");
        vm.prank(voter1);
        votingSystem.vote(1);
        (string memory name, uint voteCount) = votingSystem.getCandidate(1);
        assertEq(voteCount, 1);
        assertTrue(votingSystem.voters(voter1));
    }

    function testFailDoubleVoting() public {
        vm.prank(owner);
        votingSystem.addCandidate("Alice");
        vm.prank(voter1);
        votingSystem.vote(1);
        vm.prank(voter1);
        votingSystem.vote(1); //same here, it Should revert
    }

    function testFailInvalidCandidate() public {
        vm.prank(voter1);
        votingSystem.vote(999); // about the same,  Should revert
    }
}