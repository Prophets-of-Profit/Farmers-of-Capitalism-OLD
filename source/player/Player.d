import app;
import World;
import std.algorithm;

/**
 * A class for each player
 * Stores basic data for each player and contains methods for performing actions as/with the player
 */
public class Player{

    public int[] coords;                    ///The location of the player stored as [ringNum, pos]
    public int maxTravellableDistance = 5;  ///The most distance the player can move in one turn
    public int numMovesLeft;                ///The amount of moves the player can still do this turn

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
        int[][] validLocations = [coords.dup];
        for(int i = 0; i < this.numMovesLeft; i++){
            foreach(int[] traversableCoordinate ; validLocations){
                foreach(int[] candidate; mainWorld.getTileAt(traversableCoordinate).getAdjacentTiles()){
                    if(!validLocations.canFind(candidate)){
                        validLocations ~= candidate;
                    }
                }
            }
        }
        return validLocations;
    }

    /**
     * Moves the player based on where they want to move, and adjusts the amount of moves they have left in the turn accordingly
     * Returns if the move was successful
     * Params:
     *      newLocation = to-be location of the player
     */
    public bool setLocation(int[] newLocation){
        if(numMoves /* TODO - World.getDistanceBetween(coords, location) */ > 0 && newLocation !is null && this.getValidMoveLocations().canFind(newLocation)){
            //TODO this.numMovesLeft -= World.getDistanceBetween(coords, location)
            this.coords = newLocation.dup;
            return true;
        }
        return false;
    }

}

unittest{
    //TODO add tests for the class
}