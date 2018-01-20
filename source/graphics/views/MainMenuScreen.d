module graphics.views.MainMenuScreen;

import std.algorithm;
import std.stdio;
import d2d;
import graphics.Constants;

/**
 * The main menu screen
 * The entry point for the game
 */
class MainMenuScreen : Screen {

    Sound!(SoundType.Music) mainMenuTheme; ///The main menu theme; loops forever

    /**
     * The constructor for a main menu
     */
    this(Display container) {
        super(container);
        this.mainMenuTheme = new Sound!(SoundType.Music)(Soundtrack.FreshAir2);
    }

    /**
     * Handles keyboard and mouse events
     */
    void handleEvent(SDL_Event event) {
    }

    /**
     * Action taken every frame
     */
    override void onFrame() {
    }

    /**
     * Draw instructions for the window
     */
    override void draw() {
    }

}
