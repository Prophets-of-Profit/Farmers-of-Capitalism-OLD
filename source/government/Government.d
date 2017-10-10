module government.Government;

import character.Character;
import item.Inventory;
import item.settlement.Settlement;

class Government {

    long baseItemCost;                      ///TODO
    Inventory!Character officials;          ///Everybody with a stake in the Government
    Inventory!Settlement settlements;       ///All owned cities

    /**
     * Gets the leader of the government
     */
    @property Character owner(){
        return officials[0];
    }

}
