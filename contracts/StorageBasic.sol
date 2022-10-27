// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract StorageBasics {
    uint256 x = 1; // Slot 0
    uint256 y = 2; // Slot 1
    uint256 z = 3; // Slot 2
    uint256 p; // Slot 3
    
    // Variable packing
    //    a & b are stored in the same slot 4
    uint128 a = 1; // Slot 4
    uint128 b = 2; // Slot 4

    // Will return the value of a given slot
    function getSlot() external pure returns(uint256 slot) {
        assembly {
            slot := a.slot
        }
    }

    function getSlotBytes(uint256 slot) external view returns(bytes32 _slot){
        assembly {
            _slot := sload(slot)
        }
    }

    // Will return the slot location of the X variable
    function getXSlot() external pure returns(uint256 ret){
        assembly {
            ret := x.slot
        }
    }

    // Will return the value stored in the X variable slot
    function getXYul() external view returns (uint256 ret){
        assembly {
            ret := sload(x.slot)
        }
    }

    // Will return the value stored in the given slot variable slot
    function getSlotValYul(uint256 _slot) external view returns (uint256 ret){
        assembly {
            ret := sload(_slot)
        }
    }

    function setX(uint256 newVal) external {
        x = newVal;
    }

    function setP(uint256 newVal) external {
        assembly {
            sstore(p.slot, newVal)
        }
    }

    function setVarYul(uint256 newVal) external {
        assembly {
            sstore(y.slot, newVal)
        }
    }

    // Writing to an arbitrary slot is dangerous!!
    // NEVER WRITE TO AN ARBITRARY SLOT IN DEVELOPMENT!
    // For education purposes only
    function setSlotVarYul(uint256 _slot, uint256 newVal) external {
        assembly {
            sstore(_slot, newVal)
        }
    }

    function getX() external view returns (uint256){
        return x;
    }

    function getP() external view returns(uint256 ret) {
        assembly {
            ret := sload(p.slot)
        }
    }
}