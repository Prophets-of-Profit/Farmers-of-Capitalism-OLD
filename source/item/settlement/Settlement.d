module item.settlement.Settlement;

import std.algorithm;

import character.Character;
import item.Inventory;
import item.Item;
import item.plant.Plant;
import world.World;

immutable maxSpaceForTile = 100;

class Settlement{

    Coordinate location;                     ///The location of this settlement
    Inventory!Character characters;          ///An inventory of the characters
    Inventory!Item buildings;                ///An inventory of the buildings
    Character leader;                        ///The leader of the settlement

    /*
     * Constructs a new settlement.
     * Params:
     *      leader = the character that leads this settlement
     *      location = the location this settlement is at
     **/
    this(Character leader, Coordinate location){
        workers = new Inventory!Character();
        buildings = new Inventory!Item(maxSpaceForTile);
        this.leader = leader;
        this.location = location;
    }

    /*
     * Adds a building to this settlement. Plants cannot be added to settlements.
     **/
    void addBuilding(Item building){
        if(building.canBePlaced(this.location)){
            this.buildings.add(building);
        }
    }

}
