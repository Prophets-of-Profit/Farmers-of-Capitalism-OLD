module logic.item.Attribute;

/**
 * Defines a bundle of data that represents a qualitative aspect an item can have
 */
struct Attribute {
    string name; ///The name of the attribute or what it's called
    string description; ///A description of the attribute or what it does
    immutable int baseValue; ///The base value for what markets initially think of this attribute
}

/**
 * An enum that enumerates all the types of qualitative aspects in the game
 */
enum Quality : Attribute {

    SOFT = Attribute("Soft", "Soft. Not micro. Yet.", 100),
    DIRTY = Attribute("Dirty", "Can be compared to that uncle you have.", -5)

}
