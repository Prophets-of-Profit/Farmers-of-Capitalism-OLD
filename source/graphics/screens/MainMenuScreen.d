module graphics.screens.MainMenuScreen;

import std.algorithm;
import d2d;

/**
 * The main menu screen
 * The entry point for the game
 */
class MainMenuScreen : Screen {

    Sound!(SoundType.Music) enterpriseOrchestra; ///The main menu theme; loops forever

    /**
     * The constructor for a main menu
     */
    this(Display container) {
        super(container);
        this.enterpriseOrchestra = new Sound!(SoundType.Music)("res/music/enterprise - orchestra.mp3");
        musicVolume = MIX_MAX_VOLUME / 4;       //Max volume is a bit loud
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