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
package souls.display;

import haxe.macro.Expr;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import souls.Util;

typedef ImageArgs = {
    @:optional var content      :Drawable;
    @:optional var x            :Float;
    @:optional var y            :Float;
    @:optional var pivotX       :Float;
    @:optional var pivotY       :Float;
    @:optional var alpha        :Float;
    @:optional var rotation     :Float;
    @:optional var scaleX       :Float;
    @:optional var scaleY       :Float;
    @:optional var scale        :Float;
    @:optional var visible      :Bool;
    @:optional var mouseEnabled :Bool;
    @:optional var mouseChildren:Bool;
    @:optional var buttonMode   :Bool;
    @:optional var tabEnabled   :Bool;
    @:optional var name         :String;
    @:optional var userData     :Dynamic;
    @:optional var parent       :DisplayObjectContainer;
    @:optional var masksParent  :Bool;
};


class Image
{
    public var name    (default, null   ):String;
    public var content (default, default):Drawable;
    public var pivotX  (default, set    ):Float     = 0.0;
    public var pivotY  (default, set    ):Float     = 0.0;
    public var orig    (default, null   ):ImageArgs = {};
    public var userData(default, default):Dynamic;

    public var scale    (get, set):Float;
    public var pos      (get, set):Point;
    public var globalPos(get, set):Point;
    public var relX     (get, set):Float;
    public var relY     (get, set):Float;
    public var rel      (get, set):Point;
    public var parent   (get, set):DisplayObjectContainer;

    public var onClick     (default, set  ):MouseEvent -> Void;
    public var actualWidth (get,     never):Float;
    public var actualHeight(get,     never):Float;

    // Can't extend Sprite or else Haxe generates invalid code for Flash.
    public var sprite       (default, null ):Sprite = new Sprite();
    public var x            (get,     set  ):Float;
    public var y            (get,     set  ):Float;
    public var alpha        (get,     set  ):Float;
    public var rotation     (get,     set  ):Float;
    public var scaleX       (get,     set  ):Float;
    public var scaleY       (get,     set  ):Float;
    public var visible      (get,     set  ):Bool;
    public var mouseEnabled (get,     set  ):Bool;
    public var mouseChildren(get,     set  ):Bool;
    public var buttonMode   (get,     set  ):Bool;
    public var tabEnabled   (get,     set  ):Bool;
    public var width        (get,     never):Float;
    public var height       (get,     never):Float;
    public var graphics     (get,     never):Graphics;


    public function new(?args:ImageArgs)
    {
        mouseEnabled = false;
        if (args != null) {
            apply(args);
        }
        draw();
    }


    macro static function setArgs(identifiers:Array<Expr>):Expr
    {
        var exprs = new Array<Expr>();

        for (i in identifiers) {
            var field:String = Util.identifier(i);
            exprs.push(macro
                if (args.$field == null) {
                    orig.$field = this.$field;
                }
                else {
                    orig.$field = this.$field = args.$field;
                }
            );
        }

        return macro $b{exprs};
    }

    public function apply(args:ImageArgs):Void
    {
        if (args.parent != null) {
            orig.parent = parent = args.parent;
        }

        if (orig.masksParent = Util.coalesce(args.masksParent, false)) {
            parent.mask = sprite;
        }

        setArgs(content, x, y, pivotX, pivotY, alpha, rotation, scaleX,
                scaleY, scale, visible, mouseEnabled, mouseChildren,
                buttonMode, tabEnabled, name, userData);
    }


    public function draw():Void
    {
        graphics.clear();
        if (content != null) {
            content.draw(this, pivotX, pivotY);
        }
    }


    function set_pivotX(px:Float):Float
    {
        y += (px - pivotX) * (content == null ? 0.0 : content.width);
        return pivotX = px;
    }

    function set_pivotY(py:Float):Float
    {
        y += (py - pivotY) * (content == null ? 0.0 : content.height);
        return pivotY = py;
    }


    function get_scale():Float
    {
        return scaleX / 2 + scaleY / 2;
    }

    function set_scale(s:Float):Float
    {
        return scaleX = scaleY = s;
    }


    function get_pos():Point
    {
        return new Point(x, y);
    }

    function set_pos(p:Point):Point
    {
        x = p.x;
        y = p.y;
        return p;
    }

    function get_globalPos():Point
    {
        return parent.localToGlobal(new Point(x, y));
    }

    function set_globalPos(p:Point)
    {
        var local = parent.globalToLocal(p);
        x = local.x;
        y = local.y;
        return p;
    }


    function get_relX()
    {
        return x - orig.x;
    }

    function set_relX(relX:Float):Float
    {
        x = orig.x + relX;
        return x - orig.x;
    }

    function get_relY()
    {
        return y - orig.y;
    }

    function set_relY(relY:Float):Float
    {
        y = orig.y + relY;
        return y - orig.y;
    }

    function get_rel():Point
    {
        return new Point(relX, relY);
    }

    function set_rel(p:Point):Point
    {
        relX = p.x;
        relY = p.y;
        return rel;
    }


    function get_parent():DisplayObjectContainer {
        return sprite.parent;
    }

    function set_parent(p:DisplayObjectContainer):DisplayObjectContainer {
        if (parent != null) {
            parent.removeChild(sprite);
        }
        if (p != null) {
            p.addChild(sprite);
        }
        return sprite.parent;
    }


    function set_onClick(callback:MouseEvent -> Void):MouseEvent -> Void
    {
        if (onClick != null) {
            sprite.removeEventListener(MouseEvent.CLICK, onClick);
        }

        onClick = callback;
        if (onClick != null) {
            mouseEnabled = true;
            sprite.addEventListener(MouseEvent.CLICK, onClick);
        }

        return onClick;
    }


    function get_actualWidth() {
        return content == null ? 0.0 : content.width;
    }

    function get_actualHeight() {
        return content == null ? 0.0 : content.height;
    }


    inline function get_x            () { return sprite.x;             }
    inline function get_y            () { return sprite.y;             }
    inline function get_alpha        () { return sprite.alpha;         }
    inline function get_rotation     () { return sprite.rotation;      }
    inline function get_scaleX       () { return sprite.scaleX;        }
    inline function get_scaleY       () { return sprite.scaleY;        }
    inline function get_visible      () { return sprite.visible;       }
    inline function get_mouseEnabled () { return sprite.mouseEnabled;  }
    inline function get_mouseChildren() { return sprite.mouseChildren; }
    inline function get_buttonMode   () { return sprite.buttonMode;    }
    inline function get_tabEnabled   () { return sprite.tabEnabled;    }
    inline function get_name         () { return sprite.name;          }
    inline function get_graphics     () { return sprite.graphics;      }
    inline function get_width        () { return sprite.width;         }
    inline function get_height       () { return sprite.height;        }

    inline function set_x            (v) { return sprite.x             = v; }
    inline function set_y            (v) { return sprite.y             = v; }
    inline function set_alpha        (v) { return sprite.alpha         = v; }
    inline function set_rotation     (v) { return sprite.rotation      = v; }
    inline function set_scaleX       (v) { return sprite.scaleX        = v; }
    inline function set_scaleY       (v) { return sprite.scaleY        = v; }
    inline function set_visible      (v) { return sprite.visible       = v; }
    inline function set_mouseEnabled (v) { return sprite.mouseEnabled  = v; }
    inline function set_mouseChildren(v) { return sprite.mouseChildren = v; }
    inline function set_buttonMode   (v) { return sprite.buttonMode    = v; }
    inline function set_tabEnabled   (v) { return sprite.tabEnabled    = v; }
    inline function set_name         (v) { return sprite.name          = v; }
}
