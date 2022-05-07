module FightClub::Utils {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	use FightClub::Types;
	use Std::Table;

    public (script) fun initialize_storage(owner: &signer){
        move_to<AptillianStorage>(owner, AptillianStorage {name, type, losses, wins, hp, attack, defense, speed, fights, challenges})
        /**
        module FightClub::Aptillian {
    use Std::Signer;
	use Std::Vector;
	use Std::ASCII;
	use FightClub::Types;
	use Std::Table;

        */
    }
    
}
