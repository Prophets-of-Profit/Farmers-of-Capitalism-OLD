module world.HexTile;

import app;
import world.World;
import player.Player;
import world.improvement.Item;
import player.Inventory;
import std.math;
import std.conv;

/**
 * An enum for directions
 * Each direction is assigned an integer for which element in getAdjacentCoords of a tile will be in the given direction
 */
public enum Direction{
    NORTH = 0, NORTH_EAST = 1, SOUTH_EAST = 2, SOUTH = 3, SOUTH_WEST = 4, NORTH_WEST = 5
}
    
/**
 * Types of stats a tile has
 * Temperature is the temperature of the tile in C
 * Water is either the humidity of the tile or the salinity of the tile (depending on if the tile is water)
 * Soil is the soil quality of the tile
 * Elevation is the height of the tile
 */
enum TileStat{
    TEMPERATURE, WATER, SOIL, ELEVATION
}

class HexTile{

    public immutable int[] coords;                  ///Location of the tile stored as [ringNumber, positionInRing]
    public double[TileStat] climate;                ///The tile's climate information
    public bool isWater;                            ///Determines if the tile is a water tile
    public Direction direction;                    ///Direction of wind or water flow TODO limit to 0-5
    public Inventory contained = new Inventory(1);  ///Improvement(s) or building(s) or plant(s) that are on this tile
    public Player owner;                            ///The owner of this tile; if none, owner is null

    /**
     * The constructor for a hextile
     * Takes in its coordinates and stores it in itself for later use
     * Each hextile MUST have coordinates
     * Params:
     *      coords = the coordinates of the new hextile
     */
    this(immutable int[] coords){
        this.coords = coords;
    }

    /**
     * Returns all tiles of distance 1 from this tile
     * Because the tiles are hexes, the process involves finding whether the tiles are straight off from one of the center hex's sides
     *  and then performing different actions based on whether the tile is a) the center, b) straight off the side of the center hex, or
     *  c) just any tile
     * The method will make sure that the adjacent tiles actually exist in the map so that tiles such as map edges don't give adjacent tiles that dont' exist
     * TODO rework order of returned coordinates such that order is: NORTH, NORTHEAST, SOUTHEAST, SOUTH, SOUTHWEST, NORTHWEST (clockwise starting north)
     */
    public int[][] getAdjacentCoords(){
        int[][] adjacentCandidates = null;
        int cornerNum = (this.coords[0] == 0)? 0 : this.coords[1] / this.coords[0];
        if(coords[0] == 0){
            return [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5]];
        }else if(this.coords[1] % this.coords[0] == 0){
            adjacentCandidates = [[this.coords[0], this.coords[1] - 1],
                    [this.coords[0], this.coords[1] + 1],
                    [this.coords[0] - 1, (this.coords[0] - 1) * cornerNum],
                    [this.coords[0] + 1, (this.coords[0] + 1) * cornerNum - 1],
                    [this.coords[0] + 1, (this.coords[0] + 1) * cornerNum],
                    [this.coords[0] + 1, (this.coords[0] + 1) * cornerNum + 1]];
        }else{
            adjacentCandidates = [[this.coords[0], this.coords[1] - 1],
                    [this.coords[0], this.coords[1] + 1],
                    [this.coords[0] + 1, this.coords[1] + cornerNum + 1],
                    [this.coords[0] + 1, this.coords[1] + cornerNum],
                    [this.coords[0] - 1, this.coords[1] - cornerNum - 1],
                    [this.coords[0] - 1, this.coords[1] - cornerNum + 1]];
        }
        int[][] adjacentTiles = null;
        foreach(int[] coord; adjacentCandidates){
            adjacentTiles ~= (mainWorld.getTileAt(coord) !is null)? coord : null;
        }
        return adjacentTiles;
    }

    /*
     * Returns a tile of distance 1 away from this tile in the direction given
     * TODO this function won't work because getAdjacentCoords returns adjacencies in an arbitrary order
     * Params:
     *      directionOfAdjacent = the direction enum or integer of which side the given adjacent coordinate should be
     */
    public int[] getAdjacentCoordInDirection(Direction directionOfAdjacent){
        return this.getAdjacentCoords()[directionOfAdjacent];
    }

    /**
     * Gets how much movement the tile costs based on the tiles movement cost and its items' movement cost
     */
    public double getPassabilityCost(){
        return max(1 + to!int(ceil(this.contained.getCollectiveMovementCost())), 0);
    }

    /**
     * Makes a copy of this hextile with the same instancedata as this hextile
     * If this hextile were to change, the copy wouldn't reflect those changes
     * If the owner of the copy changes, that change is reflected in the copy
     */
    public HexTile clone(){
        HexTile copy = new HexTile(this.coords);
        copy.climate = this.climate;
        copy.isWater = this.isWater;
        copy.direction = this.direction;
        copy.contained = this.contained.clone();
        copy.owner = this.owner;
        return copy;
    }

}

unittest{
    import std.stdio;
    
    writeln("Running unittest of HexTile");
    
    int ringNumsToTest = 5;
    mainWorld = new World(ringNumsToTest);
    writeln("Adjacencies of [0, 0] : ", mainWorld.getTileAt([0, 0]).getAdjacentCoords());
    int testRunNum = 4;
    for(int i = 0; i < testRunNum; i++){
        int[] coords = mainWorld.getRandomCoords();
        writeln("Adjacencies of ", coords, " : ", mainWorld.getTileAt(coords).getAdjacentCoords());
    }
}
