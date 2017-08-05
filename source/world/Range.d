module world.Range;

/**
 * A struct for numerical types
 * Has a minimum and a maximum, and an optional current
 * Will always keep the current value within the minimum and the maximum
 * Can also check if any other numbers are within the minimum and maximum
 * Is a range from (minimum, maximum) or minimum to maximum exclusive on both ends
 */
struct Range(T){

    private T min;  ///The minimum value of the range, is private so property methods would be used instead
    private T max;  ///The maximum value of the range, is private so property methods would be used instead
    private T cur;  ///The current value of the range, is private so property methods would be used instead

    /**
     * Returns the minimum of the range
     */
    @property T minimum(){
        return this.min;
    }

    /**
     * Sets the minimum of the range given that it is smaller than the maximum of the range
     * Makes sure that the current is still in range
     */
    @property T minimum(T newValue){
        if(newValue < this.max){
            this.min = newValue;
        }
        this.fixCurrent;
        return this.min;
    }

    /**
     * Returns the maximum of the range
     */
    @property T maximum(){
        return this.max;
    }

    /**
     * Sets the maximum of the range given that it is bigger than the minimum of the range
     * Makes sure that current is still in range
     */
    @property T maximum(T newValue){
        if(newValue > this.min){
            this.max = newValue;
        }
        this.fixCurrent;
        return this.max;
    }

    /**
     * Returns the current value
     */
    @property T current(){
        return this.cur;
    }

    /**
     * Sets the current value and makes sure that it is within the range
     */
    @property T current(T newValue){
        this.cur = newValue;
        this.fixCurrent;
        return this.cur;
    }

    /**
     * A method that makes sure that current is in the range
     */
    private void fixCurrent(){
        if(this.cur > this.max){
            this.cur = this.max;
        }else if(this.cur < this.min){
            this.cur = this.min;
        }
    }

    /**
     * Returns whether a given value is between the minimum value and the maximum value of this struct
     * Would be "bool isInRange(T valToBeInRange = this.cur)", but that declaration errors and would always be true anyways
     */
    bool isInRange(T valToBeInRange){
        return valToBeInRange > this.min && valToBeInRange < this.max;
    }

}

unittest{
    import std.stdio;

    writeln("Running unittest of Range");

    Range!(int) testRange = Range!(int)(0, 5, 3);
    assert(testRange.isInRange(testRange.current));
    int minToTest = 3;
    int maxToTest = 5;
    testRange = Range!(int)(minToTest, maxToTest);
    writeln("Given a minimum of ", minToTest, " and a maximum of ", maxToTest, " a constructed range has the minimum of ", testRange.minimum, " and a maximum of ", testRange.maximum);
    assert(testRange.isInRange((minToTest + maxToTest) / 2));
}
