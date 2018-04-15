module graphics.views.MainGameActivity;

import d2d;
import graphics.components.InvPanel;
import graphics.components.Map;
import graphics.Constants;
import logic.Game;
import logic.item.Inventory;
import logic.item.plant;

/**
 * The site of the main UI
 */
class MainGameActivity : Activity {

    Sound!(SoundType.Music) musicToLoop; ///The music to loop while the game is running

    /**
     * Constructor for the main game activity
     * Organizes the components into locations 
     */
    this(Display display, Game game) { 
        super(display);
        this.components ~= new Map(display, new iRectangle(0, 50, 1300, 700), game.world);
        Inventory tempInventory = new Inventory(false, null, new Plant(Breed.TOMATO_PLANT));
        this.components ~= new InvPanel(display, new iRectangle(1300, 50, 300, 700), tempInventory);
        this.musicToLoop = new Sound!(SoundType.Music)(Soundtrack.Sprouts); 
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