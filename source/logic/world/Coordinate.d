module logic.world.Coordinate;

/**
 * The different cardinal directions on a hex grid
 */
enum Direction : int{
    NONE = 6,
    NORTHEAST = 4,
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
struct Coordinate {

    int scalar1; ///The distance along the horizontal
    int scalar2; ///The distance along the axis at a pi/3 angle below the positive horizontal

    /**
     * The distance along the axis at a 2pi/3 angle below the positive horizontal
     * Useful for functions that take cube coordinates
     */
    @property int scalar3() {
        return -scalar1 - scalar2;
    }

    alias q = scalar1;
    alias r = scalar2;
    alias s = scalar3;


    //TODO: add method to convert a coordinate to a d2d hexagonal polygon

}
