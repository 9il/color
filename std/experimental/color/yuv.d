module std.experimental.color.yuv;

import std.experimental.color;

import std.traits: isFloatingPoint, isIntegral, isSigned, isUnsigned, isSomeChar, Unqual;
import std.typetuple: TypeTuple;
import std.typecons: tuple;

@safe: pure: nothrow: @nogc:

enum isYUV(T) = isInstanceOf!(YUV, T);

enum isValidComponentType(T) = isUnsigned!T || isFloatingPoint!T;


struct YUV(CT = ubyte, bool linear_ = false, RGBColorSpace colorSpace_ = RGBColorSpace.sRGB) if(isValidComponentType!CT)
{
@safe: pure: nothrow: @nogc:

    alias ComponentType = CT;
    enum linear = linear_;
    enum colorSpace = colorSpace_;

    CT Y = 0;
    CT U = 0;
    CT V = 0;

    // casts
    Color opCast(Color)() const if(isColor!Color)
    {
        return convertColor!Color(this);
    }

    // operators
    typeof(this) opBinary(string op, S)(S rh) const if(isFloatingPoint!S && (op == "*" || op == "/" || op == "^^"))
    {
        alias T = Unqual!(typeof(this));
        T res = this;
        foreach(c; XYZComponents)
            mixin(ComponentExpression!("res._ #= rh;", c, op));
        return res;
    }
    ref typeof(this) opOpAssign(string op, S)(S rh) if(isFloatingPoint!S && (op == "*" || op == "/" || op == "^^"))
    {
        foreach(c; XYZComponents)
            mixin(ComponentExpression!("_ #= rh;", c, op));
        return this;
    }

private:
    alias AllComponents = TypeTuple!("Y","U","V");
    alias ParentColourSpace = RGB!("rgb", CT, linear_, colorSpace_);
}

unittest
{
    //...
}
