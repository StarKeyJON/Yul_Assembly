// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract StorageComplex {
    uint256[3] fixedArray;
    uint256[] bigArray;
    uint8[] smolArray;

    mapping(uint256 => uint256) public myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;
    mapping(address => uint256[]) public addressToList;

    constructor() {
        fixedArray = [99, 999, 9999];
        bigArray = [10,20,30];
        smolArray = [1,2,3];

        myMapping[10] = 5;
        myMapping[11] = 6;
        nestedMapping[2][4] = 7;

        addressToList[0x25870DC5Db82A07dCdfA24aB899eD768a218AdaC] = [42, 1337, 777];
    }

    // Load the fixed array slot and the desired index to pull the values
    function fixedArrayView(uint256 index) external view returns (uint256 ret) {
        assembly {
            ret := sload(add(fixedArray.slot, index))
        }
    }

    // Arrays with dynamic length are not stored sequentially
    // Solidity takes the slot the array is, then take the keccak256 to get the location
    function bigArrayLength() external view returns (uint256 ret) {
        assembly {
            ret := sload(bigArray.slot)
        }
    }
    
    function readBigArrayLocation(uint256 index) external view returns (uint256 ret){
        uint256 slot;
        assembly {
            slot := bigArray.slot
        }
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))
        }
    }
}