module logic.world.Coordinate;

/** 
 * A struct representation of a hex's coordinates
 * Each hex is stored in axial coordinates
 * A hex contains two scalar values that represent distances along direction vector bases
 * The vector bases are separated by pi/3 radians
 */
struct Coordinate {

    int scalar1; ///The distance along the horizontal
    int scalar2; ///The distance along the axis at a pi/3 angle above the horizontal
    alias q = scalar1;
    alias r = scalar2;

}
