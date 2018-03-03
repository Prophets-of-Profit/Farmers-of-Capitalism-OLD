module logic.item.plant.Trait;

import d2d;

/**
 * A plant's trait
 * Traits determine the behaviour of plants and are passed on offspring
 */
abstract class Trait(T) {

    immutable iVector location; ///Where the trait is in "trait-space"; close traits are similar and more likely to mutate into eachother than further traits
    immutable TraitModel!T model; ///Where the trait was created from

    /**
     * Creates a trait from a model and an action
     */
    package this(TraitModel!T model) {
        this.model = model;
    }

    /**
     * The trait, when called will perform its action
     * This is the trait's behaviour
     */
    T opCall(Plant plant);

    /**
     * How dominant the trait is when compared to other traits; determines whether it will surface or not
     */
    int dominance(Plant plant);

}
