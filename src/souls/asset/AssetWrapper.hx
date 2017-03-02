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


class AssetWrapper
{
    var builder:AssetBuilder;
    var asset  :Dynamic;


    public function new(builder:AssetBuilder, asset:Dynamic)
    {
        this.builder = builder;
        this.asset   = asset;
    }


    public function get(key:String):Dynamic
    {
        return Reflect.field(asset, key);
    }


    public function before(name:String):AssetWrapper
    {
        builder.move(asset.name, builder.index(name));
        return this;
    }

    public function after(name:String):AssetWrapper
    {
        builder.move(asset.name, builder.index(name) + 1);
        return this;
    }

    public function remove():AssetWrapper
    {
        builder.remove(asset.name);
        return this;
    }


    public function content(c:String):AssetWrapper
    {
        asset.content = c;
        return this;
    }

    public inline function c(c:String):AssetWrapper
    {
        return content(c);
    }


    public function parent(p:String):AssetWrapper
    {
        asset.parent = p;
        return this;
    }

    public inline function p(p:String):AssetWrapper
    {
        return parent(p);
    }


    public function x(x:Float):AssetWrapper
    {
        asset.x = x;
        return this;
    }

    public function y(x:Float):AssetWrapper
    {
        asset.y = y;
        return this;
    }


    public function alpha(a:Float):AssetWrapper
    {
        asset.alpha = a;
        return this;
    }

    public inline function a(a:Float):AssetWrapper
    {
        return alpha(a);
    }


    public function rotation(r:Float):AssetWrapper
    {
        asset.rotation = r;
        return this;
    }

    public inline function r(r:Float):AssetWrapper
    {
        return rotation(r);
    }


    public function scaleX(sx:Float):AssetWrapper
    {
        asset.scaleX = sx;
        return this;
    }

    public inline function sx(sx:Float):AssetWrapper
    {
        return scaleX(sx);
    }


    public function scaleY(sy:Float):AssetWrapper
    {
        asset.scaleY = sy;
        return this;
    }

    public inline function sy(sy:Float):AssetWrapper
    {
        return scaleY(sy);
    }


    public function scale(s:Float):AssetWrapper
    {
        return scaleX(s).scaleY(s);
    }

    public inline function s(s:Float):AssetWrapper
    {
        return scale(s);
    }


    public function pivotX(px:Float):AssetWrapper
    {
        asset.pivotX = px;
        return this;
    }

    public inline function px(px:Float):AssetWrapper
    {
        return pivotX(px);
    }


    public function pivotY(py:Float):AssetWrapper
    {
        asset.pivotY = py;
        return this;
    }

    public inline function py(py:Float):AssetWrapper
    {
        return pivotY(py);
    }


    public function pivots(px:Float, py:Float):AssetWrapper
    {
        return pivotX(px).pivotY(py);
    }

    public inline function ps(px:Float, py:Float):AssetWrapper
    {
        return pivots(px, py);
    }


    public function userData(u:Dynamic):AssetWrapper
    {
        asset.userData = u;
        return this;
    }

    public inline function u(u:Dynamic):AssetWrapper
    {
        return userData(u);
    }


    public function visible(b:Bool = true):AssetWrapper
    {
        asset.visible = b;
        return this;
    }

    public inline function v(b:Bool = true):AssetWrapper
    {
        return visible(b);
    }


    public function mouseEnabled(b:Bool = true):AssetWrapper
    {
        asset.mouseEnabled = b;
        return this;
    }

    public inline function me(b:Bool = true):AssetWrapper
    {
        return mouseEnabled(b);
    }


    public function mouseChildren(b:Bool = true):AssetWrapper
    {
        asset.mouseChildren = b;
        return this;
    }

    public inline function mc(b:Bool = true):AssetWrapper
    {
        return mouseChildren(b);
    }


    public function buttonMode(b:Bool = true):AssetWrapper
    {
        asset.buttonMode = b;
        return this;
    }

    public inline function bm(b:Bool = true):AssetWrapper
    {
        return buttonMode(b);
    }


    public function tabEnabled(b:Bool = true):AssetWrapper
    {
        asset.tabEnabled = b;
        return this;
    }

    public inline function te(b:Bool = true):AssetWrapper
    {
        return tabEnabled(b);
    }
}
