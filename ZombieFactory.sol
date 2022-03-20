// SPDX-License-Identifier: MIT

//we use this version because after version 0.6,
//The function push(value) for dynamic storage arrays
//does not return the new length anymore (it returns nothing).
pragma solidity >=0.5.0 <0.6.0;

import "./Ownable.sol";
import "./SafeMath.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract ZombieFactory is Ownable, VRFConsumerBase {
    using SafeMath for uint256;

    uint256 zombieDigit = 16;
    uint256 dnaModulus = 10**16;
    uint256 cooldownTime = 1 days;

    event ZombieCreated(uint256 zombieId, string name, uint256 dna);

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    constructor()
        public
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709 // LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 100000000000000000;
    }

    function _createZombie(string memory _name, uint256 _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        return requestRandomness(keyHash, fee);
    }

    function _createZombie(string memory _name, uint256 _dna) internal {
        //minus 1 because function returns length of array and we want to use id
        //for array indexing
        uint256 id = zombies.push(
            Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)
        ) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit ZombieCreated(id, _name, _dna);
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randomNumber = uint256(getRandomNumber());
        uint256 randDna = randomNumber % dnaModulus;
        createZombie(_name, randDna);
    }
}
