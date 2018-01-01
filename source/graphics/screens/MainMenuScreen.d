module graphics.screens.MainMenuScreen;

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
        this.components ~= new Button(this.container, new iRectangle(700, 400, 200, 100), () {
            writeln("This button does nothing and is a temporary placeholder!");
        }, fonts[Typeface.OpenSansRegular].renderTextSolid("Press", Color(0, 0, 0))); //TODO: temporary
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
        this.container.window.renderer.drawColor = Color(0, 255, 0);
        this.container.window.renderer.fillRect(new iRectangle(0, 0, logicalSize.x, logicalSize.y));
        this.container.window.renderer.drawColor = Color(0, 0, 0);
        this.components.each!(
                component => this.container.window.renderer.drawRect(component.location));
    }

}
