// Automatically generated by share/Main.hx.sh
class Main
{
    static function main()
    {
        var r = new haxe.unit.TestRunner();
        r.add(new AssetBuilderTest());
        r.add(new EasingsTest());
        r.add(new SequenceTest());
        r.add(new TweenTest());
        r.add(new UtilTest());
        r.run();
    }
}
