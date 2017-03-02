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

import format.SVG;
import openfl.display.Sprite;


class VectorDrawable implements Drawable
{
    public var data  (default, null):SVG;
    public var width (get,     null):Float;
    public var height(get,     null):Float;

    public function new(data:SVG)
    {
        this.data = data;
    }

    public function draw(img:Image, px:Float, py:Float):Void
    {
        data.render(img.graphics, -px * width, -py * height);
    }

    function get_width():Float
    {
        return data.data.width;
    }

    function get_height():Float
    {
        return data.data.height;
    }
}
