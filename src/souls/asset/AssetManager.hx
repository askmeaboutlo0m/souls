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

import openfl.Assets;
import souls.display.BitmapDrawable;
import souls.display.Drawable;
import souls.error.AssetError;

#if svg
import format.SVG;
import souls.display.VectorDrawable;
#end


class AssetManager implements AssetManagement
{
    public function new() {}

  #if svg
    static function vec(path:String):VectorDrawable
    {
        if (Assets.exists(path, TEXT)) {
            return new VectorDrawable(new SVG(Assets.getText(path)));
        }
        return null;
    }
  #end

    static function bmp(path:String):BitmapDrawable
    {
        if (Assets.exists(path, IMAGE)) {
            return new BitmapDrawable(Assets.getBitmapData(path));
        }
        return null;
    }


    public function findAsset(path:String):Drawable
    {
        var drawable:Drawable;
      #if svg
        if ((drawable = vec('$path.svg')) != null) {
            return drawable;
        }
      #end
        if ((drawable = bmp('$path.png')) != null) {
            return drawable;
        }
      #if svg
        if ((drawable = vec(path)) != null) {
            return drawable;
        }
      #end
        if ((drawable = bmp(path)) != null) {
            return drawable;
        }

        throw new AssetError(path);
    }
}
