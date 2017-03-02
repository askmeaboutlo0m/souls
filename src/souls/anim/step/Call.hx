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
import souls.anim.Step;
import souls.Util;


class Call implements Step
{
    var func:VoidOrDynamic;


    public function new(func:VoidOrDynamic)
    {
        this.func = func;
    }


    public function animate(seq:Sequence, elapsed:Int):StepRet
    {
        return {
            length    : 0,
            completed : true,
            animation : function (frac:Float):Void {
                Util.traced("call", func.evaluate(seq.userData));
            },
        };
    }
}
