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

        }
    }
}

contract ExternalCalls {
    // get21() 0x9a884bde
    // x() 0c55699c
    function externalViewCalNoArgs(address _a) external view returns (uint256) {
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
}