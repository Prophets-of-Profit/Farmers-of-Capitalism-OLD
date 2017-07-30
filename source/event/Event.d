/**
 * Handles timed events during the game.
 */

module event.Event;

abstract class Event{

    public abstract void startAction();         ///The action taken when the event starts.
    public abstract void endAction();           ///The action taken when the event ends.
    public abstract void turnAction();          ///The action taken when the event is.
    public abstract int[][] coordsAffected();   ///Returns any coords corresponding to tiles affected by the event.
    public abstract bool canHappen();           ///Checks if the event can.

}
