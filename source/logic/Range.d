module logic.Range;

/**
 * A bounded value 
 * Stores a value and its bounds
 * Functionally a double
 * TODO: weakly enforced ranges
 */
struct Range(double min, double max) {

    private double _value; ///The double value that the Range represents

    /**
     * Gets the lower bound of the Range
     */
    @property double minimum() {
        return min;
    }

    /**
     * Gets the upper bound of the Range
     */
    @property double maximum() {
        return max;
    }

    /**
     * Gets the range's value
     */
    @property double value() {
        return this._value;
    }

    /**
     * Sets the range's value, clamping it if necessary
     */
    @property void value(double newValue) {
        this._value = newValue;
        this.clampValue;
    }

    /**
     * Clamps the value to the minimum or maximum if it is outside the bounds
     */
    private void clampValue() {
        if (this._value > max) { this._value = max; } 
        else if (this._value < min) { this._value = min; }
    }

    alias value this;

}