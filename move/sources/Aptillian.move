module FightClub::Aptillian {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	use FightClub::Types;
	use Std::Table;

    const ENO_TOO_MANY_APTILLIAN: u64 = 0;

	public (script) fun generate_aptillian(owner: &signer, name: ASCII::String, type: u64) {
		
		if(!exists<AptillianStorage>(Signer::address_of(owner))){
			move_to<AptillianStorage>(owner, make_aptillian_storage());
		};
		let table = borrow_global_mut<AptillianStorage>(owner).map;
		table.insertions = table.insertions + 1;

		// An owner is not allowed to have more than five aptillians at a time.
		assert!(Table::length(table) <= 5, ENO_TOO_MANY_APTILLIAN);
		
		// Insert a new aptillian into our aptillian table
		Table::add(
			table,
			table.insertions,
			make_aptillian()
		)
	}

}