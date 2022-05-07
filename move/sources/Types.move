module FightClub::Types {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	use Std::Hash;
	use AptosFramework::Timestamp;


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

	public fun make_aptillian(): Aptillian{
		let losses = 0;
		let wins = 0;
		let hp = 10;
		let games_played = 0;
		let remaining = 10;
		let idx = 0;
		let stats = Vector<u64>[0,0,0];
		let stat = Vector::borrow_mut(&stats, idx);
		
		loop {

			if (remaining == 1) *stat = *stat + 1;
			else if (remaining == 0) break;
			else *stats = 1 + *stats + (random(idx) % 2);
			idx = (idx + 1) % 3;
			stat = Vector::borrow_mut(&stats, idx);
			
		};
		let attack = Vector::borrow(&stats, 0);
		let defense = Vector::borrow(&stats, 1);
		let speed = Vector::borrow(&stats, 2);
		
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
				games_played
				versus,
				fights,
				challenges,
			}
	}

    struct AptillianIdentifier has store, drop {
        owner: address,
		aptillian_id: u64
    }
	
	public fun make_aptillian_identifier(owner:address, aptillian_id: u64): AptillianIdentifier{
		return AptillianIdentifier {owner, aptillian_id};
	}
    
	struct Fight has store, drop {
		challenger: AptillianIdentifier,
		target: AptillianIdentifier,
	}

	public fun make_fight(challenger: AptillianIdentifier, target: AptillianIdentifier): Fight{
		return Fight {challenger, target};
	}

    struct AptillianStorage has key {
        map: Table<u64, Aptillian>,
        insertions: u64,
    }

	public fun make_aptillian_storage(): AptillianStorage{
		return AptillianStorage {map: Table::new<u64, Aptillian>(), insertions: 0}
	}


	public fun random(seed: u64): u64 {
		// SHA_256 the timestamp in microseconds plus a seed passed in.
		// TODO -- maybe use some account address for seeding as well.
		
		let now = Timestamp::now_microseconds();
		let internal_seed = 0;
		internal_seed = if (now > seed) (now-seed) else (seed-now);
		let hash_vect = Vector::empty();
		Vector::push_back(&hash_vect, now);
		return Vector::borrow(&Hash::sha3_256(hash_vect), 0)
	}
}