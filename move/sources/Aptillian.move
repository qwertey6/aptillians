module FightClub::Aptillian {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	//use AptosFramework::Timestamp;

	struct Aptillian has key, drop {
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
		fights: vector<Fight>,
		challenges: vector<Challenge>
	}

	struct Challenge has store, drop {
		challenger: address,
		//aptillian_id: u64
	}
    
	struct Fight has store, drop {
		challenger: address,
		//challenger_aptillian_id: u64,
		target: address,
		//target_aptillian_id: u64,
	}

	const ENO_APTILLIAN: u64 = 0;

	public(script) fun generate_aptillian(owner: &signer, name: ASCII::String, type: u64) {
		let losses = 0;
		let wins = 0;
		let hp = random10();
		let attack = random10();
		let defense = random10();
		let speed = random10();
		let total = hp + attack + defense;
		attack = (attack * 10) / total;
		defense = (defense * 10) / total;
		speed = (speed * 10) / total;
		let fights = Vector::empty<Fight>();
		let challenges = Vector::empty<Challenge>();
		move_to<Aptillian>(owner, Aptillian {name, type, losses, wins, hp, attack, defense, speed, fights, challenges})
	}

	public(script) fun challenge(challenger: &signer, target: address) acquires Aptillian {
		let challenger_addr = Signer::address_of(challenger);
		let challenge = Challenge {challenger: challenger_addr};
		// assert exists first
		let target_apt = borrow_global_mut<Aptillian>(target);
		Vector::push_back(&mut target_apt.challenges, challenge);

	}

    #[test(fighter = @0x1, target = @0x2)]
    public(script) fun pick_a_fight(fighter: signer, target: signer) acquires Aptillian {
		let fighter_addr = Signer::address_of(&fighter);
		generate_aptillian(&fighter, ASCII::string(b"the fighter"), 1);
		assert!(exists<Aptillian>(fighter_addr), ENO_APTILLIAN);
		let target_addr = Signer::address_of(&target);
		generate_aptillian(&target, ASCII::string(b"the target"), 1);
		assert!(exists<Aptillian>(target_addr), ENO_APTILLIAN);

		challenge(&fighter, target_addr);

	}

	fun random10(): u64 {
		5
	// 	let x = Timestamp::now_microseconds();
	// // x0=seed; a=multiplier; b=increment; m=modulus; n=desired array length; 
	
        
		// let n = digits(x, 1, 1);
		// let m = digits(x, 3, 2);
		// let b = digits(x, 5, 4);
		// let a = digits(x, 7, 6);

		// let i = 0;
		// while (i < n) {
		// 	x = (a * x + b) % m;
		// };
		// digits(x, 1, 1)
	}

// 	fun digits(source: u64, start: u64, end: u64): u64 {
// 		let start_mod = power(10, start);
// 		let end_mod = power(10, end-1);
// 		//let _ = (source - ((source/start_mod)*start_mod))/end_mod;
// 		(source % start_mod) / end_mod

// 	}

// 	fun power(x: u64, y: u64): u64 {
// 		if (x == 0)
// 		  1
// 		else
// 		{
// 			let i = 1;
// 			let result = x;
// 			while (i < y) {
// 				result = result * x;
// 				i = i + 1;
// 			};
// 			result
// 		}
// 	}
// #[test]
//     public(script) fun check_mod()  {
		
// 		let result = digits(18446744073, 2, 1);
// 		assert!(result==3, EBAD_MOD)
// 	}

// #[test]
// 	public(script) fun check_power() {
// 		let result = power(10, 3);
// 		assert!(result==1000, EBAD_MOD)
// 	}
}