// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract UsingMemory {
    function return2and4() external pure returns (uint256, uint256) {
        assembly {
            mstore(0x00, 2)
            mstore(0x20, 4)
            return(0x00, 0x40)
        }
    }

    function requireV1() external view {
        require(msg.sender == 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }

    function requireV2() external view {
        assembly {
            if iszero(eq(caller(), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)) {
                revert(0,0)
            }
        }
    }
}