import HexTile;
import std.stdio;
import core.exception;

class World{

    private HexTile[] tiles;    ///The storage array of all tiles; stored in order of ringNum and then pos

    this(int numRings){
        //Files this.tiles with a bunch of empty tiles
        for(int i = 0; i < numRings; i++){
            for(int j = 0; j < getSizeOfRing(i); j++){
                tiles ~= new HexTile([i, j]);
            }
        }
    }

    public HexTile getTileAt(int[] location){
        try{
            location[1] = location[1] % getSizeOfRing(location[0]);
            int previousTiles = 0;
            for(int i = 0; i < location[0]; i++){
                previousTiles += getSizeOfRing(i);
            }
            return this.tiles[previousTiles + location[1]];
        }catch(RangeError e){
            return null;
        }
    }

    public int getNumTiles(){
        return this.tiles.length;
    }

}

unittest{
    for(int i = 1; i < 6; i++){
        World testWorld = new World(i);
        testWorld.getNumTiles();
    }
}

public static getSizeOfRing(int ringNum){
    return (ringNum == 0)? 1 : 6 * ringNum;
}