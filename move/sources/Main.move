module FightClub::Main {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	use FightClub::Types;
  
	public(script) fun generate_aptillian(owner: &signer, name: ASCII::String, type: u64) acquires AptillianStorage {
        FightClub::Aptillian::generate_aptillian(owner: &signer, name: ASCII::String, type: u64);
	}

	public(script) fun challenge(challenger: &signer, challenger_aptillian_id: u64, target: address, target_aptillian_id: ASCII::String) acquires Aptillian, AptillianStorage {
        FightClub::Challenge::challenge(challenger, challenger_aptillian_id, target, target_aptillian_id);
	}

    // TODO (implementer do reject too -- mostly same thing)
    // public(script) fun accept(owner: &signer, aptillian_id: u64) acquires Aptillian, AptillianStorage {
    //     FightClub::Challenge::accept(owner);
    // }

    // TODO (implementer implement accept as well)
    // public(script) fun reject(owner: &signer, aptillian_id: u64) acquires Aptillian, AptillianStorage {
    //     FightClub::Challenge::reject(owner);
    // }

    // TODO 
    // public(script) fun make_turn(owner:&signer, aptillian_id: u64, abilityId: u64, target: address) acquires Aptillian, AptillianStorage {
    //     FightClub::Fight::make_turn(owner, make_turn);
    // }

}