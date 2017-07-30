module app;

import world.World;
import player.Player;

static Main main; ///The entire game

/**
 * The entire game class
 */
class Main{

    public World mainWorld;         ///The world on which the game is played.
    public Player[] players;        ///The players of the game. Length of array is how many players.

    /*
     * "You've beat me at my own game!"
     * "Don't fool yourself; you were never even a Player(int[] coords);
     */

    this(int numPlayers, int worldSize){
        for(int i = 0; i < numPlayers; i++){
            players ~= new Player([0,0]);       //TODO: Add corner selection for player placement.
        }
        mainWorld = new World(worldSize);
    }

}

void main(){

}
