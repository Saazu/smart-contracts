// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFeeding";

contract ZombieHelper is ZombieFeeding {
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }
}
