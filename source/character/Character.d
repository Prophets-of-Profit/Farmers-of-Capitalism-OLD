module character.Character;

import std.algorithm;
import std.array;
import std.conv;
import std.math;

import app;
import world.Range;
import world.World;

/**
 * A set of methods and instancedata for a character
 * Is made to be extended
 */
class Character{

    Coordinate location;                                   ///The location of the character stored as [ringNum, pos]
    public int maxTravellableDistance = 5;                 ///The most distance the character can move in one turn TODO turn maxTravellableDistance and numMovesLeft to a range?
    public double numMovesLeft;                            ///The amount of moves the character can still do this turn
    public Range!int health = Range!int(0, 1000, 1000);    ///Sets the character's health to a value that will always be within the Range's bounds

    /**
     * A property method that just returns the player's location
     */
    @property Coordinate coords(){
        return this.location;
    }

    /**
     * A property method that sets the character's location
     * While this could have been a public field, it was made into a property because Player overrides just the setter
     */
    @property Coordinate coords(Coordinate newCoords){
        this.location = newCoords;
        return newCoords;
    }

    /**
     * A constructor for a character
     * Takes in a starting location and starts the character there
     * Params:
     *      startingLocation = the coordinates of where the character starts
     */
    this(Coordinate startingLocation){
        this.coords = startingLocation;
    }

    /**
     * Returns a list of coordinates of where the character can travel to based on how many moves they have left
     * Doesn't return the distance of those coordinates
     */
    Coordinate[] getValidMoveLocations(){
        if(this.numMovesLeft == 0){
            return [this.coords];
        }
        Coordinate[] validMoveLocations = [this.coords];
        foreach(adjacentCoord; game.mainWorld.getTileAt(this.coords).getAdjacentCoords()){
            if(adjacentCoord == nullCoord){
                break;
            }
            Character copy = new Character(adjacentCoord);
            copy.numMovesLeft = this.numMovesLeft - this.getMovementCostAt(adjacentCoord);
            if(copy.numMovesLeft >= 0){
                if(!validMoveLocations.canFind(adjacentCoord)){
                    validMoveLocations ~= adjacentCoord;
                }
                foreach(validMoveLocation; copy.getValidMoveLocations()){
                    if(!validMoveLocations.canFind(validMoveLocation)){
                        validMoveLocations ~= validMoveLocation;
                    }
                }
            }
        }
        return validMoveLocations;
    }

    /**
     * Moves the character based on where they want to move, and adjusts the amount of moves they have left in the turn accordingly
     * Accounts for tiles they step on and activates their getSteppedOn function
     * Returns if the move was successful
     * Params:
     *      pathToNewLocation = the path to the to-be location of the character
     */
    bool setLocation(Coordinate[] pathToNewLocation){
        assert(pathToNewLocation[0] != this.coords && game.mainWorld.isContiguous([this.coords] ~ pathToNewLocation)); //TODO automatically correct pathToNewLocation if incorrect rather than erroring (allows for more flexibility)
        foreach(location; pathToNewLocation){
            if(this.numMovesLeft <= 0 || location == this.coords || !this.getValidMoveLocations().canFind(location)){
                return false;
            }
            this.coords = location;
            foreach(item; game.mainWorld.getTileAt(location).contained){
                item.getSteppedOn(this);
            }
            this.numMovesLeft -= this.getMovementCostAt(location);
        }
        return true;
    }

    /**
     * Gets the cost of moving to this tile for the current character
     * Takes in several factors of consideration to get movement cost and is primarily character based rather than location based
     * This means that a certain coordinate could have different movement costs for different players based on their attributes
     * Params:
     *      locationToFindCost = the location of where the movement cost of the player going in that area should be
     */
    int getMovementCostAt(Coordinate locationToFindCost){
        return 1 + game.mainWorld.getTileAt(locationToFindCost).contained.items.map!(a => a.getMovementCost(this)).sum.floor.to!int;
    }

}

unittest{
    import std.random;
    import std.stdio;

    writeln("\nRunning unittest of Character");

    game = new Main(0, 7);
    Character testPlayer = new Character(Coordinate(0, 0));
    testPlayer.numMovesLeft = 1;
    writeln("A character at [0, 0] who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    int numPlayersToTest = 4;
    foreach(i; 0..numPlayersToTest){
        Coordinate coords = game.mainWorld.getRandomCoords();
        testPlayer = new Character(coords);
        testPlayer.numMovesLeft = uniform(0, 5);
        writeln("A character at ", coords, " who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    }
}
