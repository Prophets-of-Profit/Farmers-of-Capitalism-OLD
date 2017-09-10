module Initializer;

import std.conv;

/**
 * Initializes all events
 */
shared static this(){
    import world.event.Event;
    foreach(name; __traits(allMembers, EventNames)){
        mixin("import world.event." ~ name ~ ";");
        foreach(i; 0..name.to!EventNames.to!int){
            mixin("allEvents ~= new " ~ name ~ "();");
        }
    }
}

/**
 * Initializes all technologies
 */
shared static this(){
    import character.technology.Technology;
    foreach(name; __traits(allMembers, TechnologyName)){
        mixin("import character.technology." ~ name ~ ";");
        mixin("allTechnologies[TechnologyName." ~ name ~ "] = new " ~ name ~ "();");
    }
}
