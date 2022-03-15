// SPDX-License-Identifier: MIT

//we use this version because after version 0.6,
//The function push(value) for dynamic storage arrays
//does not return the new length anymore (it returns nothing).
pragma solidity >=0.5.0 <0.6.0;

import "./Ownable.sol"

contract ZombieFactory is Ownable {
    uint256 zombieDigit = 16;
    uint256 dnaModulus = 10**16;

    event ZombieCreated(uint256 zombieId, string name, uint256 dna);

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    function _generateRandomDna(string memory _str) private returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function _createZombie(string memory _name, uint256 _dna) internal {
        //minus 1 because function returns length of array and we want to use id
        //for array indexing
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit ZombieCreated(id, _name, _dna);
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randDna = _generateRandomDna(_name);
        createZombie(_name, randDna);
    }
}
