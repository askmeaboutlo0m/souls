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

import openfl.display.DisplayObjectContainer;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event.ENTER_FRAME;
import openfl.events.Event.RESIZE;
import openfl.events.Event;
import openfl.Lib;
import souls.anim.SequenceManager;
import souls.asset.AssetManagement;
import souls.asset.AssetManager;
import souls.display.Drawable;
import souls.Util.coalesce;

#if debug
import haxe.Log;
import haxe.PosInfos;
import openfl.display.FPS;
import openfl.text.TextField;

using DateTools;
#end

typedef SoulsArgs = {
    @:optional var container   :DisplayObjectContainer;
    @:optional var width       :Float;
    @:optional var height      :Float;
    @:optional var prefix      :String;
    @:optional var cover       :Bool;
    @:optional var assetManager:AssetManagement;
    @:optional var replaceTrace:Bool;
};


class Souls
{
    public static inline var DEFAULT_WIDTH :Float  = 1920.0;
    public static inline var DEFAULT_HEIGHT:Float  = 1080.0;
    public static inline var DEFAULT_PREFIX:String = "assets/";

    public var container (default, null):DisplayObjectContainer;
    public var realWidth (default, null):Float;
    public var realHeight(default, null):Float;
    public var prefix    (default, null):String;

    public var scene(default, null):Scene;
    public var time (default, null):Int;
    public var sm   (default, null):SequenceManager;
    public var am   (default, null):AssetManagement;

    public var cover     (default, null):Sprite = new Sprite();
    public var coverColor(default, set ):Int    = 0xffffff;

    var resetTimer = false;

  #if debug
    var fpsField  :FPS;
    var traceField:TextField;
  #end


    public function new(?args:SoulsArgs)
    {
        if (args == null) {
            args = {};
        }

        container  = coalesce(args.container,    Lib.current.stage);
        realWidth  = coalesce(args.width,        DEFAULT_WIDTH);
        realHeight = coalesce(args.height,       DEFAULT_HEIGHT);
        prefix     = coalesce(args.prefix,       DEFAULT_PREFIX);
        am         = coalesce(args.assetManager, new AssetManager());

        time = Lib.getTimer();
        sm   = new SequenceManager(time);

        container.addChild(cover);
        container.addEventListener(RESIZE,      resize );
        container.addEventListener(ENTER_FRAME, onFrame);

      #if debug
        container.addChild(fpsField   = new FPS());
        container.addChild(traceField = new TextField());
        traceField.defaultTextFormat  = fpsField.defaultTextFormat;
        traceField.autoSize           = LEFT;
        repositionTextFields();

        if (coalesce(args.replaceTrace, true)) {
            Log.trace       = onTrace;
            traceField.text = "[souls debug trace]";
        }
      #end

      #if flash
        Lib.current.stage.showDefaultContextMenu = false;
      #end
    }


  #if debug
    function onTrace(v:Dynamic, ?c:PosInfos):Void
    {
        var file = c == null ? "" : '${c.fileName}';
        var line = c == null ? "" : '${c.lineNumber}';
        var time = Date.now().format("%H:%M:%S");
        traceField.text = '[$time $file:$line] $v\n${traceField.text}';
    }

    function repositionTextFields():Void
    {
        var sw:Float;

        try {
            var s = cast(container, Stage);
            sw = s.stageWidth;
        }
        catch (e:Dynamic) {
            sw = container.width;
        }

        fpsField.x = sw - 60;
        fpsField.y = 0.0;

        traceField.x = 0.0;
        traceField.y = 0.0;
    }
  #end


    function resize(?e:Event):Void
    {
      #if debug
        repositionTextFields();
      #end
        if (scene == null) {
            return;
        }

        var sw:Float;
        var sh:Float;

        try {
            var s = cast(container, Stage);
            sw = s.stageWidth;
            sh = s.stageHeight;
        }
        catch (e:Dynamic) {
            sw = container.width;
            sh = container.height;
        }

        var ratio:Float;

        if (realHeight * (sw / realWidth) <= sh) {
            ratio   = sw / realWidth;
            scene.x = 0.0;
            scene.y = (sh - realHeight * ratio) / 2;
        }
        else {
            ratio   = sh / realHeight;
            scene.x = (sw - realWidth * ratio) / 2;
            scene.y = 0;
        }

        scene.scaleX = scene.scaleY = ratio;
        drawCover(ratio);
    }


    function set_coverColor(c:Int):Int
    {
        coverColor = c;
        resize(null);
        return coverColor;
    }

    function drawCover(ratio:Float):Void
    {
        var g = cover.graphics;
        g.clear();
        g.beginFill(coverColor);

        var x = scene.x;
        var y = scene.y;
        var w = realWidth  * ratio;
        var h = realHeight * ratio;

        if (x != 0.0) {
            g.drawRect(0.0,   0.0, x, h);
            g.drawRect(w + x, 0.0, x, h);
        }

        if (y != 0.0) {
            g.drawRect(0.0, 0.0,   w, y);
            g.drawRect(0.0, h + y, w, y);
        }

        g.endFill();
    }


    function onFrame(e:Event):Void
    {
        var now = Lib.getTimer();
        if (resetTimer) {
            resetTimer = false;
            sm.forceTimer(now);
        }
        else {
            sm.animate(now - time);
        }
        time = now;
    }


    public function setScene(s:Scene):Void
    {
        if (scene != null) {
            container.removeChild(scene);
            sm.bailOut();
            scene.onSceneUnset();
        }

        if ((scene = s) != null) {
            resize(null);
            container.addChildAt(scene, 0);
            scene.onSceneSet(this);
            resetTimer = true;
        }
    }


    public function findAsset(path:String):Drawable
    {
        return am.findAsset('$prefix$path');
    }
}
