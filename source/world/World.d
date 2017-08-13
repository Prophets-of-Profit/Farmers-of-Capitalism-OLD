module world.World;

import std.algorithm;
import std.array;
import std.random;
import std.conv;

import core.exception;

import app;
import character.Player;
import world.HexTile;
import world.Range;

/**
 * A struct that stores coordinates
 * Coordinates are stored as ringNum and pos:
 *  ringNum is the ring number or the number of rings from the center if the center was ring 0
 *  pos is how far clockwise along the ring the coordinate is
 * Coordinates are immutable
 */
struct Coordinate{

    int ringNum;        ///The ring number of the coordinate or how many rings from the center this coordinate is if the center ring is ring 0
    int pos;            ///The position of the coordinate within the ring or how far clockwise along the ring the coordinate is
    alias coords this;  ///Sets the struct to also be an int[2] of [ringNum, pos]

    /**
     * Returns a int[2] of the coordinate in the form of [ringNum, pos]
     * Just so that the Coordinate can be accessed and used like an array if needed
     */
    @property int[2] coords(){
        return [ringNum, pos];
    }

}

/**
 * A general class that should only ever be instantiated once
 * Contains an array of tiles sorted by their ringNum (distance from the center) and pos (how far clockwise along the ring the tile is)
 */
class World{

    HexTile[] tiles;                        ///The storage array of all tiles; stored in order of ringNum and then pos
    public immutable int numRings;          ///The number of rings the hexmap (World) has

    /**
     * The constructor for a world
     * Fills itself with a bunch of tiles given how many rings to make
     * Params:
     *      numRings = the amount of rings to construct the world with
     */
    this(int numRings){
        this.numRings = numRings;
        foreach(i; 0..numRings){
            foreach(j; 0..getSizeOfRing(i)){
                tiles ~= new HexTile(Coordinate(i, j));
            }
        }
        /*TODO insert Kadin's generation of hextiles instead of below; below doesn't even do rivers*/
        Coordinate[] prevChosen = [this.getRandomCoords];
        foreach(tileStat; __traits(allMembers, TileStat)){
            TileStat stat = tileStat.to!TileStat;
            this.getTileAt(prevChosen[0]).climate[stat] = Range!double(0, 1, uniform(0.0, 1.0));
        }
        while(prevChosen.length < this.getNumTiles){
            Coordinate chosen;
            Coordinate prev;
            do{
                prev = prevChosen[uniform(0, $)];
                chosen = this.getTileAt(prev).getAdjacentCoords(false).filter!(a => this.getTileAt(a) !is null).array[uniform(0, $)];
            }while(prevChosen.canFind(chosen));
            prevChosen ~= chosen;
            foreach(tileStat; __traits(allMembers, TileStat)){
                TileStat stat = tileStat.to!TileStat;
                this.getTileAt(prevChosen[$ - 1]).climate[stat] = Range!double(0, 1, this.getTileAt(prev).climate[stat] + uniform!("[]")(-0.1, 0.1));
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
    HexTile getTileAt(Coordinate location){
        try{
            location[1] = location[1] % getSizeOfRing(location[0]);
            int previousTiles;
            foreach(i; 0..location[0]){
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
	Coordinate getRandomCoords(){
        return this.tiles[uniform(0, this.getNumTiles())].coords;
    }

    /**
     *  Returns the amount of tiles that exists within the world
     *  Isn't probably going to be used for much
     */
    int getNumTiles(){
        return to!int(this.tiles.length);
    }

    /**
     * Gives the distance between two coordinates given as [ringNum, pos]
     * Params:
     *      firstLocation = the coordinates of the first point
     *      secondLocation = the coordinates of the second point
     */
    int getDistanceBetween(Coordinate firstLocation, Coordinate secondLocation){
        assert(this.getTileAt(firstLocation) !is null && this.getTileAt(secondLocation) !is null);
        int distance = 0;
        Coordinate[] checked = [firstLocation];
        while(!checked.canFind(secondLocation)){
            Coordinate[] prevChecked = checked.dup;
            checked = null;
            distance++;
            foreach(coord; prevChecked){
                if(coord != Coordinate(-1, -1)){
                    checked ~= this.getTileAt(coord).getAdjacentCoords();
                }
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
    Coordinate[] getCheapestPathBetween(Coordinate firstLocation, Coordinate secondLocation, double maxAllowablePathCost = double.max){
        if(maxAllowablePathCost < 0){
            return null;
        }
        if(firstLocation == secondLocation){
            return [secondLocation];
        }
        Coordinate[][] candidates = null;
        foreach(coord ; this.getTileAt(firstLocation).getAdjacentCoords()){
            Coordinate[] pathCandidate = this.getCheapestPathBetween(coord, secondLocation, maxAllowablePathCost - this.getTileAt(coord).getPassabilityCost());
            if(pathCandidate !is null){
                candidates ~= [coord] ~ pathCandidate;
            }
        }
        double smallestCost = double.max;
        Coordinate[] path = null;
        foreach(Coordinate[] pathCandidate ; candidates){
            double currentPathCost = 0;
            foreach(Coordinate coord ; pathCandidate){
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
    bool isContiguous(Coordinate[] path){
        assert(path.length >= 2);
        foreach(i; 0..path.length - 1){
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
    World clone(){
        World copy = new World(this.numRings);
        foreach(i; 0..this.getNumTiles){
            copy.tiles[i] = this.tiles[i].clone();
        }
        return copy;
    }

    /**
     * Updates all aspects of the world including tiles and contained items
     */
    void update(){
        foreach(tile; this.tiles){
            foreach(item; tile.contained){
                item.doIncrementalAction();
            }
        }
    }

}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of World");

    int maxWorldRingsToCheck = 5;
    foreach(i; 1..maxWorldRingsToCheck + 1){
        game = new Main(0, i);
        writeln("A world with ", i, " rings has ", game.mainWorld.getNumTiles(), " tiles with an outer ring of ", getSizeOfRing(i-1), " tiles");
    }
    int runNumForGettingLocations = 3;
    foreach(i; 0..runNumForGettingLocations){
        Coordinate coords = game.mainWorld.getRandomCoords();
        writeln("The position of a tile at ", coords, " is ", game.mainWorld.getTileAt(coords).coords);
        assert(coords == game.mainWorld.getTileAt(coords).coords);
    }
    assert(game.mainWorld.getDistanceBetween(Coordinate(0, 0), Coordinate(1, 1)) == 1);
    int runNumForGettingDistances = 5;
    foreach(i; 0..runNumForGettingDistances){
        Coordinate[] coords = [game.mainWorld.getRandomCoords(), game.mainWorld.getRandomCoords()];
        writeln("The distance between ", coords[0], " and ", coords[1], " is ", game.mainWorld.getDistanceBetween(coords[0], coords[1]));
    }
}

/**
 * Gives how many tiles can exist within a given ring
 * Params:
 *      ringNum = the ring for which the number of tiles will be ascertained
 */
int getSizeOfRing(int ringNum){
    return (ringNum == 0)? 1 : 6 * ringNum;
}
