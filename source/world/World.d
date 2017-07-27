module world.World;

import world.HexTile;
import player.Player;
import core.exception;
import std.algorithm;
import std.random;
import std.conv;
import app;
import core.thread;

/**
 * A general class that should only ever be instantiated once
 * Contains an array of tiles sorted by their ringNum (distance from the center) and pos (how far clockwise along the ring the tile is)
 */
class World{

    private HexTile[] tiles;                ///The storage array of all tiles; stored in order of ringNum and then pos
    public immutable int numRings;          ///The number of rings the hexmap (World) has
    public Player[] players;                ///A list of all of the players in the game
    public immutable double variance = 1.0; ///How much each adjacent hextile can differ

    /**
     * The constructor for a world
     * Fills itself with a bunch of tiles given how many rings to make
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
        /*TODO insert Kadin's generation of hextiles and Elia's generation of plants*/
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
     * Returns the coordinates of a random tile
     */
	public int[] getRandomCoords(){
        return this.tiles[uniform(0, this.getNumTiles())].coords.dup;
    }

    /**
     *  Returns the amount of tiles that exists within the world
     *  Isn't probably going to be used for much
     */
    public int getNumTiles(){
        return to!int(this.tiles.length);
    }

    /**
     * Gives the distance between two coordinates given as [ringNum, pos]
     * Params:
     *      firstLocation = the coordinates of the first point
     *      secondLocation = the coordinates of the second point
     */
    public int getDistanceBetween(int[] firstLocation, int[] secondLocation){
        assert(this.getTileAt(firstLocation) !is null && this.getTileAt(secondLocation) !is null);
        int distance = 0;
        int[][] checked = [firstLocation];
        while(!checked.canFind(secondLocation)){
            int[][] prevChecked = checked.dup;
            checked = null;
            distance++;
            foreach(int[] coord; prevChecked){
                checked ~= this.getTileAt(coord).getAdjacentCoords();
            }
        }
        return distance;
    }

    /**
     * Gets a list of coordinates that will take any player from firstLocation to secondLocation with the smallest
     * movement cost: the returned coordinates will contain the second given location as the last element, but will not
     * contain the first given location
     * Params:
     *      firstLocation = the initial starting location of where to get the cheapest path
     *      secondLocation = where the cheapest path should end
     *      maxAllowablePathCost = the maximum cost allowed for the cheapest path between two coords: if no path is found under this value, null is returned: a smaller max cost makes this function faster
     */
    public int[][] getCheapestPathBetween(int[] firstLocation, int[] secondLocation, double maxAllowablePathCost = double.max){
        if(maxAllowablePathCost < 0){
            return null;
        }
        if(firstLocation == secondLocation){
            return [secondLocation];
        }
        int[][][] candidates = null;
        foreach(int[] coord ; this.getTileAt(firstLocation).getAdjacentCoords()){
            int[][] pathCandidate = this.getCheapestPathBetween(coord, secondLocation, maxAllowablePathCost - this.getTileAt(coord).getPassabilityCost());
            if(pathCandidate !is null){
                candidates ~= [coord] ~ pathCandidate;
            }
        }
        double smallestCost = double.max;
        int[][] path = null;
        foreach(int[][] pathCandidate ; candidates){
            double currentPathCost = 0;
            foreach(int[] coord ; pathCandidate){
                currentPathCost += this.getTileAt(coord).getPassabilityCost();
            }
            if(currentPathCost < smallestCost){
                path = pathCandidate;
            }
        }
        if(path !is null && path.length >= 2){
            assert(this.isContiguous(path));
        }
        return path;
    }

    /**
     * Returns whether the given path is contiguous
     * Params:
     *      path = the list of coordinates to check for contiguity
     */
    public bool isContiguous(int[][] path){
        assert(path.length >= 2);
        for(int i = 0; i < path.length - 1; i++){
            if(!this.getTileAt(path[i]).getAdjacentCoords().canFind(path[i + 1])){
                return false;
            }
        }
        return true;
    }

    /**
     * Returns a copy of the world
     * The returned copy is a mostly-deep copy, meaning that all of its contained tiles are separate from this's contained tiles
     * If a change were to happen to one of this world's tiles, it wouldn't be reflected in the copy's tiles
     * This does not hold for the owner for each tile, as the stored owner of a tile would reflect changes in that player
     */
    public World clone(){
        World copy = new World(this.numRings);
        for(int i = 0; i < this.getNumTiles(); i++){
            copy.tiles[i] = this.tiles[i].clone();
        }
        return copy;
    }

}

unittest{
    import std.stdio;
    
    writeln("Running unittest of World");
    
    int maxWorldRingsToCheck = 5;
    World testWorld;
    for(int i = 1; i < maxWorldRingsToCheck + 1; i++){
        testWorld = new World(i);
        writeln("A world with ", i, " rings has ", testWorld.getNumTiles(), " tiles with an outer ring of ", getSizeOfRing(i), " tiles");
    }
    int runNumForGettingLocations = 3;
    for(int i = 0; i < runNumForGettingLocations; i++){
        int[] coords = testWorld.getRandomCoords();
        writeln("The position of a tile at ", coords, " is ", testWorld.getTileAt(coords).coords);
        assert(coords == testWorld.getTileAt(coords).coords);
    }
    assert(testWorld.getDistanceBetween([0, 0], [1, 1]) == 1);
    int runNumForGettingDistances = 5;
    for(int i = 0; i < runNumForGettingDistances; i++){
        int[][] coords = [testWorld.getRandomCoords(), testWorld.getRandomCoords()];
        writeln("The distance between ", coords[0], " and ", coords[1], " is ", testWorld.getDistanceBetween(coords[0], coords[1]));
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
