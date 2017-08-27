module item.plant.PlantTraits;

import std.conv;
import std.math;
import std.random;

import character.Character;
import item.plant.Plant;
import world.Range;
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
 * Stores an attribute name, how the attribute is visible, and what the attribute does when slotted
 * Action is ideally a delegate
 * Is as it is so that each attribute is slottable and has an effect in some way for when it is slotted
 */
struct Attribute(T){
    string name;                    ///The name of this attribute
    VisibilityType type;            ///How the attribute would surface
    T action;                       ///What this attribute would do when slotted; is ideally a delegate
    Point difficulty;               ///The difficulty of this attribute; attributes close together are closely related and more likely to mutate into each other, but farther away attributes are more likely to be mutually exclusive and are harder to obtain together
    alias action this;              ///Makes it so the attribute is accessible as what it does
}

/**
 * A point in 2 dimensional space
 * Is only used to organize attributes into a plane to see how related attributes may be
 * Attributes that are far away from each other are difficult to obtain in a single category
 * Attributes that are on opposite axes (eg quadrants 1 and 3 or quadrants 2 and 4) are mutually exclusive
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
double distance(Point first, Point second = Point(0, 0)){
    return sqrt(((first.x - second.x).pow(2) + (first.y - second.y).pow(2)).to!double);
}

/**
 * Returns whether two attributes are mutually exclusive
 * Mutually exclusive attributes are attributes that are respectively in cartesian quadrants 1 and 3 or 2 and 4
 */
bool canWorkTogether(T)(Attribute!T first, Attribute!T second){
    return (first.difficulty.x < 0) == (second.difficulty.x < 0) || (first.difficulty.y < 0) == (second.difficulty.y < 0);
}

/**
 * A struct that stores a set of attributes
 * Stores them by the type of functions an item would require
 */
struct AttributeSet{
    Attribute!(Character delegate(Plant))[] getOwnerActions;
    Attribute!(bool delegate(Coordinate, Plant))[] canBePlacedActions;
    Attribute!(double delegate(Character, Plant))[] getMovementCostActions;
    Attribute!(void delegate(Character, Plant))[] steppedOnActions;
    Attribute!(void delegate(Plant))[] incrementalActions;
    Attribute!(void delegate(Character, Plant))[] mainActions;
    Attribute!(void delegate(Character, Plant))[] destroyedActions;
    Attribute!(int delegate(Plant))[] getSizeActions;

    /**
     * Gets all the attributes from the set that would actually be visible
     * So if a category were to, for example, have a dominant and a recessive trait in a category, it would return the category with only the dominant trait
     */
    AttributeSet getVisibleAttributes(){
        //This is the method that actually filters each category into its visible attributes
        Attribute!(T)[] filterVisible(T)(Attribute!(T)[] category){
            Attribute!(T)[] visible = [category[0]];
            foreach(attribute; category){
                if(attribute.type > visible[0].type){
                    visible = [attribute];
                }else if(visible[0].type == attribute.type){
                    void randVisible(){
                        visible = [(uniform(0, 2) == 0)? visible[0] : attribute];
                    }
                    if(attribute.type == VisibilityType.CO_RECESSIVE || attribute.type == VisibilityType.CO_DOMINANT){
                        if(canWorkTogether!T(visible[0], attribute)){
                            visible ~= attribute;
                        }else{
                            randVisible();
                        }
                    }else{
                        //Will choose the attribute with the lesser distance, or if the distances are the same, a random attribute
                        double alreadyExistingDistance = visible[0].difficulty.distance;
                        double challengerDistance = attribute.difficulty.distance;
                        if(Range!double(alreadyExistingDistance - 0.000001, alreadyExistingDistance + 0.000001).isInRange(challengerDistance)){
                            randVisible();
                        }else{
                            visible = [(alreadyExistingDistance < challengerDistance)? visible[0] : attribute];
                        }
                    }
                }
            }
            return visible;
        }
        //Just returns the above method called on each category
        return AttributeSet(
            filterVisible(this.getOwnerActions),
            filterVisible(this.canBePlacedActions),
            filterVisible(this.getMovementCostActions),
            filterVisible(this.steppedOnActions),
            filterVisible(this.incrementalActions),
            filterVisible(this.mainActions),
            filterVisible(this.destroyedActions),
            filterVisible(this.getSizeActions)
        );
    }
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
