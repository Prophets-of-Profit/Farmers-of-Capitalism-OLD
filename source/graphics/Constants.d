module graphics.Constants;

import std.math;
import std.traits;
import d2d;

iVector aspectRatio; //A vector representing the aspect ratio of the screen; both components should not share a common factor
iVector logicalSize; //The logical game size or resolution that this game draws and scales at
Surface[Image] images; ///Surfaces of all of the images the game will use
Texture[Image] textures; ///A list of all textures
Font[Typeface] fonts; ///All the typefaces the game will use
dVector hexBase; ///The size of the rectangle in which a hexagon of side length 1 is inscribed
iVector minimapHexSize; ///The minimum and maximum sizes of hexes in the minimap by side length

shared static this() {
    aspectRatio = new iVector(16, 9);
    logicalSize = aspectRatio * 100;
    hexBase = new dVector(sqrt(3.0), 2);
    minimapHexSize = new iVector(10, 50);
    foreach (image; EnumMembers!Image) {
        mixin("images[image] = loadImage(\"" ~ image ~ "\");");
    }
    foreach (font; EnumMembers!Typeface) {
        mixin("fonts[font] = new Font(\"" ~ font ~ "\", 1500);");
    }
}

/**
 * Updates all the textures using the surfaces of those textures
 */
void updateTextures(Renderer renderer) {
    foreach (image; EnumMembers!Image) {
        textures[image] = new Texture(images[image], renderer);
    }
}

/**
 * A container for the paths of all of the game's soundtracks
 */
enum Soundtrack : string {
    Title = "res/music/Enterprise.mp3",
    Sprouts = "res/music/Sprouts.mp3"
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
    Icon = "res/pictures/Icon.png",
    BiomePlains = "res/pictures/biome/Plains.png",
    BiomeRedwood = "res/pictures/biome/Redwood.png",
    BiomeOak = "res/pictures/biome/Oak.png",
    InvBox = "res/pictures/ui/InventoryBox.png",
    PearItem = "res/pictures/item/Pear.png",
    TomatoItem = "res/pictures/item/Tomato.png"
}

/**
 * A container for the paths of all of the game's fonts
 */
enum Typeface : string {
    OpenSansRegular = "res/fonts/OpenSansRegular.ttf"
}
