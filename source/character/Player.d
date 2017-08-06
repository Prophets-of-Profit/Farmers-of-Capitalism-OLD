module character.Player;

import character.Character;
import character.technology.Technology;
import item.Inventory;
import world.World;

/**
 * A class for each player
 * Stores basic data for each player and contains methods for performing actions as/with the player
 */
public class Player: Character{

    public Inventory inventory = new Inventory();   ///The player's inventory
    public TechnologyName[] researched;             ///The technologies the player has researched

    /**
     * A constructor for a player that just calls the Character constructor and initializes an inventory
     */
    this(Coordinate coords){
        super(coords);
        this.inventory.accessibleTo = [this];
        allTechnologies[TechnologyName.Agriculture].onUnlock(this);
    }

}

unittest{
    import std.stdio;

    writeln("Running unittest of Player");

    Player testPlayer = new Player(Coordinate(-1, -1));
    writeln("A player starts out with the technologies of ", testPlayer.researched);
    assert(testPlayer.researched.length == 1);
    //TODO add more testing here
}
