// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Log {

    // under the hood, event types are 32byte types
    event SomeLog(uint256 indexed a, uint256 indexed b);
    event SomeLogV2(uint256 indexed a, bool);

    function emitLog()external {
        emit SomeLog(5, 6);
    }

    function yulEmitLog() external {
        assembly {
            // keccak256("SomeLog(uint256,uint256)")
            let signature := 0xc200138117cf199dd335a2c6079a6e1be01e6592b6a76d4b5fc31b169df819cc // keccak256 of the event signature
            log3(0, 0, signature, 5, 6) // the first 0, 0 is memory pointer
        }
    }

    function v2EmitLog() external {
        emit SomeLogV2(5, true);
    }

    // for a non-indexed event jargument, you have to load it into memory and declare it on the left hand of the log2
    function v2YulEmitLog() external {
        assembly {
            // keccak256("SomeLog(uint256,uint256)")
            let signature := 0xc200138117cf199dd335a2c6079a6e1be01e6592b6a76d4b5fc31b169df819cc // keccak256 of the event signature
            mstore(0x00, 1) // Load 1, which corresponds to true
            log2(0, 0x20, signature, 5) // the first 0, 0x20 is pointing to the true in memory
        }
    }

    // This contract must be tested on the testnet, so clean up after testing!
    function boom() external {
        assembly {
            selfdestruct(caller())
        }
    }
}