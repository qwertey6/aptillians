module FightClub::Challenge {
    use Std::Signer;
	use Std::Vector;
	//use Std::ASCII;
	use FightClub::Types;
	use AptosFramework::Table;

	const ENO_APTILLIAN: u64 = 0;
	const ENO_CHALLENGE: u64 = 1;

	public(script) fun challenge(challenger: &signer, challenger_aptillian_id: u64, target: address, target_aptillian_id:u64) {
		let challenger_addr = Signer::address_of(challenger);
		let challenge = Types::make_aptillian_identifier(challenger_addr, challenger_aptillian_id);
		// assert exists first
		let target_apt_storage = borrow_global_mut<Types::AptillianStorage>(target);

		let target_apt = Table::borrow_mut(target_apt_storage.map, target_aptillian_id);
		Vector::push_back(&mut target_apt.challenges, challenge);
	}

    #[test(fighter = @0x1, target = @0x2)]
    public(script) fun pick_a_fight(fighter: signer, target: signer) acquires Aptillian {
		let fighter_addr = Signer::address_of(&fighter);
		generate_aptillian(&fighter, ASCII::string(b"the fighter"), 1);
		assert!(exists<AptillianStorage>(fighter_addr), ENO_APTILLIAN);
		assert!(exists<Aptillian>(fighter_addr), ENO_APTILLIAN);
		let fighter_table = borrow_global_mut<AptillianStorage>(fighter_addr).map;
		let fighter = Table::borrow_mut(fighter_table, 0);
		
		
		let target_addr = Signer::address_of(&target);
		assert!(exists<AptillianStorage>(target_addr), ENO_APTILLIAN);
		assert!(exists<Aptillian>(target_addr), ENO_APTILLIAN);
		let target_table = borrow_global_mut<AptillianStorage>(target_addr).map;
		let target = Table::borrow_mut(target_table, 0);

		challenge(&fighter, 0, target_addr, 0);

		assert!(Vector::length(target.challenge), ENO_CHALLENGE);
	}
}