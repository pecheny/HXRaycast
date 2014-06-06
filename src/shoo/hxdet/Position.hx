package shoo.hxdet;
import flash.geom.Point;
class Position {

	public var x:Float;
    public var y:Float;

	public function new() {
	}

	@:from
   static public inline function fromPoint(p:Point):Position {
       var component = new Position();
       component.x = p.x;
       component.y = p.y;
       return component;
   }

   static public inline function fromXY(x, y):Position {
       var component = new Position();
       component.x = x;
       component.y = y;
       return component;
   }

   static public inline function fromPsition(p:Position):Position {
       var component = new Position();
       component.x = p.x;
       component.y = p.y;
       return component;
   }

   @to
   public function toString():String {
       return "x: " + x + ", y: " + y;
   }
}