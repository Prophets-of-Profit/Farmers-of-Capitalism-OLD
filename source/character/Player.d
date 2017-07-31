module character.Player;

import app;
import world.World;
import item.Inventory;
import std.algorithm;
import std.array;
import character.Character;
import character.technology.Technology;

/**
 * A class for each player
 * Stores basic data for each player and contains methods for performing actions as/with the player
 */
public class Player: Character{

    public int[] coords;                            ///The location of the player stored as [ringNum, pos]
    public int maxTravellableDistance = 5;          ///The most distance the player can move in one turn
    public double numMovesLeft;                     ///The amount of moves the player can still do this turn
    public Inventory inventory = new Inventory();   ///The player's inventory
    public Technology[] researched;                 ///The technologies the player has researched

    /**
     * A constructor for a player
     * Takes in a starting location and starts the player there
     * Params:
     *      startingLocation = the coordinates of where the player starts
     */
    this(int[] startingLocation){
        this.coords = startingLocation.dup;
    }

    /**
     * Returns a list of coordinates of where the player can travel to based on how many moves they have left
     * Doesn't return the distance of those coordinates
     */
    public int[][] getValidMoveLocations(){
        if(this.numMovesLeft == 0){
            return [this.coords];
        }
        int[][] validMoveLocations = [this.coords];
        foreach(adjacentCoord; game.mainWorld.getTileAt(this.coords).getAdjacentCoords()){
            if(adjacentCoord is null){
                break;
            }
            Player copy = new Player(adjacentCoord);
            copy.numMovesLeft = this.numMovesLeft - game.mainWorld.getTileAt(adjacentCoord).getPassabilityCost();
            if(copy.numMovesLeft >= 0){
                if(!validMoveLocations.canFind(adjacentCoord)){
                    validMoveLocations ~= adjacentCoord;
                }
                foreach(int[] validMoveLocation ; copy.getValidMoveLocations()){
                    if(!validMoveLocations.canFind(validMoveLocation)){
                        validMoveLocations ~= validMoveLocation;
                    }
                }
            }
        }
        return validMoveLocations;
    }

    /**
     * Moves the player based on where they want to move, and adjusts the amount of moves they have left in the turn accordingly
     * Accounts for tiles they step on and activates their getSteppedOn function
     * Returns if the move was successful
     * Params:
     *      pathToNewLocation = the path to the to-be location of the player
     */
    public bool setLocation(int[][] pathToNewLocation){
        assert(pathToNewLocation[0] != this.coords && game.mainWorld.isContiguous([this.coords] ~ pathToNewLocation)); //TODO automatically correct pathToNewLocation if incorrect rather than erroring (allows for more flexibility)
        foreach(location ; pathToNewLocation){
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

    writeln("Running unittest of Player");

    game = new Main(0, 7);
    Player testPlayer = new Player([0, 0]);
    testPlayer.numMovesLeft = 1;
    writeln("A player at [0, 0] who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    int numPlayersToTest = 4;
    for(int i = 0; i < numPlayersToTest; i++){
        int[] coords = game.mainWorld.getRandomCoords();
        testPlayer = new Player(coords);
        testPlayer.numMovesLeft = uniform(0, 5);
        writeln("A player at ", coords, " who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    }
}
