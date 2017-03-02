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


class TweenBuilder
{
    var sb     :SequenceBuilder;
    var initial:Bool;

    var fields  = new Map<String, LazyFloat>();
    var easings = new Array<Lazy<Float -> Float>>();


    public function new(sb:SequenceBuilder, initial:Bool = false)
    {
        this.sb      = sb;
        this.initial = initial;
    }


    static function rollEasing(es:Array<Lazy<Float -> Float>>,
                               u:Dynamic):Float -> Float
    {
        return Util.roll(es).evaluate(u);
    }


    function build(?time:LazyFloat):SequenceBuilder
    {
        if (initial) {
            for (key in fields.keys()) {
                Reflect.setProperty(sb.topic, key, fields[key].evaluate(null));
            }
        }

        var ease:Lazy<Float -> Float> = easings.length == 0 ? sb.ease
                                      : easings.length == 1 ? easings[0]
                                      : rollEasing.bind(easings);

        return sb.tween(fields, time, ease);
    }


    public function tween(?a:LazyFloat, ?b:LazyFloat):SequenceBuilder
    {
        return build(Util.desugarRand(a, b));
    }

    public function t(?a:LazyFloat, ?b:LazyFloat):SequenceBuilder
    {
        return tween(a, b);
    }


    public function ease(e:Lazy<Float -> Float>):TweenBuilder
    {
        easings.push(e);
        return this;
    }

    public inline function e(e:Lazy<Float -> Float>):TweenBuilder
    {
        return ease(e);
    }


    public function set(key:String, a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        fields[key] = Util.desugarRand(a, b);
        return this;
    }


    public function x(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("x", a, b);
    }

    public function y(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("y", a, b);
    }


    public function rotation(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("rotation", a, b);
    }

    public function r(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return rotation(a, b);
    }


    public function alpha(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("alpha", a, b);
    }

    public function a(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return alpha(a, b);
    }


    public function scale(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("scale", a, b);
    }

    public function s(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return scale(a, b);
    }


    public function scaleX(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("scaleX", a, b);
    }

    public function sx(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return scaleX(a, b);
    }


    public function scaleY(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("scaleY", a, b);
    }

    public function sy(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return scaleY(a, b);
    }


    public function pivotX(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("pivotX", a, b);
    }

    public function px(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return pivotX(a, b);
    }


    public function pivotY(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("pivotY", a, b);
    }

    public function py(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return pivotY(a, b);
    }


    public function relX(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("relX", a, b);
    }

    public function rx(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return relX(a, b);
    }


    public function relY(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return set("relY", a, b);
    }

    public function ry(a:LazyFloat, ?b:LazyFloat):TweenBuilder
    {
        return relY(a, b);
    }
}
