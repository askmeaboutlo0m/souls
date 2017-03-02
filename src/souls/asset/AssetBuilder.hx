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
package souls.asset;

import haxe.Json;
import haxe.macro.Expr;
import Lambda;
import openfl.Assets;
import souls.error.AssetBuilderError;
import souls.error.AssetError;
import souls.Scene;
import souls.Util.coalesce;
import souls.Util.lambda;

#if yaml
import yaml.Parser;
import yaml.Yaml;
#end


class AssetBuilder
{
    var assets:Array<Dynamic> = [];


    public function new()
    {
        build();
    }

    function build():Void {}


    static macro function invalidate(msg:Expr):Expr
    {
        return macro throw new AssetBuilderError(
            'Invalid asset "' + a.name + '" at index '
            + i + ": " + $msg + "\nasset: " + a
        );
    }

    public function validate():Void
    {
        for (i in 0 ... assets.length) {
            var a = assets[i];

            if (a.name == null) {
                invalidate("missing name");
            }

            var parent:String = a.parent;
            if (parent != null) {
                var p = Lambda.find(assets, lambda(_.name == parent));
                if (p == null) {
                    invalidate('parent "$parent" does not exist');
                }
                else if (assets.indexOf(p) >= i) {
                    invalidate('parent "$parent" appears afterwards');
                }
            }
        }
    }

    public function addTo(scene:Scene):Void
    {
        validate();
        for (a in assets) {
            scene.add(a);
        }
    }


    public function find(name:String):Dynamic
    {
        var asset = Lambda.find(assets, lambda(_.name == name));
        if (asset == null) {
            throw new AssetBuilderError('Asset does not exist: "$name"');
        }
        return asset;
    }

    public function index(name:String):Int
    {
        return assets.indexOf(find(name));
    }

    public function has(name:String):Bool
    {
        return Lambda.exists(assets, lambda(_.name == name));
    }


    public function move(name:String, index:Int):AssetBuilder
    {
        var asset       = find(name);
        var sourceIndex = assets.indexOf(asset);
        assets.splice(sourceIndex, 1);
        assets.insert(sourceIndex < index ? index - 1 : index, asset);
        return this;
    }


    public function add(name:String, ?a:Dynamic):AssetWrapper
    {
        if (has(name)) {
            throw new AssetBuilderError('Asset already exists: "$name"');
        }

        var asset:Dynamic = coalesce(a, {});
        asset.name = name;
        assets.push(asset);

        return new AssetWrapper(this, asset);
    }

    public inline function a(name:String, ?a:Dynamic):AssetWrapper
    {
        return add(name, a);
    }


    public function edit(name:String):AssetWrapper
    {
        return new AssetWrapper(this, find(name));
    }

    public inline function e(name:String):AssetWrapper
    {
        return edit(name);
    }


    public function remove(name:String):Bool
    {
        return assets.remove(find(name));
    }


    public function addMany(as:Iterable<Dynamic>):AssetBuilder
    {
        for (a in as) {
            add(a.name, a);
        }
        return this;
    }

    public function json(path:String):AssetBuilder
    {
        if (!Assets.exists(path, TEXT)) {
            throw new AssetError(path);
        }
        return addMany(Json.parse(Assets.getText(path)));
    }

  #if yaml
    public function yaml(path:String):AssetBuilder
    {
        if (!Assets.exists(path, TEXT)) {
            throw new AssetError(path);
        }
        var opts  = new ParserOptions();
        opts.maps = false;
        return addMany(Yaml.parse(Assets.getText(path), opts));
    }
  #end
}
