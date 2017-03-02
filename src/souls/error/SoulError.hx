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
package souls.error;

import haxe.PosInfos;


class SoulError
{
    public var message(default, null):String;

    var c:PosInfos;


    public function new(message:String, ?c:PosInfos)
    {
        this.message = message;
        this.c       = c;
    }


    public function toString():String
    {
        var cls = Type.getClassName(Type.getClass(this));
        return '$cls: $message at ${c.fileName} line ${c.lineNumber}';
    }
}
