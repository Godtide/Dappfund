export const web3 = uport.getWeb3()

import { Connect, SimpleSigner } from 'uport-connect'
export let uport = new Connect('React Uport Truffle Boilerplate', {
  clientId: '2ohdRCCeNpUpJdPNtggqmSEaxnYmBUuJVkB',
  network: 'rinkeby',
  //signing keys should be kept at .secrets.json
  signer: SimpleSigner('SIGNING KEY')
})
export const web3 = uport.getWeb3()