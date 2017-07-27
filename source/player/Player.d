module player.Player;

import app;
import world.World;
import player.Inventory;
import std.algorithm;
import std.array;

/**
 * A class for each player
 * Stores basic data for each player and contains methods for performing actions as/with the player
 */
public class Player{

    public int[] coords;                            ///The location of the player stored as [ringNum, pos]
    public int maxTravellableDistance = 5;          ///The most distance the player can move in one turn
    public double numMovesLeft;                     ///The amount of moves the player can still do this turn
    public Inventory inventory = new Inventory();   ///The player's inventory

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
        foreach(int[] adjacentCoord ; mainWorld.getTileAt(this.coords).getAdjacentCoords()){
            Player copy = new Player(adjacentCoord);
            copy.numMovesLeft = this.numMovesLeft - mainWorld.getTileAt(adjacentCoord).getPassabilityCost();
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
        assert(pathToNewLocation[0] != this.coords && mainWorld.isContiguous([this.coords] ~ pathToNewLocation)); //TODO automatically correct pathToNewLocation if incorrect rather than erroring (allows for more flexibility)
        foreach(int[] location ; pathToNewLocation){
            if(this.numMovesLeft > 0 && location != this.coords && this.getValidMoveLocations().canFind(location)){
                this.coords = location;
                foreach(item; mainWorld.getTileAt(location).contained){
                    item.getSteppedOn(this);
                }
                this.numMovesLeft -= mainWorld.getTileAt(location).getPassabilityCost();
                return true;
            }
        }
        return false;
    }

}

unittest{
    import std.stdio;
    import std.random;
    
    writeln("Running unittest of Player");
    
    mainWorld = new World(7);
    Player testPlayer = new Player([0, 0]);
    testPlayer.numMovesLeft = 1;
    writeln("A player at [0, 0] who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    int numPlayersToTest = 4;
    for(int i = 0; i < numPlayersToTest; i++){
        int[] coords = mainWorld.getRandomCoords();
        testPlayer = new Player(coords);
        testPlayer.numMovesLeft = uniform(0, 5);
        writeln("A player at ", coords, " who can move ", testPlayer.numMovesLeft, " tiles can move to ", testPlayer.getValidMoveLocations());
    }
}
