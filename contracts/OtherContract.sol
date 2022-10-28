// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/*

    In Yul, there is no 1-to-1 correspondence with tx.data
        tx.data can be arbitrary and only constrained by gas cost
    
    When sending tx.data to a smart contract, 
        the first four bytes specify which function you are calling,
        and the bytes that follow are abi encoded function arguments

    Solidity expects the byutes after the function selector to always be
        a multiple of 32 in length, but this is convention.
    If you send more bytes, solidity will ignore them.
    But a Yul smart contract can be programmed to respond to an 
        arbitrary length tx.data in an arbitrary manner

    Function selectors are the first four bytes of the keccak256 of the function signature
        i.e. balanceOf(address _address) => keccak256("balanceOf(address)") => 0x70a08231
        the txn.data will look like the function selector, concatentated with left padded zeroes + address

    When using an interface in Solidity, the function selector and 32 byte encoded arguments are created under the hood
        but in Yul you have to be ecplicit!
        Yul doesn't know about function selectors, interfaces or abi encoding
            if you want to make an external call to a solidity contract,
            you have to implement all of that yourself
 */

contract OtherContract {
    // "0x55699c": "x()"
    uint256 public x;

    // "71e5ee5f": "arr(uint256"
    uint256[] public arr;

    // "9a884bde": "get21()"
    function get21() external pure returns(uint256) {
        return 21;
    }

    // "73712595": "revertWith999()"
    function revertWith999() external pure returns (uint256) {
        assembly {
            mstore(0x00, 999)
            revert(0x00, 0x20)
        }
    }

    // "4018d9aa": "setX(uint256"
    function setX(uint256 _x) external {
        x = _x;
    }

    // "196e6d84": "multiply(uint128,uint16"
    function multiply(uint128 _x, uint16 _y) external pure returns (uint256) {
        return _x * _y;
    }

    // "0b8fdbff": "variableLength(uint256[]"
    function variableLength(uint256[] calldata data) external {
        arr = data;
    }
}

contract ExternalCalls {

    // get21() 0x9a884bde
    // x() 0c55699c
    function externalViewCallNoArgs(address _a) external view returns (uint256) {
        assembly {
            mstore(0x00, 0x9a884bde)
            // 000000000000000000000000000000000000000000000000000000009a884bde
            //                                                         |        |
            //                                                         28       32
            let success := staticcall(gas(), _a, 28, 32, 0x00, 0x20)
            if iszero(success) {
                revert(0,0)
            }
            return(0x00, 0x20)
        }
    }

    function getViaRevert(address _a) external view returns (uint256) {
        assembly {
            mstore(0x00, 0x73712595)
            pop(staticcall(gas(), _a, 28, 32, 0x00, 0x20)) // When a function reverts or succeeds it will be written to the memory pointer allocated to it, 0x00, 0x20
            return(0x00, 0x20)
        }
    }

    function callMultiply(address _a) external view returns (uint256 result) {
        assembly {
            let mptr := mload(0x40)
            let oldMptr := mptr
            mstore(mptr, 0x196e6d84)
            mstore(add(mptr, 0x20),3)
            mstore(add(mptr, 0x20),11)
            mstore(0x40, add(mptr, 0x60)) // advance the memory pointer 3 x 32 bytes
            // 000000000000000000000000000000000000000000000000000000000196e6d84
            // 00000000000000000000000000000000000000000000000000000000000000003
            // 0000000000000000000000000000000000000000000000000000000000000000b
            let success := staticcall(gas(), _a, add(oldMptr, 28), mload(0x40), 0x00, 0x20)
            if iszero(success) {
                revert(0,0)
            }

            result := mload(0x00)
        }
    }

    function externalStateChangingCall(address _a) external {
        assembly {
            mstore(0x00, 0x4018d9aa)
            mstore(0x20, 999)
            // memory now looks like this
            // 0x0000000000000000000000000000000000000000000000000000000004018d9aa...
            //  000000000000000000000000000000000000000000000000000000000000000009
            let success := call(gas(), _a, callvalue(), 28, add(28, 32), 0x00, 0x00)
            if iszero(success) {
                revert(0,0)
            }
        }
    }
}