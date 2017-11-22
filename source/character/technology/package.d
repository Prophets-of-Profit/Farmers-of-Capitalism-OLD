module character.technology;

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
