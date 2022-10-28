// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract StorageOffset {
    uint128 public C=4;
    uint96 public D=6;
    uint16 public E=8;
    uint8 public F=1;

    function readBySlot(uint256 _slot) external view returns(uint256 value){
        assembly {
            value := sload(_slot)
        }
    }

    // offset is the offset in bytes within the storage slot according to the encoding
    function getOffsetE() external pure returns(uint256 offset){
        assembly {
            offset := E.offset
        }
    }

    // Shifting is preferred to division as it consumes less gas
    function readE() external view returns(uint16 e){
        assembly {
            let value := sload(E.slot) // must load in 32 byte increments

            // ShiftRight takes a number of bits in as argument, NOT BYTES
            let shifted := shr(mul(E.offset, 8), value)

            // equivalent to 
            // 0x00000000000000000000000000000000000000000000000000000000ffffffff
            // Masking with 1's 0xffffffff
            e := and(0xffff, shifted)
        }
    }

    // Some Yul programs prefer to use division to conduct shifting
    function readEalt() external view returns(uint256 e){
        assembly{
            let slot := sload(E.slot)
            let offset := sload(E.offset)
            let value := sload(E.slot) // must load in 32 byte increments

            // shift right by 224 = divide by (2 ** 224). below is 2 ** 224 in hex
            let shifted := div(value, 0x100000000000000000000000000000000000000000000000000000000)
            e := and(0xffffffff, shifted)

        }
    }

    // Masks can be hardcoded because variable storage slot and offsets are fixed
    // if you take a value V and 'and' it with 00, you're going to get 00
    // V and 00 = 00
    // V and ff = V
    // V or 00 = V
    // FUNCTION ARGUMENTS ARE ALWAYS 32BYTES LONG UNDER THE HOOD!
    function writeToE(uint16 newE) external {
        assembly {
            // newE = 0x00000000000000000000000000000000000000000000000000000000ffffffff
            let c := sload(E.slot) // slot 0
            // c = 0x0001000800000000000000000000000060000000000000000000000000000004
            let clearedE := and(c, 0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffff)
            // mask = 0xffff0000fffffffffffffffffffffffffffffffffffffffffffffffffffffff
            // clearedE = 0x0001000000000000000000000000000060000000000000000000000000000004
            let shiftedNewE := shl(mul(E.offset, 8), newE)
            // shiftedNewE = 0x0000000a00000000000000000000000060000000000000000000000000000000
            let newVal := or(shiftedNewE, clearedE)
            // clearedE = 0x0001000000000000000000000000000060000000000000000000000000000004
            // newVal = 0x0001000a00000000000000000000000060000000000000000000000000000004
            sstore(C.slot, newVal)
        }
    }
}