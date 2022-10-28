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

    // Load the free memory pointer location
    function memPointer() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    // Load the free memory pointer location and the size
    function memPointerV2() external {
        bytes32 x40;
        bytes32 _msize;
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);

        Point memory p = Point({x:1,y:2});
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);

        assembly {
            pop(mload(0xff))
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);
    }

    function fixedArray() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        uint256[2] memory arr = [uint256(5), uint256(6)];
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    // Solidity uses memory for 
    //    abi.encode and abi.encodePacked
    //      Structs and arrays( but you explicitly need the memory keyword)
    //      when structs or arrays are declared memory in function arguments
    //      because objects in memory are laid out end to end, arrays have no push unlike storage

    // In Yul
    //      the variable itself is where it begins in memory
    //      to access a dynamic array, you have to add 32 bytes or 0x20 to skip length
    function abiEncode() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncode2() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncodePacked() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encodePacked(uint256(5), uint256(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }
        event Debug(bytes32, bytes32, bytes32, bytes32);
        function args(uint256[] memory arr) external {
            bytes32 location;
            bytes32 len;
            bytes32 valueAtIndex0;
            bytes32 valueAtIndex1;
            assembly {
                location := arr
                len := mload(arr)
                valueAtIndex0 := mload(add(arr, 0x20))
                valueAtIndex1 := mload(add(arr, 0x40))
                // ...
            }
            emit Debug(location, len, valueAtIndex0, valueAtIndex1);
        }

        // If you don't respect solidity's memory layout and free memory pointer,
        //  you can get some serious bugs!
        // Below, foo is assigned to the free memory pointer location
        //  then, bar is written to the same location overriding foo
        //  and bar is returned in the new memory pointer location instead of foo
        function breakFreeMemoryPointer(uint256[1] memory foo) external pure returns(uint256){
            assembly {
                mstore(0x40, 0x80)
            }
            uint256[1] memory bar = [uint256(6)];
            return foo[0];
        }


        // The Solidity compiler memory does not try to pack datatypes smaller than 32 bytes
        // If you load from storage to memory, it will be unpacked
        uint8[] foo =[1,2,3,4,5,6]; // All of these will be kept in 1 32 byte slot
        function unpacked() external {
            uint8[] memory bar = foo;
        }
}