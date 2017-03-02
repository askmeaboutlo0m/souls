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
 *
 *
 * This code is based on the Actuate library, licensed under the MIT license.
 *
 * https://github.com/openfl/actuate/tree/master/motion/easing
 *
 * The Actuate license is reproduced here:
 *
 * <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 *
 * License
 * =======
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2009-2017 Joshua Granick
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 *
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 *
 * The code from Actuate is based on previous work by Robert Penner, licensed
 * under the BSD license.
 *
 * http://robertpenner.com/easing_terms_of_use.html
 *
 * The terms of use are reproduced here:
 *
 * <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 *
 * TERMS OF USE - EASING EQUATIONS
 *
 * Open source under the BSD License.
 *
 * Copyright © 2001 Robert Penner All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * - Neither the name of the author nor the names of contributors may be used
 *   to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 */
package souls.anim;


class Easings
{
    public static function linear(k:Float):Float
    {
        return k;
    }


    public static function backIn(k:Float):Float
    {
        return k * k * ((1.70158 + 1) * k - 1.70158);
    }

    public static function backOut(k:Float):Float
    {
        return ((k = k - 1) * k * ((1.70158 + 1.0) * k + 1.70158) + 1.0);
    }

    public static function backInOut(k:Float):Float
    {
        if ((k /= 0.5) < 1.0) {
            return 0.5 * (k * k * (((1.70158 *1.525) + 1.0)
                 * k - (1.70158 * 1.525)));
        }
        else {
            return 0.5 * ((k -= 2.0) * k * (((1.70158 * 1.525) + 1.0)
                 * k + (1.70158 * 1.525)) + 2.0);
        }
    }


    static inline function bOut(t:Float, b:Float, c:Float, d:Float):Float
    {
        if ((t /= d) < (1.0 / 2.75)) {
            return c * (7.5625 * t * t) + b;
        }
        else if (t < (2 / 2.75)) {
            return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
        }
        else if (t < (2.5 / 2.75)) {
            return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
        }
        else {
            return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
        }
    }

    static inline function bIn(t:Float, b:Float, c:Float, d:Float):Float
    {
        return c - bOut(d - t, 0.0, c, d) + b;
    }

    public static function bounceIn(k:Float):Float
    {
        return bIn(k, 0.0, 1.0, 1.0);
    }

    public static function bounceOut(k:Float):Float
    {
        return bOut(k, 0.0, 1.0, 1.0);
    }

    public static function bounceInOut(k:Float):Float
    {
        if (k < 0.5) {
            return bIn(k * 2.0, 0.0, 1.0, 1.0) * 0.5;
        }
        else {
            return bOut(k * 2.0 - 1.0, 0.0, 1.0, 1.0) * 0.5 + 1.0 * 0.5;
        }
    }


    public static function cubicIn(k:Float):Float
    {
        return k * k * k;
    }

    public static function cubicOut(k:Float):Float
    {
        return --k * k * k + 1.0;
    }

    public static function cubicInOut(k:Float):Float
    {
        if ((k /= 1.0 / 2.0) < 1.0) {
            return 0.5 * k * k * k;
        }
        else {
            return 0.5 * ((k -= 2.0) * k * k + 2.0);
        }
    }


    public static function elasticIn(k:Float):Float
    {
        if (k == 0.0 || k == 1.0) {
            return k;
        }
        return -(Math.exp(6.931471805599453 * (k -= 1.0))
             * Math.sin((k - (0.4 / (2.0 * Math.PI) * Math.asin(1.0)))
             * (2 * Math.PI) / 0.4));
    }

    public static function elasticOut(k:Float):Float
    {
        if (k == 0.0 || k == 1.0) {
            return k;
        }
        return (Math.exp(-6.931471805599453 * k)
             * Math.sin((k - (0.4 / (2 * Math.PI) * Math.asin(1.0)))
             * (2 * Math.PI) / 0.4) + 1.0);
    }

    public static function elasticInOut(k:Float):Float
    {
        if (k == 0.0) {
            return 0.0;
        }

        if ((k /= 1.0 / 2.0) == 2.0) {
            return 1.0;
        }

        if (k < 1.0) {
            return -0.5 * (Math.exp(6.931471805599453 * (k -= 1.0))
                 * Math.sin((k - 0.1125) * (2.0 * Math.PI) / 0.45));
        }
        else {
            return Math.exp(-6.931471805599453 * (k -= 1.0))
                 * Math.sin((k - 0.1125) * (2.0 * Math.PI) / 0.45) * 0.5 + 1;
        }
    }


    public static function expoIn(k:Float):Float
    {
        return k == 0.0 ? 0.0 : Math.exp(6.931471805599453 * (k - 1.0));
    }

    public static function expoOut(k:Float):Float
    {
        return k == 1.0 ? 1.0 : (1.0 - Math.exp(-6.931471805599453 * k));
    }

    public static function expoInOut(k:Float):Float
    {
        if (k == 0.0 || k == 1.0) {
            return k;
        }

        if ((k /= 1.0 / 2.0) < 1.0) {
            return 0.5 * Math.exp(6.931471805599453 * (k - 1.0));
        }
        else {
            return 0.5 * (2.0 - Math.exp(-6.931471805599453 * --k));
        }
    }


    public static function quadIn(k:Float):Float
    {
        return k * k;
    }

    public static function quadOut(k:Float):Float
    {
        return -k * (k - 2.0);
    }

    public static function quadInOut(k:Float):Float
    {
        if ((k *= 2.0) < 1.0) {
            return 1.0 / 2.0 * k * k;
        }
        else {
            return -1.0 / 2.0 * ((k - 1.0) * (k - 3.0) - 1.0);
        }
    }


    public static function quartIn(k:Float):Float
    {
        return k * k * k * k;
    }

    public static function quartOut(k:Float):Float
    {
        return -(--k * k * k * k - 1.0);
    }

    public static function quartInOut(k:Float):Float
    {
        if ((k *= 2.0) < 1.0) {
            return 0.5 * k * k * k * k;
        }
        else {
            return -0.5 * ((k -= 2.0) * k * k * k - 2.0);
        }
    }


    public static function quintIn(k:Float):Float
    {
        return k * k * k * k * k;
    }

    public static function quintOut(k:Float):Float
    {
        return --k * k * k * k * k + 1.0;
    }

    public static function quintInOut(k:Float):Float
    {
        if ((k *= 2.0) < 1.0) {
            return 0.5 * k * k * k * k * k;
        }
        else {
            return 0.5 * ((k -= 2.0) * k * k * k * k + 2.0);
        }
    }


    public static function sineIn(k:Float):Float
    {
        return 1.0 - Math.cos(k * (Math.PI / 2.0));
    }

    public static function sineOut(k:Float):Float
    {
        return Math.sin(k * (Math.PI / 2.0));
    }

    public static function sineInOut(k:Float):Float
    {
        return -(Math.cos(Math.PI * k) - 1.0) / 2.0;
    }
}
