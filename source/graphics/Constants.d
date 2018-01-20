module graphics.Constants;

import std.traits;
import d2d;

iVector aspectRatio; //A vector representing the aspect ratio of the screen; both components should not share a common factor
iVector logicalSize; //The logical game size or resolution that this game draws and scales at
Surface[string] images; ///Surfaces of all of the images the game will use
Font[string] fonts; ///All the typefaces the game will use
iVector hexViewCenter; ///The position of the very center of the hex grid
int hexWidth; ///The length of the center to a vertex of each hexagon

shared static this() {
    aspectRatio = new iVector(16, 9);
    logicalSize = aspectRatio * 100;
    foreach (image; EnumMembers!Image) {
        mixin("images[image] = loadImage(\"" ~ image ~ "\");");
    }
    foreach (font; EnumMembers!Typeface) {
        mixin("fonts[font] = new Font(\"" ~ font ~ "\", 1500);");
    }
    hexViewCenter = new iVector(800, 450);
    hexWidth = 16;
}

/** 
 * A container for the paths of all of the game's soundtracks
 */
enum Soundtrack : string {
    BraveNewWorld = "res/music/BraveNewWorld.mp3",
    BraveNewWorld2 = "res/music/BraveNewWorldII.mp3",
    Enterprise = "res/music/Enterprise.mp3",
    Enterprise2 = "res/music/EnterpriseII.mp3",
    FreshAir = "res/music/FreshAir.mp3",
    FreshAir2 = "res/music/FreshAirII.mp3"
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
