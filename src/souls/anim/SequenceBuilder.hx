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

import souls.anim.step.Call;
import souls.anim.step.Delay;
import souls.anim.step.Frame;
import souls.anim.step.Parallel;
import souls.anim.step.Tween;
import souls.display.Drawable;
import souls.Scene;
import souls.Util;
import souls.Util.desugarRand;
import souls.Util.lazy;


class SequenceBuilder
{
    public var manager(default, default):SequenceManager;
    public var topic  (default, default):Dynamic;
    public var ease   (default, default):Lazy<Float -> Float>;
    public var name   (default, default):String;
    public var assets (default, default):String -> Drawable;

    public var map(get, never):TweenBuilder;
    public var mip(get, never):TweenBuilder;

    var steps:Array<Void -> Step> = [];


    public function new(manager:SequenceManager, ?topic:Dynamic,
                        ?ease:Lazy<Float -> Float>, ?name:String,
                        ?assets:String -> Drawable)
    {
        this.manager = manager;
        this.topic   = topic;
        this.ease    = ease;
        this.name    = name;
        this.assets  = assets;
    }


    public function addStep(s:Void -> Step):SequenceBuilder
    {
        steps.push(s);
        return this;
    }


    public function call(func:VoidOrDynamic):SequenceBuilder
    {
        return addStep(lazy(new Call(func)));
    }

    public function delay(a:LazyFloat, ?b:LazyFloat):SequenceBuilder
    {
        return addStep(lazy(new Delay(desugarRand(a, b))));
    }

    public function tween(fields:Map<String, LazyFloat>, ?time:LazyFloat,
                          ?ease:Lazy<Float -> Float>, ?otherTopic:Dynamic
                          ):SequenceBuilder
    {
        return addStep(lazy(new Tween(otherTopic == null ? topic : otherTopic,
                                      fields, time, ease)));
    }

    public function frame(asset:StringOr<Drawable>, ?a:LazyFloat,
                          ?b:LazyFloat):SequenceBuilder
    {
        var content:Drawable = switch asset.getType() {
            case Left(string): assets(string);
            case Right(right): right;
        };
        return addStep(lazy(new Frame(topic, content, desugarRand(a, b))));
    }

    public function parallel(build:SequenceBuilder):SequenceBuilder
    {
        return addStep(lazy(new Parallel(build)));
    }


    function get_map():TweenBuilder
    {
        return new TweenBuilder(this);
    }

    function get_mip():TweenBuilder
    {
        return new TweenBuilder(this, true);
    }


    function run(runs:Int, complete:Null<Void -> Void>, userData:Dynamic):Int
    {
        var s = steps.map(function (s) { return s(); });
        return manager.add(name, topic, s, runs, complete, userData);
    }

    public function loop(runs:Int = 0x3FFFFFFF, ?complete:Void -> Void,
                         ?userData:Dynamic):Int
    {
        return run(runs, complete, userData);
    }

    public function start(?complete:Void -> Void, ?userData:Dynamic):Int
    {
        return run(1, complete, userData);
    }
}
