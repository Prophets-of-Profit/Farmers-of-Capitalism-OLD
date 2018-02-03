module graphics.Constants;

import std.math;
import std.traits;
import d2d;

iVector aspectRatio; //A vector representing the aspect ratio of the screen; both components should not share a common factor
iVector logicalSize; //The logical game size or resolution that this game draws and scales at
Surface[string] images; ///Surfaces of all of the images the game will use
Font[string] fonts; ///All the typefaces the game will use
dVector hexBase; ///The size of the rectangle in which a hexagon of side length 1 is inscribed

shared static this() {
    aspectRatio = new iVector(16, 9);
    logicalSize = aspectRatio * 100;
    hexBase = new dVector(sqrt(3.0), 2);
    foreach (image; EnumMembers!Image) {
        mixin("images[image] = loadImage(\"" ~ image ~ "\");");
    }
    foreach (font; EnumMembers!Typeface) {
        mixin("fonts[font] = new Font(\"" ~ font ~ "\", 1500);");
    }
}

/** 
 * A container for the paths of all of the game's soundtracks
 */
enum Soundtrack : string {
    Title = "res/music/title.mp3",
}

/** 
 * A container for the paths of all of the game's sound effects
 */
enum SoundEffect : string {
    None = "" //TODO: Get rid of this when we actually have sound effects
}

/**
 * A container for the paths of all of the game's images
 */
enum Image : string {
    TempIcon = "res/pictures/TempIcon.png"
}

/**
 * A container for the paths of all of the game's fonts
 */
enum Typeface : string {
    OpenSansRegular = "res/fonts/OpenSansRegular.ttf"
}
