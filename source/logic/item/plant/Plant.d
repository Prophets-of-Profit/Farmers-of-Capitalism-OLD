module logic.item.plant.Plant;

import std.traits;
import graphics.Constants;
import logic.item.Attribute;
import logic.item.Inventory;
import logic.item.Item;
import logic.item.plant.Species;
import logic.item.plant.Trait;
import logic.Player;

/**
 * A plant class that encompasses the behaviour of ALL plants
 * Plant behaviour and attributes are determined mostly by their traits and also potentially partially from their species
 * TODO:
 */
class Plant : Item {

    package double _completion; ///How grown the plant is
    TraitSet traits; ///All the traits the plant has
    immutable Breed species; ///What species the plant is
    Player currentActor; ///The player that is currently interacting with the plant

    /**
     * Gets the name of the plant; based on its species
     */
    override @property string name() {
        return this.species.name;
    }

    /**
     * Gets the description of the plant; based on its species
     */
    override @property string description() {
        return this.species.description;
    }

    /**
     * The plant will always look like whatever species it is
     */
    override @property Image representation() {
        return this.species.representation;
    }

    /**
     * Gets how complete or mature the plant is
     */
    override @property double completion() {
        return this._completion;
    }

    /**
     * Gets the qualitative aspects of the plant
     */
    override @property Quality[] qualities() {
        Quality[] allQuals;
        foreach(expr; EnumMembers!TraitExpression) {
            foreach(trait; this.traits[expr]) {
                allQuals ~= trait.qualities(this);
            }
        }
        return allQuals;
    }

    /**
     * Necessary constructor for all items
     */
    this(Inventory container, TraitSet traits) {
        super(container);
        this.traits = traits;
        this.species = getSpecies(traits);
    }

    override void onStep(Player actor) {
        this.currentActor = actor;
        //TODO:
        this.currentActor = null;
    }

    override void incrementalAction() {
        //TODO:
    }

    override void mainAction(Player actor) {
        this.currentActor = actor;
        //TODO:
        this.currentActor = null;
    }

    override void onCreate(Player actor) {
        this.currentActor = actor;
        //TODO:
        this.currentActor = null;
    }

    override void onDestroy(Player actor) {
        this.currentActor = actor;
        //TODO:
        this.currentActor = null;
    }

}
