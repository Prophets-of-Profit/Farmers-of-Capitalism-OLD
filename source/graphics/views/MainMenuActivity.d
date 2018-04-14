module graphics.views.MainMenuActivity;

import std.algorithm;
import std.stdio;
import d2d;
import graphics.Constants;
import graphics.views.MainGameActivity;
import logic.world.GameWorld;

/**
 * The main menu activity
 * The entry point for the game
 */
class MainMenuActivity : Activity {

    Sound!(SoundType.Music) mainMenuTheme; ///The main menu theme

    /**
     * The constructor for a main menu
     */
    this(Display display) {
        super(display);
        this.mainMenuTheme = new Sound!(SoundType.Music)(Soundtrack.Title);
        //Temporary button
        this.components ~= new class Button {

            this() {
                super(display, new iRectangle(0, 0, 1600, 900));
            }

            override void action() {
                this.container.activity = new MainGameActivity(display, new GameWorld(5));
            }

            override void draw() {}
        };
    }

    /**
     * Handles keyboard and mouse events
     */
    override void handleEvent(SDL_Event event) {
    }

    /**
     * Action taken every frame
     */
    override void update() {
    }

    /**
     * Draw instructions for the window
     */
    override void draw() {
    }

}
