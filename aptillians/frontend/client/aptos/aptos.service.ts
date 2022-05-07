import { AptosClient, AptosAccount, FaucetClient, Types } from 'aptos';
import { AccountAddress } from '../aptillians/types';

const NODE_URL =
  process.env.APTOS_NODE_URL || 'https://fullnode.devnet.aptoslabs.com';
const FAUCET_URL =
  process.env.APTOS_FAUCET_URL || 'https://faucet.devnet.aptoslabs.com';

export class AptosService {
  client: AptosClient;
  faucetClient: FaucetClient;
  //TO DO - address of published module
  programAddress = '0x110E';

  constructor() {
    this.client = new AptosClient(NODE_URL);
    this.faucetClient = new FaucetClient(NODE_URL, FAUCET_URL, null);
  }

  async createPlayer(): Promise<AptosAccount> {
    const newAccount = new AptosAccount();
    await this.faucetClient.fundAccount(newAccount.address(), 5000);
    return newAccount;
  }

  async signAndSubmitTxn(
    player: AptosAccount,
    payload: Types.TransactionPayload,
  ): Promise<boolean> {
    const txnRequest = await this.client.generateTransaction(
      player.address(),
      payload,
    );
    const signedTxn = await this.client.signTransaction(player, txnRequest);
    const transactionRes = await this.client.submitTransaction(
      player,
      signedTxn,
    );
    await this.client.waitForTransaction(transactionRes.hash);
    //TO DO: any value in returning hash?
    return true;
  }
}
