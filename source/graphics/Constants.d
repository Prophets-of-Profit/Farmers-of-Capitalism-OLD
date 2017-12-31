module graphics.Constants;

import d2d;

iVector aspectRatio; //A vector representing the aspect ratio of the screen; both components should not share a common factor
iVector logicalSize; //The logical game size or resolution that this game draws and scales at

shared static this() {
    aspectRatio = new iVector(16, 9);
    logicalSize = aspectRatio * 100;
}

/** 
 * A container for all of the game's soundtracks that will be Sound!(SoundType.Music) in d2d
 */
enum Soundtrack : string {
    Brave_New_World = "res/music/Brave New World.mp3",
    Brave_New_World_2 = "res/music/Brave New World II.mp3",
    Enterprise = "res/music/Enterprise.mp3",
    Enterprise_2 = "res/music/Enterprise_II.mp3",
    Fresh_Air = "res/music/Fresh Air.mp3",
    Fresh_Air_2 = "res/music/Fresh Air II.mp3"
}

/** 
 * A container for all of the game's sound effects that will be Sound!(SoundType.Chunk) in d2d
 */
enum SoundEffect : string {
    None = "" //Get rid of this when we actually have sound effects
}

/**
 * A container for all of the game's images
 */
enum Image : string {
    TempIcon = "res/pictures/TempIcon.png"
}

/**
 * A container for all of the game's fonts
 */
enum Typeface : string {
    None = "" //Get rid of this when we actually have sound effects
}
