// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract Voting {
    enum VoteStates {Absent, Yes, No}

    struct Proposal {
        address creator;
        string question;
        uint yesCount;
        uint noCount;
        uint numVotes;
        bool isClosed;
        mapping (address => VoteStates) voteStates;
    }

    Proposal[] public proposals;

    function proposalCount() external view returns(uint) {
      return proposals.length;
    }

    event ProposalCreated(uint);
    event VoteCast(uint, address indexed);

    mapping(address => bool) members;

    constructor(address[] memory _members) {
        for(uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        members[msg.sender] = true;
    }

    function newProposal(string calldata _question) external {
        require(members[msg.sender]);
        emit ProposalCreated(proposals.length);
        Proposal storage proposal = proposals.push();
        proposal.creator = msg.sender;
        proposal.question = _question;
        proposal.voteStates[msg.sender] = VoteStates.Yes;
        proposal.yesCount = 1;
    }

    function removeVote(uint _proposalId) external {
        require(members[msg.sender]);
        Proposal storage proposal = proposals[_proposalId];

        if(proposal.voteStates[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
        }
        if(proposal.voteStates[msg.sender] == VoteStates.No) {
            proposal.noCount--;
        }

        proposal.voteStates[msg.sender] = VoteStates.Absent;
        proposal.numVotes--;
    }

    function castVote(uint _proposalId, bool _supports) external {
        require(members[msg.sender]);
        Proposal storage proposal = proposals[_proposalId];

        require(proposal.isClosed == false);

        // clear out previous vote
        if(proposal.voteStates[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
            proposal.numVotes--;
        }
        if(proposal.voteStates[msg.sender] == VoteStates.No) {
            proposal.noCount--;
            proposal.numVotes--;
        }

        // add new vote
        if(_supports) {
            proposal.yesCount++;
        }
        else {
            proposal.noCount++;
        }

        proposal.numVotes++;

        // we're tracking whether or not someone has already voted
        // and we're keeping track as well of what they voted
        proposal.voteStates[msg.sender] = _supports ? VoteStates.Yes : VoteStates.No;
        proposal.isClosed = proposal.numVotes > 5 ? true : false; 

        emit VoteCast(_proposalId, msg.sender);
    }
}
