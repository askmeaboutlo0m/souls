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

import souls.anim.Step;
import souls.Util;


class StepBase implements Step
{
    var runs :Int = -1;
    var total:Int;
    var spent:Int;


    function init(u:Dynamic):Int
    {
        // no time taken unless overridden
        return 0;
    }

    function apply(k:Float):Void
    {
        // do nothing unless overridden
    }


    public function animate(seq:Sequence, elapsed:Int):StepRet
    {
        if (seq.runs != runs) {
            runs  = seq.runs;
            total = init(seq.userData);
            spent = 0;
        }

        var length = Util.imin(total - spent, elapsed);

        return {
            length    : length,
            completed : spent + length >= total,
            animation : function (frac:Float):Void {
                apply(total == 0 ? 1.0 : (spent + length * frac) / total);
                spent += length;
            },
        };
    }
}
