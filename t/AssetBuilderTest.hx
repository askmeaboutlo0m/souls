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
import souls.asset.AssetBuilder;
import souls.Util.lambda;


@:access(souls.asset.AssetBuilder)
class AssetBuilderTest extends Case
{
    var builder:AssetBuilder;

    override function setup():Void
    {
        builder = new AssetBuilder();
    }


    public function testEmpty():Void
    {
        is(builder.assets.length, 0, "initial builder has no assets");
        lives(builder.validate, "empty builder validates");
    }


    public function testMissingParent():Void
    {
        builder.add("child").parent("missing");
        throwsLike(builder.validate, 'parent "missing" does not exist',
                   "missing parent throws appropriate error");
    }

    public function testLateParent():Void
    {
        builder.add("child").parent("late");
        builder.add("late");
        throwsLike(builder.validate, 'parent "late" appears afterwards',
                   "late parent throws appropriate error");
    }

    public function testValidParent():Void
    {
        builder.add("parent");
        builder.add("child").parent("parent");
        lives(builder.validate, "proper parent validates");
    }


    function order():String
    {
        return builder.assets.map(lambda(_.name)).join("");
    }

    public function testMove():Void
    {
        var letters = "abcde".split("");

        for (letter in letters) {
            builder.add(letter);
        }

        is(order(), "abcde", "initial ordering");

        for (letter in letters) {
            builder.edit(letter).before(letter);
            is(order(), "abcde", '$letter before itself changes nothing');

            builder.edit(letter).after(letter);
            is(order(), "abcde", '$letter after itself changes nothing');
        }

        builder.edit("b").before("d");
        is(order(), "acbde", "putting earlier letter before later one");

        builder.edit("b").before("c");
        is(order(), "abcde", "putting later letter before earlier one");

        builder.edit("c").after("e");
        is(order(), "abdec", "putting earlier letter after later one");

        builder.edit("c").after("b");
        is(order(), "abcde", "putting later letter after earlier one");

        builder.move("e", 0);
        is(order(), "eabcd", "moving letter by index");

        builder.move("e", 99);
        is(order(), "abcde", "index beyond the end puts it at the end");

        builder.move("a", -1);
        is(order(), "bcdae", "negative index inserts from the end");

        builder.move("a", -99);
        is(order(), "abcde", "index beyond the start puts it at the start");
    }
}
