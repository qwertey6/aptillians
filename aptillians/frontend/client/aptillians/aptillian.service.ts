import { AptillianDto, AptillianIdentifierDto } from './aptillian.dto';
import { AccountAddress } from './types';
import { AptosService } from '../aptos/aptos.service';
import { AptosAccount, Types } from 'aptos';

export class AptillianService {
  aptosService: AptosService;

  constructor() {
    this.aptosService = new AptosService();
  }
  /**
   * Gets a single aptillian
   */
  async getAptillian(
    identifier: AptillianIdentifierDto,
  ): Promise<AptillianDto | undefined> {
    // Get all aptillians from the given address
    const allAptillians = await this.getAptillians(identifier.address);
    // Finally, return the one whose ID matches the sent ID.
    return allAptillians.find(
      (aptillian) => aptillian.id === identifier.aptillianId,
    );
  }

  /**
   * Gets multiple aptillians
   * @param address the address of the account to fetch aptillians from
   */
  async getAptillians(address: AccountAddress): Promise<Array<AptillianDto>> {
    let resources = await this.aptosService.client.getAccountResources(address);
    let accountResource = resources.find(
      //TO DO: pull from module
      (r) => r.type === '0xADDRESS::MODULE::RESOURCE',
    );

    //TO DO convert repsonse to AptillianDto array
    console.log(accountResource.data);
    throw new Error('TODO!!');
  }

  async makeAptillian(
    player: AptosAccount,
    name: string,
  ): Promise<Array<AptillianDto>> {
    const payload: Types.TransactionPayload = {
      type: 'script_function_payload',
      function: `${this.aptosService.programAddress}::Aptillian::generate_aptillian`,
      type_arguments: [],
      arguments: [name],
    };
    await this.aptosService.signAndSubmitTxn(player, payload);
    // TODO -- call move API to make new aptillian, and then:
    throw new Error('TODO!!');
    // return this.getAptillians(/** MY ID */);
  }
}
