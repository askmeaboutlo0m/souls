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
import motion.easing.Back;
import motion.easing.Bounce;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.IEasing;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;
import souls.anim.Easings.*;

typedef EasingCase = {
    n:String,
    a:IEasing,
    s:Float -> Float,
};


class EasingsTest extends Case
{
    public function testEasingsAgainstActuate():Void
    {
        var easings:Array<EasingCase> = [
            {n : "linear",       a : Linear .easeNone,  s : linear},
            {n : "backIn",       a : Back   .easeIn,    s : backIn},
            {n : "backOut",      a : Back   .easeOut,   s : backOut},
            // Actuate's Back.easeInOut is broken.
            // https://github.com/openfl/actuate/issues/65
            // {n : "backInOut",    a : Back   .easeInOut, s : backInOut},
            {n : "bounceIn",     a : Bounce .easeIn,    s : bounceIn},
            {n : "bounceOut",    a : Bounce .easeOut,   s : bounceOut},
            {n : "bounceInOut",  a : Bounce .easeInOut, s : bounceInOut},
            {n : "cubicIn",      a : Cubic  .easeIn,    s : cubicIn},
            {n : "cubicOut",     a : Cubic  .easeOut,   s : cubicOut},
            {n : "cubicInOut",   a : Cubic  .easeInOut, s : cubicInOut},
            {n : "elasticIn",    a : Elastic.easeIn,    s : elasticIn},
            {n : "elasticOut",   a : Elastic.easeOut,   s : elasticOut},
            {n : "elasticInOut", a : Elastic.easeInOut, s : elasticInOut},
            {n : "expoIn",       a : Expo   .easeIn,    s : expoIn},
            {n : "expoOut",      a : Expo   .easeOut,   s : expoOut},
            {n : "expoInOut",    a : Expo   .easeInOut, s : expoInOut},
            {n : "quadIn",       a : Quad   .easeIn,    s : quadIn},
            {n : "quadOut",      a : Quad   .easeOut,   s : quadOut},
            {n : "quadInOut",    a : Quad   .easeInOut, s : quadInOut},
            {n : "quartIn",      a : Quart  .easeIn,    s : quartIn},
            {n : "quartOut",     a : Quart  .easeOut,   s : quartOut},
            {n : "quartInOut",   a : Quart  .easeInOut, s : quartInOut},
            {n : "quintIn",      a : Quint  .easeIn,    s : quintIn},
            {n : "quintOut",     a : Quint  .easeOut,   s : quintOut},
            {n : "quintInOut",   a : Quint  .easeInOut, s : quintInOut},
            {n : "sineIn",       a : Sine   .easeIn,    s : sineIn},
            {n : "sineOut",      a : Sine   .easeOut,   s : sineOut},
            {n : "sineInOut",    a : Sine   .easeInOut, s : sineInOut},
        ];

        for (e in easings) {
            for (i in 0 ... 101) {
                var f = i / 100.0;
                isApprox(e.s(f), e.a.calculate(f), 1e-15, '${e.n}($f)');
            }
        }
    }
}
