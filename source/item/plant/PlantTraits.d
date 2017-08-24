module item.plant.PlantTraits;

import std.conv;
import std.math;

import character.Character;
import world.World;

/**
 * Specifies how a trait should show up
 * A higher inheritance type dominates over a lower inheritance type and so the lower ones would not show up
 * Co-dominant and co-recessive traits can show up together, but can be dominated as well
 * Does not support incomplete dominance where traits are mixed because of the slotting nature of attributes
 */
enum VisibilityType{
    WEAK_RECESSIVE, CO_RECESSIVE, STRONG_RECESSIVE, WEAK_DOMINANT, CO_DOMINANT, STRONG_DOMINANT
}

/**
 * Stores an attribute name, how the attribute passes down, and what the attribute does when slotted
 * Action is ideally a delegate
 * Is as it is so that each attribute is slottable and has an effect in some way for when it is slotted
 */
struct Attribute(T){
    string name;                    ///The name of this attribute
    VisibilityType inheritance;     ///How the attribute would surface
    T action;                       ///What this attribute would do when slotted; is ideally a delegate
    Point difficulty;               ///The difficulty of this attribute; attributes close together are closely related and more likely to mutate into each other, but farther away attributes are more likely to be mutually exclusive and are harder to obtain together
    alias action this;              ///Makes it so the attribute is accessible as what it does
}

/**
 * A point in 2 dimensional space
 * Is only used to organize attributes into a plane to see how related attributes may be
 * Attributes that are far away from each other are difficult to obtain in a single category
 * If attributes are too far away from each other, they may be mutually exclusive
 * Attributes close to the origin are naturally occuring
 * The closer attributes are, the more related they are and the more likely one will mutate into the other were they to mutate
 */
struct Point{
    int x;              ///The x value of the point
    int y;              ///The y value of the point
    alias coords this;  ///Allows the point to be accessed as an array of its points

    /**
     * Gets the point as an array of its points
     */
    @property int[] coords(){
        return [x, y];
    }
}

/**
 * Gets the distance between two points
 */
double distanceBetween(Point first, Point second){
    return sqrt(((first.x - second.x).pow(2) + (first.y - second.y).pow(2)).to!double);
}

/**
 * A struct that stores a set of attributes
 * Stores them by the type of functions an item would require
 */
struct AttributeSet{
    Attribute!(Character delegate())[] getOwnerActions;
    Attribute!(bool delegate(Coordinate))[] canBePlacedActions;
    Attribute!(double delegate(Character))[] getMovementCostActions;
    Attribute!(void delegate(Character))[] steppedOnActions;
    Attribute!(void delegate())[] incrementedActions;
    Attribute!(void delegate(Character))[] mainActions;
    Attribute!(void delegate(Character))[] destroyedActions;
    Attribute!(int delegate())[] getSizeActions;
}

/**
 * A collection of things that would define a pre-defined plant
 * Any plant would be compared to all default plants to figure out what species the plant is by whatever default plant it is closest to
 */
struct DefaultPlant{
    string name;                    ///The name of this defualt plant so the player can find out what species their plant is
    AttributeSet defaultAttributes; ///The set of attributes the plant has by default
    bool isNatural;                 ///Whether the plant occurs naturally
}

AttributeSet allActions = AttributeSet();   ///Stores a set of all actions
DefaultPlant[] allDefaultPlants;            ///Stores all default plants so that any plant can be compared to this list, and whichever plant it is closest to is its species
