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
import souls.anim.Sequence;
import souls.anim.SequenceBuilder;
import souls.anim.SequenceManager;
import souls.anim.step.Tween;
import souls.Util.lazy;


@:access(souls.anim.SequenceManager)
class TweenTest extends Case
{
    var sm:SequenceManager;

    override public function setup():Void
    {
        sm = new SequenceManager(0);
    }


    public function testInstant():Void
    {
        var topic = {value : 0.0, vfunc : 0.0, dfunc : 0.0};
        var tween = new Tween(topic, [
            "value" => 1.0,
            "vfunc" => function () { return 2.0; },
            "dfunc" => function (u) {
                u.foo = "messing with userData";
                return 4.0;
            },
        ]);

        new SequenceBuilder(sm).addStep(lazy(tween)).start();
        is(sm.sequences.length, 1, "sequence is running");
        var seq = sm.sequences[0];

        is(topic.value, 0.0, "topic value is unmodified");
        is(topic.vfunc, 0.0, "topic vfunc is unmodified");
        is(topic.dfunc, 0.0, "topic dfunc is unmodified");
        is(seq.userData.foo, null, "userData is unmodified");

        sm.animate(1);
        is(sm.sequences.length, 0, "sequence is done");
        is(topic.value, 1.0, "value is instantly set");
        is(topic.vfunc, 2.0, "vfunc is instantly set");
        is(topic.dfunc, 4.0, "dfunc is instantly set");
        is(seq.userData.foo, "messing with userData", "userData is changed");
    }


    public function testLinear():Void
    {
        var topic = {value : 0.0, vfunc : 0.0, dfunc : 0.0};
        var tween = new Tween(topic, [
            "value" => 1.0,
            "vfunc" => function () { return 2.0; },
            "dfunc" => function (u) {
                ++u.counter;
                return 4.0;
            },
        ], 1.0);

        new SequenceBuilder(sm).addStep(lazy(tween)).start();
        is(sm.sequences.length, 1, "sequence is running");
        var seq = sm.sequences[0];
        seq.userData.counter = 0;

        is(topic.value, 0.0, "topic value is unmodified");
        is(topic.value, 0.0, "topic vfunc is unmodified");
        is(topic.value, 0.0, "topic dfunc is unmodified");

        sm.animate(500);
        is(sm.sequences.length, 1, "sequence is still running");
        is(topic.value, 0.5, "value is half");
        is(topic.vfunc, 1.0, "vfunc is half");
        is(topic.dfunc, 2.0, "dfunc is half");
        is(seq.userData.counter, 1, "userData was modified once");

        sm.animate(250);
        is(sm.sequences.length, 1, "sequence is still running");
        is(topic.value, 0.75, "value is three quarters");
        is(topic.vfunc, 1.50, "vfunc is three quarters");
        is(topic.dfunc, 3.00, "dfunc is three quarters");
        is(seq.userData.counter, 1, "userData still only modified once");

        sm.animate(500);
        is(sm.sequences.length, 0, "sequence is done");
        is(topic.value, 1.0, "value is full");
        is(topic.vfunc, 2.0, "vfunc is full");
        is(topic.dfunc, 4.0, "dfunc is full");
        is(seq.userData.counter, 1, "userData still only modified once");
    }
}
