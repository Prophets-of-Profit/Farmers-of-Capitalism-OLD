module item.settlement.Settlement;

import character.Character;
import item.Inventory;
import item.settlement.District;
import world.World;

immutable baseHousingPerSettlement = 5; //How much housing each settlement starts with

/**
 * A settlement is a thing that has a physical location on the map and may span multiple tiles
 */
class Settlement {

    Inventory!District tiles = new Inventory!District(-1); ///An inventory of the districts. tiles[0] will be the central district
    Character leader;                                      ///The leader of the settlement

}
