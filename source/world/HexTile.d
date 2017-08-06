module world.HexTile;

import app;
import world.World;
import world.Range;
import character.Player;
import item.Inventory;
import std.math;
import std.conv;
import std.algorithm.comparison;

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

/**
 * A basic unit or sub-division of the map
 * Is an aptly-named hexagon-shaped tile which has many stats and properties pertaining to what it is used for in the game
 * Contains utility methods
 * Most hex tiles differ from each other at least slightly and the player will have the ability to alter increasingly more parts of a hextile as the game progresses
 * Is a regular hexagon where the angles face east and west
 */
class HexTile{

    public Coordinate coords;                       ///Location of the tile stored as [ringNumber, positionInRing]
    public Range!(double)[TileStat] climate;        ///The tile's climate information
    public bool isWater;                            ///Determines if the tile is a water tile
    public Direction direction;                     ///Direction of wind or water flow
    public Inventory contained = new Inventory(1);  ///Improvement(s) or building(s) or plant(s) that are on this tile
    public Player owner;                            ///The owner of this tile; if none, owner is null

    /**
     * The constructor for a hextile
     * Takes in its coordinates and stores it in itself for later use
     * Each hextile MUST have coordinates
     * Params:
     *      coords = the coordinates of the new hextile
     */
    this(Coordinate coords){
        this.coords = coords;
    }

    /**
     * Returns all tiles of distance 1 from this tile
     * Because the tiles are hexes, the process involves finding whether the tiles are straight off from one of the center hex's sides
     *  and then performing different actions based on whether the tile is a) the center, b) straight off the side of the center hex, or
     *  c) just any tile
     * The method will make sure that the adjacent tiles actually exist in the map so that tiles such as map edges don't give adjacent tiles that dont' exist
     */
    public Coordinate[] getAdjacentCoords(){
        Coordinate[] adjacentCandidates = null;
        int cornerNum = (this.coords[0] == 0)? 0 : this.coords[1] / this.coords[0];
        if(coords[0] == 0){
            return [Coordinate(1, 0), Coordinate(1, 1), Coordinate(1, 2), Coordinate(1, 3), Coordinate(1, 4), Coordinate(1, 5)];
        }else if(this.coords[1] % this.coords[0] == 0){
            //If the coordinate input is at a corner of a ring.
            adjacentCandidates = [
                //Store adjacent coords in clockwise order starting from the one farthest from the center.
                Coordinate(this.coords[0] + 1, (this.coords[0] + 1) * cornerNum),
                Coordinate(this.coords[0] + 1, (this.coords[0] + 1) * cornerNum + 1),
                Coordinate(this.coords[0], this.coords[1] + 1),
                Coordinate(this.coords[0] - 1, (this.coords[0] - 1) * cornerNum),
                Coordinate(this.coords[0], this.coords[1] - 1),
                Coordinate(this.coords[0] + 1, (this.coords[0] + 1) * cornerNum - 1)
            ];
        }else{
            adjacentCandidates = [
                //Store adjacent coords in clockwise order starting from the tile on the outer ring to the counterclockwise direction.
                Coordinate(this.coords[0] + 1, this.coords[1] + cornerNum),
                Coordinate(this.coords[0] + 1, this.coords[1] + cornerNum + 1),
                Coordinate(this.coords[0], this.coords[1] + 1),
                Coordinate(this.coords[0] - 1, this.coords[1] - cornerNum + 1),
                Coordinate(this.coords[0] - 1, this.coords[1] - cornerNum - 1),
                Coordinate(this.coords[0], this.coords[1] - 1)
            ];
        }
        //Rotate the adjacencies by cornerNum to keep it in an order that matches the order of Direction enum.
        adjacentCandidates = adjacentCandidates[cornerNum..$] ~ adjacentCandidates[0..cornerNum];
        Coordinate[] adjacentTiles = null;
        foreach(coord; adjacentCandidates){
            adjacentTiles ~= (game.mainWorld.getTileAt(coord) !is null)? coord : Coordinate(-1, -1);
        }
        return adjacentTiles;
    }

    /*
     * Returns a tile of distance 1 away from this tile in the direction given
     * Params:
     *      directionOfAdjacent = the direction enum or integer of which side the given adjacent coordinate should be
     */
    public Coordinate getAdjacentCoordInDirection(Direction directionOfAdjacent){
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
    game = new Main(0, ringNumsToTest);
    writeln("Adjacencies of [0, 0] are ", game.mainWorld.getTileAt(Coordinate(0, 0)).getAdjacentCoords());
    int testRunNum = 4;
    for(int i = 0; i < testRunNum; i++){
        Coordinate coords = game.mainWorld.getRandomCoords();
        writeln("Adjacencies of ", coords, " are ", game.mainWorld.getTileAt(coords).getAdjacentCoords());
    }
}
