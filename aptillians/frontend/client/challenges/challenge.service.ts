import { AptosAccount, Types, HexString } from 'aptos';
import { AptillianIdentifierDto } from '../aptillians/aptillian.dto';
import { AptosService } from '../aptos/aptos.service';
import { AptillianId } from '../aptillians/types';

export class ChallengeService {
  aptosService: AptosService;

  constructor() {
    this.aptosService = new AptosService();
  }

  async accept(player: AptosAccount, aptillianID: AptillianId): Promise<void> {
    const payload: Types.TransactionPayload = {
      type: 'script_function_payload',
      function: `${this.aptosService.programAddress}::Aptillian::accept_entry`,
      type_arguments: [],
      arguments: [aptillianID],
    };
    await this.aptosService.signAndSubmitTxn(player, payload);
  }

  async reject(player: AptosAccount, aptillianID: AptillianId): Promise<void> {
    const payload: Types.TransactionPayload = {
      type: 'script_function_payload',
      function: `${this.aptosService.programAddress}::Aptillian::reject_entry`,
      type_arguments: [],
      arguments: [aptillianID],
    };
    await this.aptosService.signAndSubmitTxn(player, payload);
  }

  //this had a string return - what were we expecting to return here?
  async challenge(
    player: AptosAccount,
    challenger_aptillian_id: AptillianId,
    target_address: HexString,
    target_aptillian_id: AptillianId,
  ): Promise<void> {
    const payload: Types.TransactionPayload = {
      type: 'script_function_payload',
      function: `${this.aptosService.programAddress}::Aptillian::challenge_entry`,
      type_arguments: [],
      arguments: [challenger_aptillian_id, target_address, target_aptillian_id],
    };
    await this.aptosService.signAndSubmitTxn(player, payload);
  }
}
