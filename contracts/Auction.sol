// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Auction  {

    struct Auction {
        uint256 id;
        uint256 itemId;
        address creator;
        uint256 minBid;
        uint256 deadline;
        uint256 highestBid;
        address highestBidder;
        bool finalized;
        bool deleted;
    }

    
}


