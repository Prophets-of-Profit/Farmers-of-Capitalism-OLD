module item.plant.Plant;

import app;
import character.Character;
import item.Inventory;
import item.Item;
import item.plant.PlantTraits;
import world.Range;
import world.World;

/**
 * A parent class for all plant objects.
 * Contains basic (non-functional) traits and methods shared between all plants.
 */
/*class Plant : Item{

}*/

unittest{
    import std.stdio;

    writeln("\nRunning unittest of Plant");

    int worldSize = 5;
    game.mainWorld = new World(worldSize);
    int numRuns = 5;
    foreach(i; 0..numRuns){
        //TODO
    }
}
