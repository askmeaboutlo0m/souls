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
import souls.Util;


class UtilTest extends Case
{
    public function testCoalesce():Void
    {
        var a:String = null;
        var b:String = "";
        var c:String = "c";

        is(Util.coalesce(a, b), b, 'null // ""   = ""'  );
        is(Util.coalesce(b, a), b, '""   // null = ""'  );
        is(Util.coalesce(a, a), a, 'null // null = null');
        is(Util.coalesce(b, c), b, '""   // "c"  = ""'  );
        is(Util.coalesce(c, b), c, '"c"  // ""   = "c"' );

        var ran = false;
        is(Util.coalesce(c, function () { ran = true; return "f"; }()),
           c, '"c" // lazy "f" = "c"');
        nok(ran, "second argument is not evaluated");

        is(Util.coalesce(function () { ran = true; return "f"; }(), c),
           "f", 'lazy "f" // "c" = "f"');
        ok(ran, "as first argument it's evaluated though");
    }


    public function testLambda():Void
    {
        var map = [1, 2, 3].map(Util.lambda(_ + 1));
        is(map.length, 3);
        is(map[0],     2);
        is(map[1],     3);
        is(map[2],     4);

        var filter = [for (i in 0 ... 10) i].filter(Util.lambda(_ % 2 == 0));
        is(filter.length, 5);
        is(filter[0],     0);
        is(filter[1],     2);
        is(filter[2],     4);
        is(filter[3],     6);
        is(filter[4],     8);
    }
}
