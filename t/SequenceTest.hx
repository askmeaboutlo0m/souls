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
import souls.anim.Step;
import souls.Util.lazy;


private class TestStep implements Step
{
    var start :Float;
    var target:Float;
    var time  :Int;
    var spent :Int = 0;

    public var calls(default, null):Int = 0;
    public var value(default, null):Float;


    public function new(start:Float, target:Float, time:Int)
    {
        this.start  = start;
        this.target = target;
        this.time   = time;
        this.value  = start;
    }


    public function animate(seq:Sequence, elapsed:Int):StepRet
    {
        ++calls;

        var length = time - spent < elapsed ? time - spent : elapsed;
        spent += length;

        return {
            length    : length,
            completed : spent >= time,
            animation : function (frac:Float):Void {
                value = start + (target - start) * (spent / time) * frac;
            },
        };
    }
}


@:access(souls.anim.SequenceManager)
class SequenceTest extends Case
{
    var sm:SequenceManager;

    override public function setup():Void
    {
        sm = new SequenceManager(0);
    }


    public function testEmpty():Void
    {
        is(sm.timer, 0, "manager starts with given timer");
        nok(sm.dirty, "manager does not start out dirty");

        sm.animate(1);
        is(sm.timer, 1, "animating increments timer");
        nok(sm.dirty, "no sequences mean not dirty");

        sm.animate(122);
        is(sm.timer, 123, "animating further adds to the timer");
        nok(sm.dirty, "still not dirty");
    }


    function run(steps:Array<TestStep>, time:Int, sequences:Int,
                 expected:Array<{calls:Int, value:Float}>):Void
    {
        is(steps.length, expected.length, "sanity check on test code");

        sm.animate(time);
        is(sm.sequences.length, sequences, 'manager has $sequences sequences');
        nok(sm.dirty, "manager is not dirty");

        for (i in 0 ... steps.length) {
            is(steps[i].calls, expected[i].calls, 'step $i calls');
            is(steps[i].value, expected[i].value, 'step $i value');
        }
    }


    function setupSingle():TestStep
    {
        var step = new TestStep(0.0, 1.0, 10);
        nok(sm.dirty, "manager does not start out dirty");

        new SequenceBuilder(sm).addStep(lazy(step)).start();
        is(step.calls, 0,   "new single step has 0 calls");
        is(step.value, 0.0, "new single step has value 0.0");
        is(sm.sequences.length, 1, "manager has one sequence");
        ok(sm.dirty, "manager is dirty after adding step");

        return step;
    }

    public function testSingleStepExact():Void
    {
        var step = setupSingle();
        run([step], 10, 0, [{calls : 1, value : 1.0}]);
        run([step],  1, 0, [{calls : 1, value : 1.0}]);
    }

    public function testSingleStepLong():Void
    {
        var step = setupSingle();
        run([step], 20, 0, [{calls : 1, value : 1.0}]);
        run([step],  1, 0, [{calls : 1, value : 1.0}]);
    }

    public function testSingleStepShort():Void
    {
        var step = setupSingle();
        run([step], 5, 1, [{calls : 1, value : 0.5}]);
        run([step], 5, 0, [{calls : 2, value : 1.0}]);
        run([step], 1, 0, [{calls : 2, value : 1.0}]);
    }


    function setupMultiple():Array<TestStep>
    {
        var steps = [
            new TestStep(0.0, 1.0, 10),
            new TestStep(1.0, 2.0, 20),
            new TestStep(3.0, 6.0, 30),
        ];

        nok(sm.dirty, "manager does not start out dirty");
        var sb = new SequenceBuilder(sm);

        for (step in steps) {
            sb.addStep(lazy(step));
            is(step.calls, 0, "step starts out with 0 calls");
        }

        sb.start();
        is(sm.sequences.length, 1, "manager has one sequence");
        ok(sm.dirty, "manager is dirty after adding step");

        return steps;
    }

    public function testMultipleStepsExact():Void
    {
        var steps = setupMultiple();
        run(steps, 10, 1, [
            {calls : 1, value : 1.0},
            {calls : 0, value : 1.0},
            {calls : 0, value : 3.0},
        ]);
        run(steps, 20, 1, [
            {calls : 1, value : 1.0},
            {calls : 1, value : 2.0},
            {calls : 0, value : 3.0},
        ]);
        run(steps, 30, 0, [
            {calls : 1, value : 1.0},
            {calls : 1, value : 2.0},
            {calls : 1, value : 6.0},
        ]);
        run(steps, 1, 0, [
            {calls : 1, value : 1.0},
            {calls : 1, value : 2.0},
            {calls : 1, value : 6.0},
        ]);
    }

    public function testMultipleStepsLong():Void
    {
        var steps = setupMultiple();
        run(steps, 100, 0, [
            {calls : 1, value : 1.0},
            {calls : 1, value : 2.0},
            {calls : 1, value : 6.0},
        ]);
        run(steps, 1, 0, [
            {calls : 1, value : 1.0},
            {calls : 1, value : 2.0},
            {calls : 1, value : 6.0},
        ]);
    }

    public function testMultipleStepsShort():Void
    {
        var steps = setupMultiple();
        run(steps, 5, 1, [
            {calls : 1, value : 0.5},
            {calls : 0, value : 1.0},
            {calls : 0, value : 3.0},
        ]);
        run(steps, 10, 1, [
            {calls : 2, value : 1.00},
            {calls : 1, value : 1.25},
            {calls : 0, value : 3.00},
        ]);
        run(steps, 10, 1, [
            {calls : 2, value : 1.00},
            {calls : 2, value : 1.75},
            {calls : 0, value : 3.00},
        ]);
        run(steps, 10, 1, [
            {calls : 2, value : 1.00},
            {calls : 3, value : 2.00},
            {calls : 1, value : 3.50},
        ]);
        run(steps, 30, 0, [
            {calls : 2, value : 1.00},
            {calls : 3, value : 2.00},
            {calls : 2, value : 6.00},
        ]);
        run(steps, 99, 0, [
            {calls : 2, value : 1.00},
            {calls : 3, value : 2.00},
            {calls : 2, value : 6.00},
        ]);
    }
}
