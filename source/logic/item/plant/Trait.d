module logic.item.plant.Trait;

import d2d;
import logic.item.plant.Plant;

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

}

/**
 * A container struct for holding all traits a plant would have/need
 */
struct TraitSet {

    Trait[] steppedOnTraits;
    Trait[] incrementTraits;
    Trait[] interactedTraits;
    Trait[] createdTraits;
    Trait[] destroyedTraits;

}