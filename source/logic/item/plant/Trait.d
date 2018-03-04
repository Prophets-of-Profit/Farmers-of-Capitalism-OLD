module logic.item.plant.Trait;

import d2d;
import logic.item.Attribute;
import logic.item.plant.Plant;

/**
 * Categories for where/when a trait can be expressed
 */
enum TraitExpression {
    STEPPED_ON, INCREMENT, MAIN, CREATED, DESTROYED
}

/**
 * A plant's trait
 * Traits determine the behaviour of plants and are passed on offspring
 * TODO: find way to determine trait's dominance
 */
private abstract class Trait {

    immutable iVector location; ///Where the trait is in "trait-space"; close traits are similar and more likely to mutate into eachother than further traits
    immutable Quality[] qualities; ///All qualities that the trait gives to a plant

    /**
     * The trait, when called will perform its action
     * This is the trait's behaviour
     */
    void opCall(Plant plant);

}

alias TraitSet = Trait[][TraitExpression];

/**
 * Gets the phenotype or observable traits of a traitset
 * These are the traits that a plant will actually exhibit
 */
TraitSet phenotype(TraitSet genotype) {
    return null; //TODO:
}

///All traits that exist in the game
static immutable TraitSet allTraits;

///Initializes all of the traits
shared static this() {
    allTraits = [
        TraitExpression.STEPPED_ON : [

        ],
        TraitExpression.INCREMENT : [

        ],
        TraitExpression.MAIN : [

        ],
        TraitExpression.CREATED : [

        ],
        TraitExpression.DESTROYED : [

        ]
    ]; 
}
