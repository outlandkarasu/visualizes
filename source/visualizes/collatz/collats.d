/**
Collatz module.
*/
module visualizes.collatz.collatz;

import std.array : Appender;
import std.algorithm : copy;

@safe:

/**
Collatz state structure.
*/
struct Collatz
{
    this(scope const(char)[] bits) nothrow pure scope
    {
        foreach_reverse (b; bits)
        {
            buffer1_ ~= b == '1';
        }
    }

    ///
    nothrow pure unittest
    {
        auto collatz = Collatz("1000");
        assert(collatz[] == [false, false, false, true]);
    }

    void next() pure scope
    {
        if (this[].length == 0)
        {
            return;
        }

        // even shift
        if (!this[][0])
        {
            this[][1 .. $].copy(this[][0 .. $ - 1]);
            currentBuffer.shrinkTo(currentBuffer[].length - 1);
            return;
        }

        // odd 3n
        bool carry = false;
        nextBuffer.clear();
        nextBuffer ~= true;
        foreach (i, b; currentBuffer[])
        {
            uint count = b ? 1 : 0;
            if (carry) { ++count; }
            if (i < (currentBuffer[].length - 1) && currentBuffer[][i + 1]) { ++count; }
            nextBuffer ~= (count != 2);
            carry = count >= 2;
        }

        if (carry)
        {
            nextBuffer ~= carry;
        }

        // odd +1
        bool lastCarry = true;
        foreach (i, ref b; nextBuffer[])
        {
            if (!b)
            {
                lastCarry = false;
                b = true;
                break;
            }

            b = false;
        }

        if (lastCarry)
        {
            nextBuffer ~= true;
        }

        current2_ = !current2_;
    }

    ///
    pure unittest
    {
        auto collatz = Collatz("1");
        assert(collatz[] == [true]);
        collatz.next();
        assert(collatz[] == [false, false, true]);
        collatz.next();
        assert(collatz[] == [false, true]);
        collatz.next();
        assert(collatz[] == [true]);
    }

    ///
    pure unittest
    {
        auto collatz = Collatz("1111");
        assert(collatz[] == [true, true, true, true]);
        collatz.next();
        assert(collatz[] == [false, true, true, true, false, true]);
        collatz.next();
        assert(collatz[] == [true, true, true, false, true]);
    }

    inout(bool)[] opSlice() @nogc nothrow pure scope inout
    {
        return currentBuffer[];
    }

private:

    auto ref currentBuffer() inout @nogc nothrow pure return scope
    {
        return current2_ ? buffer2_ : buffer1_;
    }

    auto ref nextBuffer() inout @nogc nothrow pure return scope
    {
        return current2_ ? buffer1_ : buffer2_;
    }

    Appender!(bool[]) buffer1_;
    Appender!(bool[]) buffer2_;
    bool current2_;
}

