module item.settlement.Settlement;

import character.Character;
import item.Inventory;
import item.settlement.District;
import world.World;

immutable maxSpaceForTile = 100;
immutable baseHousingPerSettlement = 5;

class Settlement{

    Coordinate location;                                                                  ///The location of this settlement
    Inventory!Character characters = new Inventory!Character(baseHousingPerSettlement);   ///An inventory of the characters
    Inventory!District tiles = new Inventory!District(maxSpaceForTile);                   ///An inventory of the buildings
    Character leader;                                                                     ///The leader of the settlement

}
