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
package souls.anim;


class Timed
{
    public var parent   (default, null ):Sequence;
    public var begin    (default, null ):Int;
    public var end      (default, null ):Int;
    public var animation(default, null ):Float -> Void;
    public var length   (get,     never):Int;


    public function new(parent:Sequence, begin:Int, end:Int,
                        animation:Float -> Void)
    {
        this.parent    = parent;
        this.begin     = begin;
        this.end       = end;
        this.animation = animation;
    }


    function get_length():Int
    {
        return end - begin;
    }
}
