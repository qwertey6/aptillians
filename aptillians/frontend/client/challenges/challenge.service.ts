import { AptosAccount, Types } from 'aptos';
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
      function: `${this.aptosService.programAddress}::Aptillian::accept`,
      type_arguments: [],
      arguments: [aptillianID],
    };
    await this.aptosService.signAndSubmitTxn(player, payload);
  }

  async reject(): Promise<void> {
    throw new Error('TODO!!');
  }

  async challenge(identifier: AptillianIdentifierDto): Promise<string> {
    throw new Error('TODO!!');
  }
}
