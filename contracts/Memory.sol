// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Memory {
    struct Point {
        uint256 x;
        uint256 y;
    }

    event MemoryPointer(bytes32);
    event MemoryPointerMsize(bytes32, bytes32);

    // Txn will run out of gas!
    function highAccess() external pure {
        assembly {
            // pop just throws away the return value
            pop(mload(0xffffffffffffffff))
        }
    }

    function memPointer() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function memPointerV2() external {
        bytes32 x40;
        bytes32 _msize;
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);
    }
}