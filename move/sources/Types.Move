module FightClub::Types {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	//use AptosFramework::Timestamp;

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
        // Who I'm fighting right now, or `[]`
		versus: vector<AptillianIdentifier>,
        fights: vector<Fight>,
		challenges: vector<AptillianIdentifier>,
	}

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
}