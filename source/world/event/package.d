module world.event;

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