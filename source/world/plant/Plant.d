import Item;
import Player;
import std.random;

/**
* A parent class for all plant objects.
* Contains basic (non-functional) traits and methods shared between all plants.
*/
class Plant : Item{

    private string[] incrementalActions;    ///Stores actions taken every turn in the form of string method names.
    private string[] steppedOnActions;      ///Stores actions taken when stepped on in the form of string method names.
    private string[] mainActions;           ///Stores actions taken when interacted with in the form of string method names.
    private string[] destroyedActions;      ///Stores actions taken when destroyed in the form of string method names.
    private string[] placedActions;         ///Stores actions taken when placed in the form of string method names.
    private int[string] attributes;         ///Stores passive (constantly applied) attributes in the form of strings, with levels from 1 to 5 in the form of ints.
    private int[string] stats;              ///Stores base stats as integers on a scale of 1 to 5. Indexed by stat as string.

    /**
    * The constructor for a plant.
    *
    */

    this(string[] turnActions, string[] stepActions, string[] mainActions, string[] deadActions, string[] placeActions, int[string] attributes, int[string] stats){
        this.incrementalActions = turnActions;
        this.steppedOnActions = stepActions;
        this.mainActions = mainActions;
        this.destroyedActions = deadActions;
        this.placedActions = placeActions;
        this.attributes = attributes;
        this.stats = stats;
    }

    public Player getOwner();
    public bool canBePlaced(int[] placementCandidateCoords);
    public double getMovementCost();

    /**
    * Dictates what the plant does when placed.
    * Iterates through the plant's placedActions, executing each one.
    */
    public void getPlaced(Player placer, int[] newLocation){
        if(this.isPlaced){
            for(int i = 0; i < this.steppedOnActions.length; i++){
                mixin(this.steppedOnActions[i]);
            }
        }
    }

    /**
    * Dictates what the plant does when stepped on.
    * Iterates through the plant's steppedOnActions, executing each one.
    */
    public void getSteppedOn(Player stepper){
        if(this.isPlaced){
            for(int i = 0; i < this.steppedOnActions.length; i++){
                mixin(this.steppedOnActions[i]);
            }
        }
    }

    /**
    * Dictates what the plant does each turn.
    * Iterates through the plant's incrementalActions, executing each one.
    */
    public void doIncrementalAction(){
        if(this.isPlaced){
            for(int i = 0; i < this.incrementalActions.length; i++){
                mixin(this.incrementalActions[i]);
            }
        }
    }

    /**
    * Dictates what the plant does when interacted with.
    * Iterates through the plant's mainActions, executing each one.
    */
    public void doMainAction(Player player){
       if(this.isPlaced){
           for(int i = 0; i < this.mainActions.length; i++){
               mixin(this.mainActions[i]);
           }
       }
    }

    /**
    * Dictates what the plant does when destroyed.
    * Iterates through the plant's destroyedActions, executing each one.
    */
    public void getDestroyed(Player destroyer){
        if(this.isPlaced){
            for(int i = 0; i < this.destroyedActions.length; i++){
                mixin(this.destroyedActions[i]);
            }
        }
    }


    public Item clone();
}
