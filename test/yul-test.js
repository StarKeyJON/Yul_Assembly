/* eslint-disable node/no-unsupported-features/es-syntax */
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Yul Storage Tests", async function () {
  let storageBasics;
  let storageOffset;
  let storageComplex;

  beforeEach(async () => {
    const StorageBasics = await ethers.getContractFactory("StorageBasics");
    storageBasics = await StorageBasics.deploy();
    await storageBasics.deployed();

    const StorageOffset = await ethers.getContractFactory("StorageOffset");
    storageOffset = await StorageOffset.deploy();
    await storageOffset.deployed();

    const StorageComplex = await ethers.getContractFactory("StorageComplex");
    storageComplex = await StorageComplex.deploy();
    await storageComplex.deployed();
  });

  // Storage Basics contract testing
  it("Should retrieve the correct storage locations for X and Y", async function () {
    expect(await storageBasics.getXSlot()).to.equal(0);
    expect(await storageBasics.getXYul()).to.equal(1);
  });

  it("Should retrieve the value of a given slot using Yul", async function () {
    // Slot 0, first position, x variable
    expect(await storageBasics.getSlotValYul(0)).to.equal(1);
    // Slot 1, second position, y variable
    expect(await storageBasics.getSlotValYul(1)).to.equal(2);
    // Slot 2, third position, z variable
    expect(await storageBasics.getSlotValYul(2)).to.equal(3);
    // Slot 3, fourth position, p variable
    expect(await storageBasics.getSlotValYul(3)).to.equal(0);
    // Slot 4, fifth position, a & b variables
    // the value will be a bigint as there are 2 uint128 variables stored there
    expect(await storageBasics.getSlotValYul(4)).to.equal(
      680564733841876926926749214863536422913n
    );
    // Accessing the bytes of the 4th slot to retrieve the two uint126 bytes
    expect(await storageBasics.getSlotBytes(4)).to.equal(
      "0x0000000000000000000000000000000200000000000000000000000000000001"
    );
  });

  it("Should set new values to given slots using Yul", async function () {
    await storageBasics.setX(1337);
    expect(await storageBasics.getXYul()).to.equal(1337);
    await storageBasics.setP(1337);
    expect(await storageBasics.getP()).to.equal(1337);
    // Writing directly to storage slot for demonstration purposes
    // Never use in development/production!
    await storageBasics.setSlotVarYul(0, 7);
    expect(await storageBasics.getX()).to.equal(7);
  });

  // StorageOffset contract tests
  it("Should read from and write to the offset slot", async function () {
    expect(await storageOffset.readBySlot(0)).to.equal(
      1767062744351721534701654836863616714567074519661780062949099620783882244n
    );
    expect(await storageOffset.getOffsetE()).to.equal(28);
    await storageOffset.writeToE(7);
    expect(await storageOffset.readEalt()).to.equal(7);
  });

  // StorageComplex contract tests
  it("Should ")
});
