module logic.item.Attribute;

/**
 * Defines a bundle of data that represents a qualitative aspect an item can have
 */
struct Attribute {
    string name;
    string description;
    immutable int baseValue;
}

/**
 * An enum that enumerates all the types of qualitative aspects in the game
 */
enum Quality : Attribute {

    SOFT = Attribute("Soft", "Soft. Not micro. Yet.", 100),
    DIRTY = Attribute("Dirty", "Can be compared to that uncle you have.", -5)

}
