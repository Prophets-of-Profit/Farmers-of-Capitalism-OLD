module character.Player;

import world.World;
import item.Inventory;
import character.Character;
import character.technology.Technology;

/**
 * A class for each player
 * Stores basic data for each player and contains methods for performing actions as/with the player
 */
public class Player: Character{

    public Inventory inventory = new Inventory();   ///The player's inventory
    public Technology[] researched;                 ///The technologies the player has researched

    /**
     * A constructor for a player that just calls the Character constructor
     */
    this(int[] coords){
        super(coords);
        this.inventory.accessibleTo = [this];
    }

}
