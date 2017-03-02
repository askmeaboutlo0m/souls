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
import haxe.PosInfos;
import haxe.unit.TestCase;

using StringTools;


class Case extends TestCase
{
    function _check(success:Bool, desc:String, c:PosInfos,
                    ?diagnostics:Void -> String):Void
    {
        currentTest.done = true;

        if (!success) {
            var diag = "failed test";

            if (desc != null && desc.length > 0) {
                diag += ' "$desc"';
            }

            if (diagnostics != null) {
                var comment = ~/\n/g
                    .split(diagnostics())
                    .map(function (s) { return '# $s'; })
                    .join("\n");

                diag += ':\n$comment';
            }

            currentTest.success  = false;
            currentTest.error    = diag;
            currentTest.posInfos = c;
            throw currentTest;
        }
    }


    static function _s(value:Dynamic):String
    {
        if (value == null) {
            return "null";
        }
        else if (Std.is(value, String)) {
            return '"$value"';
        }
        else if (Std.is(value, Float) || Std.is(value, Int)) {
            return '$value';
        }
        else if (Type.getClass(value) == null) {
            return '($value)';
        }
        else {
            return '${Type.getClassName(Type.getClass(value))}($value)';
        }
    }


    function ok(b:Bool, ?desc:String, ?c:PosInfos):Void
    {
        _check(b, desc, c);
    }

    function nok(b:Bool, ?desc:String, ?c:PosInfos):Void
    {
        _check(!b, desc, c);
    }


    function is<T>(got:T, want:T, ?desc:String, ?c:PosInfos):Void
    {
        _check(got == want, desc, c, function () {
            return 'expected got == want\ngot  ${_s(got)}\nwant ${_s(want)}';
        });
    }

    function isnt<T>(got:T, want:T, ?desc:String, ?c:PosInfos):Void
    {
        _check(got != want, desc, c, function () {
            return 'expected got != want\ngot  ${_s(got)}\nwant ${_s(want)}';
        });
    }


    function isApprox(got:Float, want:Float, eps:Float, ?desc:String,
                      ?c:PosInfos):Void
    {
        _check(Math.abs(got - want) <= eps, desc, c, function () {
            return 'expected got ≈ want\ngot  $got}\nwant $want}\nε    $eps';
        });
    }


    function _catch(block:Void -> Void):Dynamic
    {
        try {
            block();
        }
        catch (e:Dynamic) {
            return e;
        }
        return null;
    }

    function lives(block:Void -> Void, ?desc:String, ?c:PosInfos):Void
    {
        is(_catch(block), null, desc, c);
    }

    function throwsLike(block:Void -> Void, pattern:String, ?desc:String,
                        ?c:PosInfos):Void
    {
        var re     = new EReg(pattern, "");
        var caught = _catch(block);
        _check(caught != null && re.match('$caught'), desc, c, function () {
            return 'expected message to match ~/$pattern/\ngot ${_s(caught)}';
        });
    }
}
