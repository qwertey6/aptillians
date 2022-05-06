import { AptillianDto, AptillianIdentifierDto } from './aptillian.dto';
import { AccountAddress } from './types';

export class AptillianService {

  /**
  * Gets a single aptillian
  */
  async getAptillian(identifier: AptillianIdentifierDto): Promise<AptillianDto | undefined> {
    // Get all aptillians from the given address
    const allAptillians = await this.getAptillians(identifier.address);
    // Finally, return the one whose ID matches the sent ID.
    return allAptillians.find(aptillian => aptillian.id === identifier.aptillianId)
  }

  /**
   * Gets multiple aptillians
   * @param address the address of the account to fetch aptillians from
   */
  async getAptillians(address: AccountAddress): Promise<Array<AptillianDto>> {
    throw new Error("TODO!!");
  }

  async makeAptillian(): Promise<Array<AptillianDto>> {
    // TODO -- call move API to make new aptillian, and then:
    throw new Error("TODO!!");
    // return this.getAptillians(/** MY ID */);
  }
}
