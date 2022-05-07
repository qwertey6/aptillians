module FightClub::Aptillian {
	use AptosFramework::Timestamp;
	use Std::ASCII;
	use Std::BCS;
	use Std::Hash;
	use Std::Table::{Self, Table};
	use Std::Vector::{Self};
	use Std::Signer;

    struct AptillianIdentifier has store, drop {
        owner: address,
		aptillian_id: u64
    }
	struct Fight has store, drop {
		challenger: AptillianIdentifier,
		challenger_damage: u64,
		target: AptillianIdentifier,
		target_damage: u64,
	}

    struct AptillianStorage has key {
        map: Table<u64, Aptillian>,
        insertions: u64,
    }  

	struct Aptillian has store, drop {
		// aptillian_id: u64,
		name: ASCII::String,
		type: u64,
		losses: u64,
		wins: u64,
        // STATS vv
        // These change after winning/losing, and are /used to calculate damage/
		hp: u64,
		attack: u64,
		defense: u64,
		speed: u64,
		
		// Used to ensure aptillian doesn't level between challenge and fight times.
		games_played: u64,
        // Who I'm fighting right now, or `[]`
		versus: vector<AptillianIdentifier>,
        fights: vector<Fight>,
		challenges: vector<AptillianIdentifier>,
	}

	public (script) fun generate_aptillian_entry(owner: &signer, name: ASCII::String) acquires AptillianStorage {
        generate_aptillian(owner, name);
	}

	public (script) fun challenge_entry(challenger: &signer, challenger_aptillian_id: u64, target: address, target_aptillian_id: u64) acquires AptillianStorage {
        challenge(challenger, challenger_aptillian_id, target, target_aptillian_id);
	}

    public(script) fun accept_entry(owner: &signer, aptillian_id: u64) acquires AptillianStorage {
        accept(owner, aptillian_id);
    }

    public(script) fun reject_entry(owner: &signer, aptillian_id: u64) acquires AptillianStorage {
        reject(owner, aptillian_id);
    }
		
    public(script) fun take_turn_entry(owner:&signer, aptillian_id: u64, ability_id: u64) acquires AptillianStorage {
        take_turn(owner, aptillian_id, ability_id);
    }

	const ENO_APTILLIAN: u64 = 0;
	const ENO_CHALLENGE: u64 = 1;

	public fun make_aptillian(): Aptillian{
		let losses = 0;
		let wins = 0;
		let type = 0;
		let type_val = random(999)%4;

		while(type_val > 0){ // ridiculous integer promotion
			type = type + 1;
			type_val = type_val - 1;
		};
		let name = ASCII::string(b"Satoshi-nakamotomon");
		let hp = 10;
		let games_played = 0;
		let remaining = 10;
		let idx = 0;
		let stats = Vector::empty<u64>();
		Vector::push_back(&mut stats, 0);
		Vector::push_back(&mut stats, 0);
		Vector::push_back(&mut stats, 0);
		let stat = Vector::borrow_mut(&mut stats, idx);
		
		loop {

			if (remaining == 1) {
				*stat = *stat + 1;
			} else if (remaining == 0) {
				 break
			} else {
				*stat = 1 + *stat + (if ((random(idx) % 2) == 0) 1 else 0);
			};
			idx = (idx + 1) % 3;
			stat = Vector::borrow_mut(&mut stats, idx);
			
		};
		let attack = *Vector::borrow<u64>(&stats, 0);
		let defense = *Vector::borrow<u64>(&stats, 1);
		let speed = *Vector::borrow<u64>(&stats, 2);
		
		let versus = Vector::empty<AptillianIdentifier>();
		let fights = Vector::empty<Fight>();
		let challenges = Vector::empty<AptillianIdentifier>();
		
		return Aptillian {
				name,
				type,
				losses,
				wins,
				hp,
				attack,
				defense,
				speed,
				games_played,
				versus,
				fights,
				challenges,
			}
	}
	
	public fun make_aptillian_identifier(owner:address, aptillian_id: u64): AptillianIdentifier{
		AptillianIdentifier {owner, aptillian_id}
	}
    
	public fun make_fight(challenger: AptillianIdentifier, target: AptillianIdentifier): Fight{
		Fight {challenger, challenger_damage:0, target, target_damage:0}
		
	}

	public fun make_aptillian_storage(): AptillianStorage{
		AptillianStorage {map: Table::new<u64, Aptillian>(), insertions: 0}
	}

	public fun challenge(challenger: &signer, challenger_aptillian_id: u64, target: address, target_aptillian_id:u64) acquires AptillianStorage {
		let challenger_addr = Signer::address_of(challenger);
		let challenge = make_aptillian_identifier(challenger_addr, challenger_aptillian_id);
		// assert exists first
		let target_apt_storage = borrow_global_mut<AptillianStorage>(target);

		let target_apt = Table::borrow_mut(&mut (target_apt_storage.map), &target_aptillian_id);
		Vector::push_back(&mut (target_apt.challenges), challenge);
	}

    #[test(fighter = @0x1, target = @0x2)]
    public(script) fun pick_a_fight(fighter: signer, target: signer) acquires Aptillian {
		let fighter_addr = Signer::address_of(&fighter);
		generate_aptillian(&fighter, ASCII::string(b"the fighter"));
		assert!(exists<AptillianStorage>(fighter_addr), ENO_APTILLIAN);
		assert!(exists<Aptillian>(fighter_addr), ENO_APTILLIAN);
		let fighter_table = borrow_global_mut<AptillianStorage>(&fighter_addr).map;
		let fighter = Table::borrow_mut(&mut fighter_table, 0);
		
		
		let target_addr = Signer::address_of(&target);
		generate_aptillian(&target, ASCII::string(b"the fighted"));
		assert!(exists<AptillianStorage>(target_addr), ENO_APTILLIAN);
		assert!(exists<Aptillian>(target_addr), ENO_APTILLIAN);
		let target_table = borrow_global_mut<AptillianStorage>(target_addr).map;
		let target = Table::borrow_mut<Table, u64>(&mut target_table, 0);

		challenge(&fighter, 0, target_addr, 0);

		assert!(Vector::length(target.challenges), ENO_CHALLENGE);
	}

	public fun get_fight(aptillian: &mut Aptillian): &mut Fight acquires AptillianStorage{
		// Returns the fight this aptillian is in
		if(Vector::length<Fight>(&aptillian.fights) == 1){
			return Vector::borrow_mut(&mut aptillian.fights, 0)
		} else {
			let challenger_identifier = Vector::borrow_mut<AptillianIdentifier>(&mut aptillian.versus, 0);
			let challenger_addr = challenger_identifier.owner;
			let challenger_apt_storage = borrow_global_mut<AptillianStorage>(challenger_addr);
			
			let challenger_apt = Table::borrow_mut(&mut (challenger_apt_storage.map), &challenger_identifier.aptillian_id);
			
			return Vector::borrow_mut<Fight>(&mut challenger_apt.fights, 0)
		}
	}

	
	public fun get_aptillian(ident: &AptillianIdentifier): &mut Aptillian acquires AptillianStorage {
		let apt_storage = borrow_global_mut<AptillianStorage>(ident.owner);
		Table::borrow_mut<u64, Aptillian>(&mut (apt_storage.map), &ident.aptillian_id)
	}

	public fun clear_game_state(aptillian: &mut Aptillian) {
		// Clears all challenges, versus, and fights.
		// This is the last function to be called after finishing a game.
		while (Vector::length<AptillianIdentifier>(&aptillian.challenges) > 0){
			Vector::pop_back<AptillianIdentifier>(&mut aptillian.challenges);
		};
		while (Vector::length<AptillianIdentifier>(&aptillian.versus) > 0){
			Vector::pop_back<AptillianIdentifier>(&mut aptillian.versus);
		};
		while (Vector::length<Fight>(&aptillian.fights) > 0){
			Vector::pop_back<Fight>(&mut aptillian.fights);
		};
	}

	public fun calc_victory(aptillian: &mut Aptillian) {
		let whichstat = random(aptillian.games_played)%3;
		if(whichstat == 0){
			aptillian.speed = aptillian.speed + 1;
		} else if (whichstat == 1){
			aptillian.attack = aptillian.attack + 1;
		} else if (whichstat == 2){
			aptillian.defense = aptillian.defense + 1;
		};
		aptillian.games_played = aptillian.games_played + 1;
		aptillian.wins = aptillian.wins + 1;

	}
	
	public fun calc_defeat(aptillian: &mut Aptillian) {
		let whichstat = random(aptillian.games_played)%3;
		if(whichstat == 0){
			aptillian.speed = aptillian.speed - 1;
		} else if (whichstat == 1){
			aptillian.attack = aptillian.attack - 1;
		} else if (whichstat == 2){
			aptillian.defense = aptillian.defense - 1;
		};
		aptillian.games_played = aptillian.games_played + 1;
		aptillian.losses = aptillian.losses + 1;
	}

    public(script) fun take_turn(owner:&signer, aptillian_id: u64, ability_id: u64) acquires AptillianStorage {
		let owner_addr = Signer::address_of(owner);
		let owner_apt = get_aptillian(&make_aptillian_identifier(owner_addr, aptillian_id));
		let fight = get_fight(owner_apt);
		
		let damage = (random(owner_apt.games_played) as u64);
		if(fight.challenger.owner == owner_addr){
			// We add 1 to the damage to ensure that after a turn is taken,
			// damage > 0, as we check ""truthiness"" later 
			fight.challenger_damage = damage+1;
		} else {
			// We add 1 to the damage to ensure that after a turn is taken,
			// damage > 0, as we check ""truthiness"" later 
			fight.target_damage = damage+1;
		};
		
		let challenger_apt = get_aptillian(&fight.challenger);
		let target_apt = get_aptillian(&fight.challenger);

		// If the fight is over, then determine winner/loser and change stats accordingly.
		if (fight.challenger_damage > 0 && fight.target_damage > 0) {
			if (fight.challenger_damage > fight.target_damage) {
				// Challenger wins
				calc_victory(challenger_apt);
				if (target_apt.wins - target_apt.losses == 0){
					// DESTROYED!! Remove the Aptillian from the loser's storage, never to be seen again.
					Table::remove(&mut borrow_global_mut<AptillianStorage>(fight.target.owner).map, &fight.target.aptillian_id);
				} else {
					calc_defeat(target_apt);
				};
			} else {
				// Target wins, or tie (tie == target wins for v1).
				calc_victory(target_apt);
				if (challenger_apt.wins - challenger_apt.losses == 0){
					// DESTROYED!! Remove the Aptillian from the loser's storage, never to be seen again.
					Table::remove<u64, Aptillian>(&mut borrow_global_mut<AptillianStorage>(fight.challenger.owner).map, &fight.challenger.aptillian_id);
				} else {
					calc_defeat(challenger_apt);
				};
			};
			// TODO -- FIXME if this causes errors (in case the loser was deleted), then move this into conditionals
			clear_game_state(challenger_apt);
			clear_game_state(target_apt);
		} else {
			/* The fight is still going on in this case. Nothing to do (?)*/
		};
    }

	public fun accept(owner: &signer, aptillian_id: u64) acquires AptillianStorage {
		let owner_addr = Signer::address_of(owner);
		let owner_apt_storage = borrow_global_mut<AptillianStorage>(owner_addr);
		let owner_apt = Table::borrow_mut(&mut owner_apt_storage.map, &aptillian_id);
		
		// remove the challenge from the list of challenges
		let challenger_identifier = Vector::pop_back<AptillianIdentifier>(&mut owner_apt.challenges);
	
		let challenger_addr = challenger_identifier.owner;
		let challenger_apt_storage = borrow_global_mut<AptillianStorage>(challenger_addr);
		let challenger_apt = Table::borrow_mut(&mut (challenger_apt_storage.map), &aptillian_id);
		
		let owner_identifier = make_aptillian_identifier(owner_addr, aptillian_id);
		let fight = make_fight( challenger_identifier, owner_identifier);
		owner_apt.versus = owner_identifier;
		
		// The `fight` lives on the challenger, as this simplifies interactions later on.
		Vector::push_back<Fight>(&mut challenger_apt.fights, fight);
		
		while (Vector::length<AptillianIdentifier>(&owner_apt.challenges) > 0){
			Vector::pop_back<AptillianIdentifier>(&mut owner_apt.challenges);
		};
		while (Vector::length<AptillianIdentifier>(&challenger_apt.challenges) > 0){
			Vector::pop_back<AptillianIdentifier>(&mut challenger_apt.challenges);
		};
		
	}
	
	public fun reject(owner: &signer, aptillian_id: u64) acquires AptillianStorage {
		let owner_addr = Signer::address_of(owner);
		let owner_apt_storage = borrow_global_mut<AptillianStorage>(owner_addr);
		let owner_apt: &mut Aptillian = Table::borrow_mut(&mut owner_apt_storage.map, &aptillian_id);
		// remove the challenge from the list of challenges
		Vector::pop_back<AptillianIdentifier>(&mut owner_apt.challenges);
	}

    const ENO_TOO_MANY_APTILLIAN: u64 = 0;

	public fun generate_aptillian(owner: &signer, name: ASCII::String) acquires AptillianStorage {
		let owner_addr = Signer::address_of(owner);
		if(!exists<AptillianStorage>(owner_addr)){
			move_to<AptillianStorage>(owner, make_aptillian_storage());
		};
		let table = borrow_global_mut<AptillianStorage>(owner_addr);
		table.insertions = table.insertions + 1;

		// An owner is not allowed to have more than five aptillians at a time.
		assert!(Table::length(&table.map) <= 5, ENO_TOO_MANY_APTILLIAN);
		let aptillian = make_aptillian();
		aptillian.name = name;
		// Insert a new aptillian into our aptillian table
		Table::add(
			&mut table.map,
			&table.insertions,
			aptillian
		)
	}

	public fun to_uint8<MoveValue>(v: &MoveValue): u8{
		*Vector::borrow(&BCS::to_bytes(v), 0)
	}

	public fun random(seed: u64): u8 {
		// SHA_256 the timestamp in microseconds plus a seed passed in.
		// TODO -- maybe use some account address for seeding as well.
		let seed_u8 = to_uint8(&seed);
		let now = to_uint8(&Timestamp::now_microseconds());
		let internal_seed: u8 = if (now > seed_u8) (now-seed_u8) else (seed_u8-now);
		let hash_vect = Vector::empty();
		Vector::push_back(&mut hash_vect, now + internal_seed);
		*Vector::borrow(&Hash::sha3_256(hash_vect), 0)
	}
}