module graphics.views.MainMenuScreen;

import std.algorithm;
import std.stdio;
import d2d;
import graphics.Constants;
import graphics.views.TempMapTestScreen;

/**
 * The main menu screen
 * The entry point for the game
 */
class MainMenuScreen : Screen {

    Sound!(SoundType.Music) mainMenuTheme; ///The main menu theme; loops forever

    /**
     * The constructor for a main menu
     */
    this(Display display) {
        super(display);
        this.mainMenuTheme = new Sound!(SoundType.Music)(Soundtrack.FreshAir2);
        //Temporary button
        this.components ~= new class Button {

            this() {
                super(display, new iRectangle(0, 0, 1600, 900));
            }

            override void action() {
                this.container.screen = new TempMapTestScreen(display);
            }

            override void draw() {}
        };
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
