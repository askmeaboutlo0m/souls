/*
 * Copyright 2017 askmeaboutloom
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package souls;

import haxe.ds.Either;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;
import souls.anim.Easings;


enum Three<T>
{
    Plain(v:T);
    VFunc(v:Void    -> T);
    DFunc(v:Dynamic -> T);
}

abstract Lazy<T>(Three<T>)
{
    public inline function new(t:Three<T>)
    {
        this = t;
    }

    @:from
    static inline function fromPlain<T>(v:T):Lazy<T>
    {
        return new Lazy<T>(Plain(v));
    }

    @:from
    static inline function fromVFunc<T>(v:Void -> T):Lazy<T>
    {
        return new Lazy<T>(VFunc(v));
    }

    @:from
    static inline function fromDFunc<T>(v:Dynamic -> T):Lazy<T>
    {
        return new Lazy<T>(DFunc(v));
    }

    public inline function evaluate(u:Dynamic):T
    {
        return switch this {
            case Plain(v): v;
            case VFunc(v): v();
            case DFunc(v): v(u);
        };
    }
}

// Compiler can't figure out on its own that Int and Float are unifiable.
abstract LazyFloat(Three<Float>)
{
    public inline function new(t:Three<Float>)
    {
        this = t;
    }

    @:from
    static inline function fromPlain(v:Float):LazyFloat
    {
        return new LazyFloat(Plain(v));
    }

    @:from
    static inline function fromVFunc(v:Void -> Float):LazyFloat
    {
        return new LazyFloat(VFunc(v));
    }

    @:from
    static inline function fromDFunc(v:Dynamic -> Float):LazyFloat
    {
        return new LazyFloat(DFunc(v));
    }

    @:from
    static inline function fromPlainInt(i:Int):LazyFloat
    {
        var v:Float = i;
        return new LazyFloat(Plain(v));
    }

    @:from
    static inline function fromVFuncInt(i:Void -> Int):LazyFloat
    {
        var v:Void -> Float = i;
        return new LazyFloat(VFunc(v));
    }

    @:from static inline function fromDFuncInt(i:Dynamic -> Int):LazyFloat
    {
        var v:Dynamic -> Float = i;
        return new LazyFloat(DFunc(v));
    }

    public inline function evaluate(u:Dynamic):Float
    {
        return switch this {
            case Plain(v): v;
            case VFunc(v): v();
            case DFunc(v): v(u);
        };
    }
}


abstract StringOr<T>(Either<String, T>)
{
    public inline function new(t:Either<String, T>)
    {
        this = t;
    }

    @:from
    static inline function fromString<T>(v:String):StringOr<T>
    {
        return new StringOr<T>(Left(v));
    }

    @:from
    static inline function fromT<T>(v:T):StringOr<T>
    {
        return new StringOr<T>(Right(v));
    }

    public inline function getType():Either<String, T>
    {
        return this;
    }
}


abstract VoidOrDynamic(Either<Void -> Void, Dynamic -> Void>)
{
    public inline function new(t:Either<Void -> Void, Dynamic -> Void>)
    {
        this = t;
    }

    @:from
    static inline function fromVFunc(v:Void -> Void):VoidOrDynamic
    {
        return new VoidOrDynamic(Left(v));
    }

    @:from
    static inline function fromDFunc<T>(v:Dynamic -> Void):VoidOrDynamic
    {
        return new VoidOrDynamic(Right(v));
    }

    public inline function getType():Either<Void -> Void, Dynamic -> Void>
    {
        return this;
    }

    public inline function evaluate(u:Dynamic):Void
    {
        switch this {
            case Left (v): v();
            case Right(v): v(u);
        };
    }
}


class Util
{
    public static var LN (default, never):Float -> Float = Easings.linear;

    public static var BI (default, never):Float -> Float = Easings.bounceIn;
    public static var BO (default, never):Float -> Float = Easings.bounceOut;
    public static var BIO(default, never):Float -> Float = Easings.bounceInOut;

    public static var CI (default, never):Float -> Float = Easings.cubicIn;
    public static var CO (default, never):Float -> Float = Easings.cubicOut;
    public static var CIO(default, never):Float -> Float = Easings.cubicInOut;

    public static var EI (default, never):Float -> Float = Easings.elasticIn;
    public static var EO (default, never):Float -> Float = Easings.elasticOut;
    public static var EIO(default, never):Float -> Float = Easings.elasticInOut;

    public static var KI (default, never):Float -> Float = Easings.backIn;
    public static var KO (default, never):Float -> Float = Easings.backOut;
    public static var KIO(default, never):Float -> Float = Easings.backInOut;

    public static var NI (default, never):Float -> Float = Easings.quintIn;
    public static var NO (default, never):Float -> Float = Easings.quintOut;
    public static var NIO(default, never):Float -> Float = Easings.quintInOut;

    public static var QI (default, never):Float -> Float = Easings.quadIn;
    public static var QO (default, never):Float -> Float = Easings.quadOut;
    public static var QIO(default, never):Float -> Float = Easings.quadInOut;

    public static var RI (default, never):Float -> Float = Easings.quartIn;
    public static var RO (default, never):Float -> Float = Easings.quartOut;
    public static var RIO(default, never):Float -> Float = Easings.quartInOut;

    public static var SI (default, never):Float -> Float = Easings.sineIn;
    public static var SO (default, never):Float -> Float = Easings.sineOut;
    public static var SIO(default, never):Float -> Float = Easings.sineInOut;

    public static var XI (default, never):Float -> Float = Easings.expoIn;
    public static var XO (default, never):Float -> Float = Easings.expoOut;
    public static var XIO(default, never):Float -> Float = Easings.expoInOut;


    public static inline function imin(a:Int, b:Int):Int
    {
        return a <= b ? a : b;
    }

    public static inline function imax(a:Int, b:Int):Int
    {
        return a >= b ? a : b;
    }

    public static inline function interp(a:Float, b:Float, k:Float):Float
    {
        return a + (b - a) * k;
    }


    public static function rand(a:Float, b:Float):Float
    {
        var low = Math.min(a, b);
        return low + (Math.max(a, b) - low) * Math.random();
    }

    public static function wrand(a:Float, b:Float):Void -> Float
    {
        return rand.bind(a, b);
    }

    public static function desugarRand(a:LazyFloat, b:LazyFloat):LazyFloat
    {
        if (b == null) {
            return a == null ? 0.0 : a;
        }
        else if (a == null) {
            return b;
        }
        else {
            return wrand(a.evaluate(null), b.evaluate(null));
        }
    }


    public static function pick<T>(arr:Array<T>):T
    {
        var i = Std.random(arr.length);
        var v = arr[i];
        arr.splice(i, 1);
        return v;
    }

    public static function roll<T>(arr:Array<T>):T
    {
        return arr[Std.random(arr.length)];
    }


    public static inline function toRad(deg:Float):Float
    {
        return (Math.PI / 180.0) * deg;
    }

    public static inline function toDeg(rad:Float):Float
    {
        return (180.0 / Math.PI) * rad;
    }


    macro public static function coalesce(a:Expr, b:Expr):Expr
    {
        return macro $a != null ? $a : $b;
    }


    macro public static function later(e:Expr):Expr
    {
        return macro function () { $e; };
    }

    macro public static function lazy(e:Expr):Expr
    {
        return macro function () { return $e; };
    }

    macro public static function lambda(e:Expr):Expr
    {
        return macro function (_) { return $e; };
    }


    macro public static function traced(name:Expr, block:Expr):Expr
    {
      #if debug
        return macro try {
            $block;
        }
        catch (e:Dynamic) {
            trace(e + " (in " + $name + ")");
            throw e;
        };
      #else
        return macro $block;
      #end
    }


    public static function identifier(e:Expr):String
    {
        return switch e.expr {
            case EConst(CIdent(v)): v;
            default: throw 'Not an identifier expression: "$e"';
        };
    }

    macro public static function useImages(exprs:Array<Expr>):Expr
    {
        var vars = new Array<Var>();
        var pos  = Context.currentPos();

        var func:Expr        = {expr : EConst(CIdent("findImage")), pos : pos};
        var type:ComplexType = TPath({
            pack : ["souls", "display"],
            name : "Image",
        });

        for (e in exprs)
        {
            var name :String = identifier(e);
            var value:Expr   = {expr : EConst(CString(name)), pos : pos};
            vars.push({
                type : type,
                name : name,
                expr : {expr: ECall(func, [value]), pos : pos},
            });
        }

        return {expr : EVars(vars), pos : pos};
    }
}
