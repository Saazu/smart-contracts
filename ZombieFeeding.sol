pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFactory";

contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract ZombieFeeding {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;

    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
      require(msg.sender = zombieToOwner(_zombieId));
      Zombie storage myZombie = zombies[_zombieId];
      _targetDna = _targetDna % dnaModulus;
      uint newDna = (_targetDna + myZombie.dna) / 2;
      _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId, string _species) {
      uint kittyDna;
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      if (keccak256(abi.encodePacked(_species) == keccak256(abi.encodePacked('kitty')) {
        kittyDna = kittyDna - kittyDna % 100 + 99;
      })
      feedAndMultiply(_zombieId, kittyDna);
    }
}
