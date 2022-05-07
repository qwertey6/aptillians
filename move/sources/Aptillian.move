module FightClub::Aptillian {
	use AptosFramework::Timestamp;
	use Std::ASCII;
	use Std::BCS;
	use Std::Hash;
	use Std::Table::{Self, Table};
	use Std::Vector;
	use Std::Signer;

    struct AptillianIdentifier has store, drop {
        owner: address,
		aptillian_id: u64
    }
	struct Fight has store, drop {
		challenger: AptillianIdentifier,
		target: AptillianIdentifier,
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

	public (script) fun generate_aptillian_iface(owner: &signer, name: ASCII::String) acquires AptillianStorage {
        generate_aptillian(owner, name);
	}

	public (script) fun challenge_iface(challenger: &signer, challenger_aptillian_id: u64, target: address, target_aptillian_id: u64) acquires AptillianStorage {
        challenge(challenger, challenger_aptillian_id, target, target_aptillian_id);
	}

    public(script) fun accept_iface(owner: &signer, aptillian_id: u64) acquires AptillianStorage {
        accept(owner, aptillian_id);
    }

    public(script) fun reject_iface(owner: &signer, aptillian_id: u64) acquires AptillianStorage {
        reject(owner, aptillian_id);
    }
		
    // public(script) fun make_turn_iface(owner:&signer, aptillian_id: u64, abilityId: u64, target: address) acquires AptillianStorage {
    //     make_turn(owner, make_turn);
    // }

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
		let attack = *Vector::borrow(&stats, 0);
		let defense = *Vector::borrow(&stats, 1);
		let speed = *Vector::borrow(&stats, 2);
		
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
		Fight {challenger, target}
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
		let fighter = Table::borrow_mut(fighter_table, 0);
		
		
		let target_addr = Signer::address_of(&target);
		generate_aptillian(&target, ASCII::string(b"the fighted"));
		assert!(exists<AptillianStorage>(target_addr), ENO_APTILLIAN);
		assert!(exists<Aptillian>(target_addr), ENO_APTILLIAN);
		let target_table = borrow_global_mut<AptillianStorage>(target_addr).map;
		let target = Table::borrow_mut<Table, u64>(&target_table, 0);

		challenge(&fighter, 0, target_addr, 0);

		assert!(Vector::length(target.challenge), ENO_CHALLENGE);
	}

	public fun accept(owner: &signer, aptillian_id: u64) {
		let owner_addr = Signer::address_of(owner);
		let owner_apt_storage = borrow_global_mut<AptillianStorage>(owner_addr);
		let owner_apt = Table::borrow_mut(&mut (target_apt_storage.map), &aptillian_id);
		let challenger_identifier = Vector::pop_back(&owner_apt.challenge);
		/** TODO -- CREATE A NEW FIGHT HERE AND ASSIGN VALUES ACCORDINGLY */
		assert!(0 != 0);
	}
	
	public fun reject(owner: &signer, aptillian_id: u64) {
		let owner_addr = Signer::address_of(owner);
		let owner_apt_storage = borrow_global_mut<AptillianStorage>(owner_addr);
		let owner_apt = Table::borrow_mut(&mut (target_apt_storage.map), &aptillian_id);
		let challenger_identifier = Vector::pop_back(&owner_apt.challenge);
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