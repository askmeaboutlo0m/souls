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
import souls.anim.SequenceBuilder;
import souls.anim.Step;
import souls.Util;


class Parallel implements Step
{
    var builder:SequenceBuilder;


    public function new(builder:SequenceBuilder)
    {
        this.builder = builder;
    }


    public function animate(seq:Sequence, elapsed:Int):StepRet
    {
        return {
            length    : 0,
            completed : true,
            animation : function (frac:Float):Void {
                builder.start(null, seq.userData);
            },
        };
    }
}
