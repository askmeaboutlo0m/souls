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

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import souls.anim.SequenceBuilder;
import souls.display.Drawable;
import souls.display.Image;
import souls.error.AddError;
import souls.error.ImageError;
import souls.Util;


class Scene extends Sprite
{
    var souls:Souls;

    var images = new Map<String, Image>();

    var onFrameCallback:Event -> Void;


    public function setUp():Void {}

    public function onSceneSet(souls:Souls):Void
    {
        this.souls = souls;
        Util.traced("setUp", setUp());
        Util.traced("onFrame", {
            var onFrameCallback = onFrame();
            if (onFrameCallback != null) {
                addEventListener(Event.ENTER_FRAME, onFrameCallback);
                onFrameCallback(null);
            }
        });
    }

    public function tearDown():Void {}

    public function onSceneUnset():Void
    {
        if (onFrameCallback != null) {
            removeEventListener(Event.ENTER_FRAME, onFrameCallback);
        }
        Util.traced("tearDown", tearDown());
        this.souls = null;
    }

    public function setScene(s:Scene):Void
    {
        souls.setScene(s);
    }


    public function findImage(name:String):Image
    {
        if (images.exists(name)) {
            return images[name];
        }
        throw new ImageError('Image not found: "$name"');
    }


    public function add(args:Dynamic):Image
    {
        var name:String = args.name;
        if (name != null && images.exists(name)) {
            throw new ImageError('Image already exists: "$name"');
        }

        var content:Dynamic = Util.coalesce(args.content, name);
        if (content != null) {
            if (Std.is(content, String)) {
                args.content = souls.findAsset(content);
            }
            else if (Std.is(content, Drawable)) {
                args.content = content;
            }
            else {
                throw new ImageError('Bogus content: "$content"');
            }
        }

        var parent:Dynamic = Util.coalesce(args.parent, this);
        if (Std.is(parent, String)) {
            args.parent = findImage(parent).sprite;
        }
        else if (Std.is(parent, Image)) {
            args.parent = parent.sprite;
        }
        else {
            args.parent = parent;
        }

        var img = new Image(args);
        img.globalPos = localToGlobal(new Point(
            args.x + img.content.width  * img.pivotX,
            args.y + img.content.height * img.pivotY
        ));

        img.orig.x = img.x;
        img.orig.y = img.y;

        if (name != null) {
            images[name] = img;
        }

        return img;
    }


    public function remove(name:String):Bool
    {
        var img = images[name];
        if (img != null) {
            img.parent = null;
        }
        return images.remove(name);
    }

    public function removeAll():Void
    {
        images = new Map<String, Image>();
        removeChildren();
    }


    function resolveTopic(topic:Dynamic):Dynamic
    {
        return Std.is(topic, String) ? findImage(topic) : topic;
    }

    public function seq(?topic:Dynamic, ?ease:Lazy<Float -> Float>,
                        ?name:String):SequenceBuilder
    {
        return new SequenceBuilder(souls.sm, resolveTopic(topic), ease,
                                   name, souls.findAsset);
    }

    public function xeq(?topic:Dynamic, ?ease:Lazy<Float -> Float>,
                        ?name:String):SequenceBuilder
    {
        var resolved = resolveTopic(topic);
        killByTopic(resolved);
        return new SequenceBuilder(souls.sm, resolved, ease,
                                   name, souls.findAsset);
    }


    public function frame(img:StringOr<Image>, asset:StringOr<Drawable>):Void
    {
        var i:Image = switch img.getType() {
            case Left(name): findImage(name);
            case Right(rgt): rgt;
        };

        var a:Drawable = switch asset.getType() {
            case Left(path): souls.findAsset(path);
            case Right(rgt): rgt;
        };

        i.content = a;
        i.draw();
    }


    public function delay(time:Float, func:Void -> Void, ?name:String):Int
    {
        return seq(null, null, name)
            .delay(time)
            .call(function () {
                Util.traced("delay", func());
            })
            .start();
    }


    public function killById(id:Int):Int
    {
        return souls.sm.killById(id);
    }

    public function killByName(name:String):Int
    {
        return souls.sm.killByName(name);
    }

    public function killByTopic(topic:Dynamic):Int
    {
        return souls.sm.killByTopic(topic);
    }

    public function killByRegex(regex:EReg):Int
    {
        return souls.sm.killByRegex(regex);
    }

    public function killByImage(img:StringOr<Image>):Int
    {
        var by:Image = switch img.getType() {
            case Left(name): findImage(name);
            case Right(rgt): rgt;
        };
        return souls.sm.killByTopic(by);
    }


    function onFrame():Event -> Void
    {
        return null;
    }
}
