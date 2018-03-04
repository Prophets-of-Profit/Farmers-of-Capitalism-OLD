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
 */
abstract class Trait {

    immutable iVector location; ///Where the trait is in "trait-space"; close traits are similar and more likely to mutate into eachother than further traits

    /**
     * The trait, when called will perform its action
     * This is the trait's behaviour
     */
    void opCall(Plant plant);

    /**
     * How dominant the trait is when compared to other traits; determines whether it will surface or not
     */
    int dominance(Plant plant);

    /**
     * Returns all qualities that the trait gives to a plant
     */
    Quality[] qualities(Plant plant);

}

alias TraitSet = Trait[][TraitExpression];
