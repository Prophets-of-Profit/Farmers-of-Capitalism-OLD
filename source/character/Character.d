module character.Character;

import app;
import std.algorithm;
import std.array;
import world.World;

/**
 * A set of methods and instancedata for a character
 * Is made to be extended
 */
class Character{

    public Coordinate coords;                       ///The location of the character stored as [ringNum, pos]
    public int maxTravellableDistance = 5;          ///The most distance the character can move in one turn
    public double numMovesLeft;                     ///The amount of moves the character can still do this turn

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
    public Coordinate[] getValidMoveLocations(){
        if(this.numMovesLeft == 0){
            return [this.coords];
        }
        Coordinate[] validMoveLocations = [this.coords];
        foreach(adjacentCoord; game.mainWorld.getTileAt(this.coords).getAdjacentCoords()){
            if(adjacentCoord == Coordinate(-1, -1)){
                break;
            }
            Character copy = new Character(adjacentCoord);
            copy.numMovesLeft = this.numMovesLeft - game.mainWorld.getTileAt(adjacentCoord).getPassabilityCost();
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
    public bool setLocation(Coordinate[] pathToNewLocation){
        assert(pathToNewLocation[0] != this.coords && game.mainWorld.isContiguous([this.coords] ~ pathToNewLocation)); //TODO automatically correct pathToNewLocation if incorrect rather than erroring (allows for more flexibility)
        foreach(location; pathToNewLocation){
            if(this.numMovesLeft <= 0 || location == this.coords || !this.getValidMoveLocations().canFind(location)){
                return false;
            }
            this.coords = location;
            foreach(item; game.mainWorld.getTileAt(location).contained){
                item.getSteppedOn(this);
            }
            this.numMovesLeft -= game.mainWorld.getTileAt(location).getPassabilityCost();
        }
        return true;
    }

}

unittest{
    import std.stdio;
    import std.random;

    writeln("Running unittest of Character");

    game = new Main(0, 7);
    Character testPlayer = new Character(Coordinate(0, 0));
    testPlayer.numMovesLeft = 1;
    writeln("A character at [0, 0] who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    int numPlayersToTest = 4;
    for(int i = 0; i < numPlayersToTest; i++){
        Coordinate coords = game.mainWorld.getRandomCoords();
        testPlayer = new Character(coords);
        testPlayer.numMovesLeft = uniform(0, 5);
        writeln("A character at ", coords, " who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    }
}
