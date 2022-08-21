const { ethers } = require('hardhat')

const verify = async address => {
  console.log('Verifying:', address)
  try {
    await run('verify:verify', {
        address: address
    })
  } catch(error) {
    if(error.message.toLowerCase().includes('already verified')) {
        console.log('Verified:', address)
    } else {
        console.log(error)
    }
  }
}

const main = async () => {

  /**
   * TODO: must set
   * @_launchtime (uint256) | number - Launch time
   * @_usd (address) | string - Address of usd
   */

  const _launchtime = 0
  const _usd = '0x000000...'

  const UXDT = await (await ethers.getContractFactory('DigitalCurrency')).deploy(_launchtime, _usd)

  console.log('DigitalCurrency deployed to:', UXDT.address)
  await verify(UXDT.address)

  console.log('Launch time:', _launchtime)

  console.log('USD:', _usd)

  console.log('Everything is done well!')
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });