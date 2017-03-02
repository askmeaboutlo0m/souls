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

import souls.anim.Easings.linear;
import souls.anim.Sequence;
import souls.Util;


class Tween extends StepBase
{
    var topic :Dynamic;
    var fields:Map<String, LazyFloat>;
    var time  :LazyFloat;
    var ease  :Lazy<Float -> Float>;

    var ms:Int;
    var e :Float -> Float;
    var src = new Map<String, Float>();
    var dst = new Map<String, Float>();


    public function new(topic:Dynamic, fields:Map<String, LazyFloat>,
                        ?time:LazyFloat, ?ease:Lazy<Float -> Float>)
    {
        this.topic  = topic;
        this.fields = fields;
        this.time   = time;
        this.ease   = ease;
    }


    override function init(u:Dynamic):Int
    {
        ms = time == null ? 0 : Math.round(time.evaluate(u) * 1000.0);
        e  = ease == null ? linear : ease.evaluate(u);

        for (key in fields.keys()) {
            src[key] = Reflect.getProperty(topic, key);
            dst[key] = fields[key].evaluate(u);
        }

        return ms;
    }


    override function apply(k:Float):Void
    {
        for (key in fields.keys()) {
            var value = Util.interp(src[key], dst[key], e(k));
            Reflect.setProperty(topic, key, value);
        }
    }
}
