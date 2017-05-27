import HexTile;
import core.exception;

/**
 * A general class that should only ever be instantiated once
 * Contains an array of tiles sorted by their ringNum (distance from the center) and pos (how far clockwise along the ring the tile is)
 */
class World{

    private HexTile[] tiles;        ///The storage array of all tiles; stored in order of ringNum and then pos
    public immutable int numRings;  ///The number of rings the hexmap (World) has

    /**
     * The constructor for a world
     * Fills itself with a bunch of empty tiles given how many rings to make
     * Params:
     *      numRings = the amount of rings to construct the world with
     */
    this(int numRings){
        this.numRings = numRings;
        for(int i = 0; i < numRings; i++){
            for(int j = 0; j < getSizeOfRing(i); j++){
                tiles ~= new HexTile([i, j]);
            }
        }
    }

    /**
     *  Gets the tile at given coordinates of [ringNum, pos]
     *  If the given coordinates don't exist, null will be returned
     *  If the pos is too large for the amount of tiles in the given ringNum, the pos will wrap around the ringNum
     *  Params:
     *      location = the coordinates of the tile to get as [ringNum, pos]
     */
    public HexTile getTileAt(int[] location){
        try{
            location[1] = location[1] % getSizeOfRing(location[0]);
            int previousTiles = 0;
            for(int i = 0; i < location[0]; i++){
                previousTiles += getSizeOfRing(i);
            }
            return this.tiles[previousTiles + location[1]];
        }catch(RangeError e){
            return null;
        }
    }

    /**
     *  Returns the amount of tiles that exists within the world
     *  Isn't probably going to be used for much
     */
    public int getNumTiles(){
        return this.tiles.length;
    }

}

unittest{
    import std.stdio;
    import std.random;
    int maxWorldRingsToCheck = 5;
    World testWorld;
    for(int i = 1; i < maxWorldRingsToCheck + 1; i++){
        testWorld = new World(i);
        writeln("A world with ", i, " rings has ", testWorld.getNumTiles(), " tiles with an outer ring of ", getSizeOfRing(i), " tiles");
    }
    int runNumForGettingLocations = 3;
    for(int i = 0; i < runNumForGettingLocations; i++){
        int ringNum = uniform(0, testWorld.numRings);
        int pos = uniform(0, getSizeOfRing(ringNum));
        writeln("The position of a tile at ", [ringNum, pos], " is ", testWorld.getTileAt([ringNum, pos]).coords);
        assert([ringNum, pos] == testWorld.getTileAt([ringNum, pos]).coords);
    }
}


/**
 * Gives how many tiles can exist within a given ring
 * Params:
 *      ringNum = the ring for which the number of tiles will be ascertained
 */
public static int getSizeOfRing(int ringNum){
    return (ringNum == 0)? 1 : 6 * ringNum;
}