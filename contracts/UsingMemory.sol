// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract UsingMemory {
    function return2and4() external pure returns (uint256, uint256) {
        assembly {
            mstore(0x00, 2)
            mstore(0x20, 4)
            return(0x00, 0x40) // Return is a function inside of Yul, not a specific keyword
        }
    }

    function requireV1() external view {
        require(msg.sender == 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }

    // When you want to return, you have to declare the area in memory to return
    function requireV2() external view {
        assembly {
            if iszero(eq(caller(), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)) {
                revert(0,0)
            }
        }
    }

    // In regular solidity keccak256 takes a variable that is of bytes memory
    function hashV1() external pure returns(bytes32){
        bytes memory toBeHashed = abi.encode(1,2,3); // Note this is explicitly declared in Memory
        return keccak256(toBeHashed); // If abi.encode is declared in keccak256 it is the same as loading in memory as above, just obscured
    }

    function hashV2() external pure returns (bytes32) {
        assembly {
            let freeMemoryPointer := mload(0x40)

            // store 1, 2, 3 in memory
            mstore(freeMemoryPointer, 1)
            mstore(add(freeMemoryPointer, 0x20), 2)
            mstore(add(freeMemoryPointer, 0x40), 3)

            // update memory pointer
            mstore(0x40, add(freeMemoryPointer, 0x60)) // increase memory pointer by 32 bytes

            mstore(0x00, keccak256(freeMemoryPointer, 0x60))
            return(0x00, 0x20)
        }
    }
}