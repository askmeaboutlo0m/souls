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

import souls.Util;


class Sequence
{
    public var id      (default, null):Int;
    public var name    (default, null):String;
    public var topic   (default, null):Dynamic;
    public var runs    (default, null):Int;
    public var complete(default, null):Void -> Void;

    public var userData(default, default):Dynamic = {};
    public var handled (default, default):Bool    = false;
    public var killedAt(default, null   ):Int     = -1;

    var steps:Array<Step>;
    var index:Int = 0;


    public function new(id:Int, name:String, topic:Dynamic, steps:Array<Step>,
                        runs:Int, complete:Void -> Void)
    {
        this.id       = id;
        this.name     = name == null ? '$id' : name;
        this.topic    = topic;
        this.runs     = runs;
        this.complete = complete;
        this.steps    = steps;
    }


    public function kill(at:Int):Bool
    {
        if (killedAt == -1) {
            killedAt = at;
            runs     = 0;
            return true;
        }
        return false;
    }


    inline function nextIndex()
    {
        if (++index >= steps.length) {
            index = 0;
            --runs;
        }
    }

    public function animate(ts:Array<Timed>, prev:Int, now:Int):Void
    {
        while (prev < now && runs > 0) {
            var a = steps[index].animate(this, now - prev);

            if (a.completed) {
                prev += a.length;
                nextIndex();

                if (runs <= 0 && complete != null) {
                    var actual  = a.animation;
                    a.animation = function (frac:Float):Void {
                        actual(frac);
                        if (frac >= 1.0) {
                            Util.traced("complete", complete());
                        }
                    };
                }
            }

            ts.push(new Timed(this, prev - a.length, prev, a.animation));

            if (!a.completed) {
                break;
            }
        }
    }
}
