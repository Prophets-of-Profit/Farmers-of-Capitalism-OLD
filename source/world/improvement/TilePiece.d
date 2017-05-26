abstract class TilePiece{

    int completion;
    int[] coords;

    this(int[] coords){
        this.coords = coords;
    }

    public abstract void getSteppedOn();
    public abstract double getCompletionPercentage();
    public abstract void doIncrementalAction();
    public abstract void doMainAction();
    public abstract void getDestroyed();

}