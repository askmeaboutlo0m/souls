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

import souls.Util.lambda;


class SequenceManager
{
    var counter  :Int             = 0;
    var sequences:Array<Sequence> = [];
    var dirty    :Bool            = false;
    var bail     :Bool            = false;
    var timer    :Int;


    public function new(timer:Int)
    {
        this.timer = timer;
    }


    public function forceTimer(timer:Int):Void
    {
        this.timer = timer;
    }

    public function bailOut():Void
    {
        bail = true;
        killAll();
    }


    public function add(name:String, topic:Dynamic, steps:Array<Step>,
                        runs:Int, complete:Null<Void -> Void>,
                        userData:Dynamic):Int
    {
        if (name != null) {
            killByName(name);
        }
        var id  = ++counter;
        var seq = new Sequence(id, name, topic, steps,
                               runs, complete, userData);
        dirty   = true;
        sequences.push(seq);
        return id;
    }


    function killBy(pred:Sequence -> Bool):Int
    {
        var killed = 0;
        var i      = 0;

        while (i < sequences.length) {
            if (pred(sequences[i])) {
                dirty = true;
                sequences[i].kill(timer);
                sequences.splice(i, 1);
                ++killed;
            }
            else {
                ++i;
            }
        }

        return killed;
    }


    public function killById(id:Int):Int
    {
        return killBy(function (seq) { return seq.id == id; });
    }

    public function killByName(name:String):Int
    {
        return killBy(function (seq) { return seq.name == name; });
    }

    public function killByTopic(topic:Dynamic):Int
    {
        return killBy(function (seq) { return seq.topic == topic; });
    }

    public function killByRegex(regex:EReg):Int
    {
        return killBy(function (seq) { return regex.match(seq.name); });
    }


    public function killAll():Void
    {
        for (seq in sequences) {
            seq.kill(timer);
        }
        dirty     = true;
        sequences = [];
    }


    static function cmpTimed(at:Timed, bt:Timed):Int
    {
        var a = at.end;
        var b = bt.end;
        return a < b ? -1 : a > b ? 1 : 0;
    }


    public function animate(elapsed:Int):Void
    {
        if (elapsed <= 0) {
            return;
        }

        var now = timer + elapsed;
        var ts  = new Array<Timed>();

        for (s in sequences) {
            s.animate(ts, timer, now);
            s.handled = true;
        }

        ts.sort(cmpTimed);
        dirty = false;

        while (!bail && ts.length > 0) {
            if (dirty) {
                for (s in sequences) {
                    if (!s.handled) {
                        s.animate(ts, timer, now);
                        s.handled = true;
                    }
                }
                ts.sort(cmpTimed);
                dirty = false;
            }

            var timed    = ts.shift();
            var killedAt = timed.parent.killedAt;
            var frac     = killedAt < 0 || killedAt >= timed.end
                         ? 1.0 : timed.length / (killedAt - timed.begin);

            timer = timed.end;
            timed.animation(frac);
        }

        sequences = sequences.filter(lambda(_.runs > 0));
        timer     = now;
        bail      = false;
    }
}
