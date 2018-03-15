module graphics.components.TabbedPane;

import d2d;
import graphics.Constants;

/**
 * A pane that has a bunch of tabs that when hovered over, will expand and show whatever is contained inside
 */
class TabbedPane : Component {

    iRectangle retractedLocation; ///The default location of the tabbed pane when not interacted with
    int hoverChange; ///The distancce of horizontal change or expansion of the tabbed when hovered over
    int expandedChange; ///The distance of horizontal change or expansion of the tabbed pane when clicked
    iRectangle currentLocation; ///Current location of the tabbed pane

    /**
     *
     */
    override @property iRectangle location() {
        return this.currentLocation;
    }

    /**
     *
     */
    @property void location(iRectangle newLoc) {

    }

    /**
     * Constructs a tabbed pane
     */
    this(Display display) {
        super(display);
    }

    /**
     * 
     */
    void handleEvent(SDL_Event event) {

    }

    /**
     *
     */
    override void draw() {

    }

}
