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
package souls.anim.step;

import souls.anim.Sequence;
import souls.display.Drawable;
import souls.Util;


class Frame extends Delay
{
    var topic  :Dynamic;
    var content:Drawable;
    var drawn  :Bool;


    public function new(topic:Dynamic, content:Drawable, time:LazyFloat)
    {
        super(time);
        this.topic   = topic;
        this.content = content;
    }


    override function init(u:Dynamic):Int
    {
        drawn = false;
        return super.init(u);
    }


    override function apply(k:Float):Void
    {
        if (!drawn) {
            drawn         = true;
            topic.content = content;
            topic.draw();
        }
    }
}
