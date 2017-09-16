/**
 * Everything in this module is coded like cancer
 * Lots of large lists of fields that seem like they can be abstracted in some way
 * I have not found a way to abstract them
 * I was able to abstract traits, but because those required templates, that was as far as I could abstract
 */
module item.plant.PlantTraits;

import std.algorithm;
import std.array;
import std.conv;
import std.math;

import character.Character;
import item.Item;
import item.plant.Plant;
import world.World;

/**
 * Specifies how a trait should show up
 * A higher inheritance type dominates over a lower inheritance type and so the lower ones would not show up
 * Co-dominant and co-recessive traits can show up together, but can be dominated as well
 * Does not support incomplete dominance where traits are mixed because of the slotting nature of traits
 */
enum VisibilityType{
    WEAK_RECESSIVE, CO_RECESSIVE, STRONG_RECESSIVE, WEAK_DOMINANT, CO_DOMINANT, STRONG_DOMINANT
}

/**
 * The type of actions a trait fulfills
 */
enum ActionType{
    MUTATION_CHANCE, SEED_LOCATION, OWNER, PLACEABLE, MOVEMENT_COST, STEPPED_ON, INCREMENTAL, MAIN, DESTROYED, SIZE, COLOR, USEFULNESS
}

/**
 * Stores an trait name, how the trait is visible, and what the trait does when slotted
 * Is as it is so that each trait is slottable and has an effect in some way for when it is slotted
 */
abstract class Trait{

    ActionType type;                ///The type of action this trait acts as
    VisibilityType visibility;      ///How the trait would surface
    Point difficulty;               ///The difficulty of this trait; traits close together are closely related and more likely to mutate into each other, but farther away traits are more likely to be mutually exclusive and are harder to obtain together
    //alias action this;            Ideally makes it so the trait is accessible as what it does, but it doesn't work

    /**
     * A constructor for a trait
     * Takes in all the fields for a trait
     * Params:
     *      type = what purpose this trait fulfills
     *      visibility = how this trait would surface in a plant
     *      difficulty = its location as a coordinate; the further from 0 it is, the more difficult it is to obtain; attributes closer to each other are more likely to mutate into each other
     */
    this(ActionType type, VisibilityType visibility, Point difficulty){
        this.type = type;
        this.visibility = visibility;
        this.difficulty = difficulty;
        allActions ~= this;
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one of trait's methods, not all of them
     */
    int getInt(Plant forWhom){
        assert([ActionType.MUTATION_CHANCE, ActionType.SIZE].canFind(this.type));
        return 0;
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    Coordinate getCoordinate(Plant forWhom){
        assert([ActionType.SEED_LOCATION].canFind(this.type));
        return Coordinate();
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    Character getCharacter(Plant forWhom){
        assert([ActionType.OWNER].canFind(this.type));
        return null;
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    bool getBool(Coordinate location, Plant forWhom){
        assert([ActionType.PLACEABLE].canFind(this.type));
        return false;
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    double getDouble(Character actor, Plant forWhom){
        assert([ActionType.MOVEMENT_COST].canFind(this.type));
        return 0;
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    void doSomething(Character actor, Plant forWhom){
        assert([ActionType.STEPPED_ON, ActionType.MAIN, ActionType.DESTROYED].canFind(this.type));
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    void doSomething(Plant forWhom){
        assert([ActionType.INCREMENTAL].canFind(this.type));
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    Color getColor(Plant forWhom){
        assert([ActionType.COLOR].canFind(this.type));
        return Color();
    }

    /**
     * One type of action a trait may have
     * Isn't abstract because traits only need to override one one of trait's methods, not all of them
     */
    double getDouble(Plant forWhom){
        assert([ActionType.USEFULNESS].canFind(this.type));
        return 0;
    }

}

/**
 * A point in 2 dimensional space
 * Is only used to organize traits into a plane to see how related traits may be
 * Traits that are far away from each other are difficult to obtain in a single category
 * Traits that are on opposite axes (eg quadrants 1 and 3 or quadrants 2 and 4) are mutually exclusive
 * Traits close to the origin are naturally occuring
 * The closer traits are, the more related they are and the more likely one will mutate into the other were they to mutate
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
 * Returns whether two traits are mutually exclusive
 * Mutually exclusive traits are traits that are respectively in cartesian quadrants 1 and 3 or 2 and 4
 */
bool canWorkTogether(Trait first, Trait second){
    return (first.difficulty.x < 0) == (second.difficulty.x < 0) || (first.difficulty.y < 0) == (second.difficulty.y < 0);
}

/**
 * Contains a list of traits
 * Is a struct so that the list of traits can be accessed like an associative array
 */
struct TraitSet{

    Trait[] allTraits;      ///All the traits within this trait set
    alias allTraits this;   ///Allows the traitset to be accessed as its traits

    /**
     * Allows the traits in the traitset to be accessed by category as if the traitset were an associative array
     */
    Trait[] opIndex(ActionType category){
        return allTraits.filter!(a => a.type == category).array;
    }

}

/**
 * Gets all the traits from the set that would actually be visible
 * So if a category were to, for example, have a dominant and a recessive trait in a category, it would return the category with only the dominant trait
 */
TraitSet getVisibleTraits(TraitSet traitset){
    //TODO
    return TraitSet();
}

/**
 * Combines two trait sets by randomly taking a trait from one set for a category and mixing it with another random trait from the other set of the same category
 * Does the above for all categories
 * Params:
 *      first = the first traitset to be a part of the combined set
 *      second = the second traitset to be a part of the combined set
 */
TraitSet combineTraitSets(TraitSet first, TraitSet second){
    //TODO
    return TraitSet();
}

/**
 * Gets a mutated version of the given set
 * Most likely scenario is that nothing changes
 * Params:
 *      initial = the traitset to start off with; any mutation happen off of this initial set
 *      forWhom = the plant for whom this traitset is being made for
 */
TraitSet getPossiblyMutatedSetOf(TraitSet initial, Plant forWhom){
    //TODO
    return TraitSet();
}

/**
 * A collection of things that would define a pre-defined plant
 * Any plant would be compared to all default plants to figure out what species the plant is by whatever default plant it is closest to
 */
class DefaultPlant{
    string name;                    ///The name of this defualt plant so the player can find out what species their plant is
    TraitSet defaultTraits;         ///The set of traits the plant has by default
    bool isNatural;                 ///Whether the plant occurs naturally

    /**
     * Compares a plant to this pre-defined plant to see how close they are
     * The closest pre-defined plant is its species
     */
    double closenessTo(Plant toCompare){
        //TODO
        return -1;
    }
}

TraitSet allActions;                        ///Stores a set of all actions
DefaultPlant[] allDefaultPlants;            ///Stores all default plants so that any plant can be compared to this list, and whichever plant it is closest to is its species
