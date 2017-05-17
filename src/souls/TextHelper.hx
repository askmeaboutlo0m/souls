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
package souls;

import openfl.Assets;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import souls.Util.coalesce;

typedef TextHelperArgs = {
    @:optional var x         :Float;
    @:optional var y         :Float;
    @:optional var width     :Float;
    @:optional var height    :Float;
    @:optional var alpha     :Float;
    @:optional var font      :String;
    @:optional var size      :Int;
    @:optional var leading   :Int;
    @:optional var text      :String;
    @:optional var autoSize  :TextFieldAutoSize;
    @:optional var type      :TextFieldType;
    @:optional var selectable:Bool;
    @:optional var multiline :Bool;
    @:optional var wordWrap  :Bool;
    @:optional var color     :Int;
    @:optional var background:Int;
    @:optional var bold      :Bool;
    @:optional var italic    :Bool;
    @:optional var underline :Bool;
    @:optional var url       :String;
    @:optional var target    :String;
};


class TextHelper
{
    public static function createTextField(args:TextHelperArgs):TextField
    {
        var field  = new TextField();
        var format = new TextFormat();

        if (args.font != null) {
            format.font      = Assets.getFont(args.font).fontName;
            field.embedFonts = true;
        }

        format.size      = coalesce(args.size,      12      );
        format.leading   = coalesce(args.leading,   null    );
        format.color     = coalesce(args.color,     0x000000);
        format.bold      = coalesce(args.bold,      false   );
        format.italic    = coalesce(args.italic,    false   );
        format.underline = coalesce(args.underline, false   );
        format.url       = coalesce(args.url,       null    );
        format.target    = coalesce(args.target,    "_blank");

        field.defaultTextFormat = format;

        field.alpha      = coalesce(args.alpha,      1.0    );
        field.autoSize   = coalesce(args.autoSize,   LEFT   );
        field.type       = coalesce(args.type,       DYNAMIC);
        field.selectable = coalesce(args.selectable, false  );
        field.multiline  = coalesce(args.multiline,  false  );
        field.wordWrap   = coalesce(args.wordWrap,   false  );
        field.x          = coalesce(args.x,          0.0    );
        field.y          = coalesce(args.y,          0.0    );

        field.mouseEnabled = field.type == INPUT || field.selectable;

        if (args.width != null) {
            field.width = args.width;
        }

        if (args.height != null) {
            field.height = args.height;
        }

        if (args.background != null) {
            field.background      = true;
            field.backgroundColor = args.background;
        }

        field.text = coalesce(coalesce(args.text, args.url), "");

        return field;
    }
}
