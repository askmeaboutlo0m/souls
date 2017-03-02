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

import openfl.display.BitmapData;
import openfl.geom.Matrix;


class BitmapDrawable implements Drawable
{
    public var data  (default, default):BitmapData;
    public var width (get,     null   ):Float;
    public var height(get,     null   ):Float;

    public function new(data:BitmapData)
    {
        this.data = data;
    }

    public function draw(img:Image, px:Float, py:Float):Void
    {
        var g  = img.graphics;
        var tx = -px * data.width;
        var ty = -py * data.height;

        var m = new Matrix();
        m.tx  = tx;
        m.ty  = ty;

        g.beginBitmapFill(data, m, false, true);
        g.drawRect(tx, ty, data.width, data.height);
        g.endFill();
    }

    function get_width():Float
    {
        return data.width;
    }

    function get_height():Float
    {
        return data.height;
    }
}
