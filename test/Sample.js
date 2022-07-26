const { time, loadFixture } = require('@nomicfoundation/hardhat-network-helpers')
const { anyValue } = require('@nomicfoundation/hardhat-chai-matchers/withArgs')
const { expect } = require('chai')

describe('Sample', function () {
  let [admin, address1] = []
  let sample
  let address0 = '0x0000000000000000000000000000000000000000'
  let amountDefault = 100
  let adminBalance = 1000000
  beforeEach(async () => {
    ;[admin, address1] = await ethers.getSigners()
    const Sample = await ethers.getContractFactory('SampleToken')
    sample = await Sample.deploy()
    await sample.deployed()
  })
  describe('#transfer', function () {
    it('revert if receiver is address 0', async function () {
      await expect(sample.transfer(address0, amountDefault)).to.be.revertedWith('ERC20: transfer to the zero address')
    })
    it('revert if amount = 0', async function () {})
    it('revert if balance < amount', async function () {})
    it('transfer successfully', async function () {
      const transferTx = await sample.transfer(address1.address, amountDefault)
      await expect(transferTx).to.be.emit(sample, 'Transfer').withArgs(admin.address, address1.address, amountDefault)
      expect(await sample.balanceOf(admin.address)).to.be.equal(adminBalance - amountDefault)
      expect(await sample.balanceOf(address1.address)).to.be.equal(amountDefault)
    })
  })
  describe('#transferFrom', function () {})
  describe('#approve', function () {})
  describe('#mint', function () {})
  describe('#burn', function () {})
})
