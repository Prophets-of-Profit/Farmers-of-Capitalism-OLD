module world.Range;

import std.conv;

/**
 * A struct for numerical types
 * Has a minimum and a maximum, and an optional current
 * Will always keep the current value within the minimum and the maximum
 * Can also check if any other numbers are within the minimum and maximum
 * Is a range from [minimum, maximum] or minimum to maximum inclusive on both ends
 */
struct Range(T){

    private T min;      ///The minimum value of the range, is private so property methods would be used instead
    private T max;      ///The maximum value of the range, is private so property methods would be used instead
    private T cur;      ///The current value of the range, is private so property methods would be used instead
    alias current this; ///Allows the range to be accessed as its current value

    /**
     * Makes it so that a range can furthermore be used as its current value
     * Any assignment operators with numerical inputs used on the range happen to its current value
     */
    void opOpAssign(string op)(T newCurrent){
        mixin("this.current = this.current " ~ op ~ " newCurrent;");
    }

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
        this.fix(this.cur);
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
        this.fix(this.cur);
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
        this.fix(this.cur);
        return this.cur;
    }

    /**
     * A method that makes sure that the given value is in the range
     */
    void fix(ref T val){
        if(val > this.max){
            val = this.max;
        }else if(val < this.min){
            val = this.min;
        }
    }

    /**
     * Returns whether a given value is between the minimum value and the maximum value of this struct
     * Would be "bool isInRange(T valToBeInRange = this.cur)", but that declaration errors and would always be true anyways
     */
    bool isInRange(T valToBeInRange){
        return valToBeInRange >= this.min && valToBeInRange <= this.max;
    }

    /**
     * Returns a string representation of the range so that it can be printed
     */
    string toString(){
        return this.current.to!string ~ " ∈ [" ~ this.minimum.to!string ~ ", " ~ this.maximum.to!string ~ "]";
    }

}

unittest{
    import std.stdio;

    writeln("\nRunning unittest of Range");

    Range!(int) testRange = Range!(int)(0, 5, 3);
    assert(testRange.isInRange(testRange.current));
    int minToTest = 3;
    int maxToTest = 6;
    testRange = Range!(int)(minToTest, maxToTest);
    writeln("Given a minimum of ", minToTest, " and a maximum of ", maxToTest, " a constructed range has the minimum of ", testRange.minimum, " and a maximum of ", testRange.maximum);
    int minValToTest = 0;
    int maxValToTest = 9;
    foreach(i; minValToTest..maxValToTest + 1){
        testRange = i;
        writeln(i, " gets clamped to ", testRange.current);
        assert(testRange.isInRange(testRange.current));
        assert((minToTest <= i && i <= maxToTest) == testRange.isInRange(i));
        writeln(i, " is", (testRange.isInRange(i))? "" : "n't", " in the range");
    }
    assert(testRange.isInRange((minToTest + maxToTest) / 2));
}
