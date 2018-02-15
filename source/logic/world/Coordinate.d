module logic.world.Coordinate;

import d2d;
import graphics.Constants;

immutable coordChangeByDirection = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1], [0, 0]]; ///Gets the change in coordinate (q, r) by each direction (as denoted below)

/**
 * The different cardinal directions on a hex grid
 */
enum Direction {
    NONE = 6,
    NORTHEAST = 5,
    EAST = 0,
    SOUTHEAST = 1,
    SOUTHWEST = 2,
    WEST = 3,
    NORTHWEST = 4
}

/** 
 * A struct representation of a hex's coordinates
 * Each hex is stored in axial coordinates
 * A hex contains two scalar values that represent distances along direction vector bases
 * The vector bases are separated by pi/3 radians
 */
class Coordinate {

    long scalar1; ///The distance along the horizontal
    long scalar2; ///The distance along the axis at a pi/3 angle below the positive horizontal

    /**
     * The distance along the axis at a 2pi/3 angle below the positive horizontal
     * Useful for functions that take cube coordinates
     */
    @property long scalar3() {
        return -scalar1 - scalar2;
    }

    this(long scalar1, long scalar2) {
        this.scalar1 = scalar1;
        this.scalar2 = scalar2;
    }

    alias q = scalar1;
    alias r = scalar2;
    alias s = scalar3;

    /**
     * Gets the coordinate as a hexagon given the map center and the hexagon side length
     */
    iPolygon!6 asHex(iVector mapCenter, int sideLength) {
        iVector hexCenter = cast(iVector) new dVector(
            mapCenter.x + this.q * hexBase.x * sideLength + this.r * hexBase.x * sideLength / 2,
            mapCenter.y + this.r * -1.5 * sideLength
        );
        return new iPolygon!6(
            new iVector(hexCenter.x, hexCenter.y + sideLength), //Bottom
            new iVector(hexCenter.x + cast(int)(sideLength * hexBase.x / 2), hexCenter.y + sideLength / 2), //Lower right
            new iVector(hexCenter.x + cast(int)(sideLength * hexBase.x / 2), hexCenter.y - sideLength / 2), //Upper right
            new iVector(hexCenter.x, hexCenter.y - sideLength), //Top
            new iVector(hexCenter.x - cast(int)(sideLength * hexBase.x / 2), hexCenter.y - sideLength / 2), //Lower left
            new iVector(hexCenter.x - cast(int)(sideLength * hexBase.x / 2), hexCenter.y + sideLength / 2), //Upper left);
        );
    }

}
