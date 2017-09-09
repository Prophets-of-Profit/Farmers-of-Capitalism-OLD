module item.settlement.Settlement;

import character.Character;
import item.Inventory;
import item.settlement.District;
import world.World;

immutable baseHousingPerSettlement = 5;

class Settlement{

    Inventory!District tiles = new Inventory!District(-1);                                ///An inventory of the districts
    Character leader;                                                                     ///The leader of the settlement

}
