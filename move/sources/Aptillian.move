module FightClub::Aptillian {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	use FightClub::Types;
	use Std::Table;

    const ENO_TOO_MANY_APTILLIAN: u64 = 0;

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
		let versus = Vector::empty<AptillianIdentifier>();
		let fights = Vector::empty<Fight>();
		let challenges = Vector::empty<AptillianIdentifier>();
		if(!exists<AptillianStorage>(Signer::address_of(owner))){
			move_to<AptillianStorage>(owner, {Table::new<u64, Aptillian>(), 0});
		}
		let table = borrow_global_mut<AptillianStorage>(owner).map;
		table.insertions = table.insertions + 1;

		// An owner is not allowed to have more than five aptillians at a time.
		assert!(Table::length(table) <= 5, ENO_TOO_MANY_APTILLIAN);
		
		Table::add(
			table,
			table.insertions,
			Aptillian {
				name,
				type,
				losses,
				wins,
				hp,
				attack,
				defense,
				speed,
				versus,
				fights,
				challenges,
			}
		)
	}

	// TODO -- move below to Utils.move
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