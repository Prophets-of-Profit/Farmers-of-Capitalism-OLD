module item.settlement.Settlement;

import std.algorithm;

import app;
import character.Character;
import government.Government;
import item.Inventory;
import item.settlement.District;
import world.World;

immutable baseHousingPerSettlement = 5; //How much housing each settlement starts with

/**
 * A settlement is a thing that has a physical location on the map and may span multiple tiles
 */
class Settlement {

    Inventory!District tiles = new Inventory!District(-1); ///An inventory of the districts. tiles[0] will be the central district

    /**
     * Gets the governing body of the settlement
     */
    @property Government government(){
        foreach(government; game.mainWorld.allGovernments){
            if(canFind(government.settlements.items,this)){
                return government;
            }
        }
        return null;
    }


    /**
     * Builds a new district at desired location
     * TODO
     * Params:
     *      newLocation = the location at which the district should be createDistrict
     */
    bool createDistrict(Coordinate newLocation){
        District district = new District();
        if(district.canBePlaced(newLocation) && district.getMovedTo(game.mainWorld.getTileAt(newLocation).contained)){
            district.settlement = this;
            district.location = newLocation;
        }
        return false;
    }

}
