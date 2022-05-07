import { AptosAccount, Types, HexString } from 'aptos';
import { AptillianIdentifierDto } from '../aptillians/aptillian.dto';
import { AptosService } from '../aptos/aptos.service';
import { AptillianId } from '../aptillians/types';

export class FightService {
  aptosService: AptosService;

  constructor() {
    this.aptosService = new AptosService();
  }

  async makeTurn(
    player: AptosAccount,
    aptillianId: AptillianId,
    abilityId: number,
  ): Promise<void> {
    const payload: Types.TransactionPayload = {
      type: 'script_function_payload',
      function: `${this.aptosService.programAddress}::Aptillian::accept_entry`,
      type_arguments: [],
      arguments: [aptillianId, abilityId],
    };
    await this.aptosService.signAndSubmitTxn(player, payload);
  }
}
