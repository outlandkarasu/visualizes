/**
Automaton module.
*/
module visualizes.automaton.automaton;

@safe:

/**
1D automaton struct.
*/
struct Automaton
{
    /**
    Initialize by rule.
    */
    this(ubyte rule) @nogc nothrow pure scope
    {
        this.rule_ = rule;
    }

    void apply(scope const(ubyte)[] before, scope ubyte[] after) const @nogc nothrow pure scope 
        in (before.length == after.length)
    {
        immutable last = before.length - 1;
        foreach (i, b; before)
        {
            immutable b3 = before[(i > 0) ? i - 1 : last];
            immutable b2 = before[i];
            immutable b1 = before[(i < last) ? i + 1 : 0];
            immutable offset = (b3 << 2) | (b2 << 1) | b1;
            after[i] = (rule_ >> offset) & 1;
        }
    }

private:
    ubyte rule_;
}

///
nothrow pure unittest
{
    auto automaton = Automaton(30);
    ubyte[] state = [0, 0, 0];
    
    automaton.apply([0, 0, 0], state);
    assert(state == [0, 0, 0]);

    automaton.apply([0, 1, 0], state);
    assert(state == [1, 1, 1]);

    automaton.apply([1, 1, 1], state);
    assert(state == [0, 0, 0]);
}

