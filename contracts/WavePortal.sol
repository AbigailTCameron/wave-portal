// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    
    event NewWave(address indexed from, uint256 timestamp, string message);
    event NewPoke(address indexed from, uint256 timestamp, string message); 

    uint256 private seed;

    struct Wave {
        address waver;      // The address of the user who waved.
        string message;     // The message the user sent.
        uint256 timestamp;  // The timestamp when the user waved.
    }

    struct Poke {
        address poker;      // The address of the user who poked
        string message;     // The message that this poker has sent. 
        uint256 timestamp;  // The timestamp when the user poked. 
    }
   
    Wave[] waves;           // An array of wave structs
    Poke[] pokes;           // An array of poke structs 


    uint256 totalWaves;
    address[] waveAddr;
    // mapping(address => uint) public waves;

    uint256 totalPokes; 
    mapping(address => uint256) public lastPokedAt;
    address[] friendList; 
    // mapping(address => uint) public pokes;
    mapping(address => bool) public friends; 

    modifier onlyFriends {
        require(friends[msg.sender], "Not on the friends' list");
        _;
    }

    constructor() payable {
        console.log("Smart Contract!!!");
        seed = (block.timestamp + block.difficulty) % 100; 
    }

    /**
     @notice Adds a friend to the friends' list  
     @param  friend Address to add to the list
     @return bool 
     */
    function addFriends(address friend) public returns(bool) {
        if(!friends[friend]){
            friendList.push(friend);
        }
        return friends[friend] = true; 
    }

    /**
     @notice Sends a wave and keeps total waves of the contract 
     */
    function wave(string memory message) public {
        totalWaves+= 1; 
        console.log("%s has waved", msg.sender); 

        waves.push(Wave(msg.sender, message, block.timestamp));

        emit NewWave(msg.sender, block.timestamp, message);
    }

    /**
     @notice Returns the number of waves that the recipient has received
     @return uin256 Total waves
     */
    function getTotalWaves() public view returns (uint256){
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    /** 
     @notice Retrieves the struct array of waves which makes it easy to retrieve them on the frontend
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function poke(string memory message) public onlyFriends {
        require(
            lastPokedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 seconds before poking again"
        );

        lastPokedAt[msg.sender] = block.timestamp;

        totalPokes+= 1; 
        console.log("%s has poked you", msg.sender); 

        pokes.push(Poke(msg.sender, message, block.timestamp)); 

        emit NewPoke(msg.sender, block.timestamp, message);

        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        if (seed <= 25) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    /**
     @notice Returns the number of pokes that the recipient has received
     @return uin256 Total pokes
     */
    function getTotalPokes() public view returns (uint256){
        console.log("We have %d total pokes!", totalPokes);
        return totalPokes;
    }

     /** 
     @notice Retrieves the struct array of pokes which makes it easy to retrieve them on the frontend
     */
    function getAllPokes() public view returns (Poke[] memory) {
        return pokes;
    }


    // /**
    //  @notice Sends a poke and keeps total pokes of the contract 
    //  */
    // function poke() public onlyFriends {
    //     totalPokes++; 
    //     console.log("%s has poked you", msg.sender); 

    //     pokes[msg.sender] += 1;
    //     console.log("%s has poked you %d times!", msg.sender, pokes[msg.sender]); 
    // }



    // /**
    //  @notice Adds new waves addresses to our array 
    //  @param  waver     Wave address to be added
    //  @return address[] An array of the address that have waved to the recipient 
    //  */
    // function waveAddresses(address waver) private returns(address[] memory){
    //     waveAddr.push(waver); 
    //     return waveAddr;
    // }

}