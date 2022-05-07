import { HexString } from 'aptos';
import { AccountAddress, AptillianId, ElementEnum } from './types';

export class AptillianIdentifierDto {
  /**
    The address of the account where this challenge is coming from", type:'string
  */
  address: AccountAddress;

  /**
    The aptillian Id that the challenger intends to use for the fight", type:'string
  */
  aptillianId: AptillianId;

  constructor(address: AccountAddress, aptillianId: AptillianId) {
    this.address = address;
    this.aptillianId = aptillianId;
  }
}

export class FightDto {
  // The ID of player 1s Aptillian
  player1: AptillianIdentifierDto;

  // The ID of this Aptillian
  player2: AptillianIdentifierDto;

  /**
    Whose turn it is, 1 for player 1, 2 for player 2
  */
  whoseTurn: number;
  // TODO
  // HP1(V2)
  // HP2 (V2)
  constructor(
    player1: AptillianIdentifierDto,
    player2: AptillianIdentifierDto,
  ) {
    this.player1 = player1;
    this.player2 = player2;
  }
}

export class AptillianDto {
  /**
    The ID of this Aptillian
  */
  id: number = 0;

  /**
    My health at the start of a fight. If it reaches zero, I lose the fight! May increase on wins, decrease on losses
  */
  hp: number = 0;

  /**
    My attack. Used to determine damage to others in fights. May increase on wins, decrease on losses
  */
  attack: number = 0;

  /**
    My defence. Used to determine damage to self in fights. May increase on wins, decrease on losses
  */
  defense: number = 0;
  /**
    My speed. Used to determine who goes first in fights. May increase on wins, decrease on losses
  */
  speed: number = 0;

  /**
    How many fights I've lost
  */
  losses: number = 0;

  /**
    How many fights I've won
  */
  wins: number = 0;

  /**
    My name
  */
  name: String = '';

  /**
    My type", enum:ElementEnum, enumName:'ElementEnum
  */
  type: ElementEnum = null;

  /**
   * What fight I'm in, if I'm in one, otherwise `null`
   */
  fight: FightDto = null;

  /**
   * Any outstanding challenge, or `null` if no challenge
   */
  challenge: AptillianIdentifierDto = null;

  // (v2)
  // Challenges: Array<(Address, AptillianId, GAMES_PLAYED?)>
}
