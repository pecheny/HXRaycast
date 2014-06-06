package shoo.hxdet;
import flash.geom.Point;
using shoo.hxdet.CircleRaycast;
using shoo.hxdet.DungeonCollisionDetector;
class DungeonCollisionDetector {
	var allowed:Array<ICollidable>;
	var point:Point;

	public function new() {
		allowed = new Array<ICollidable>();
		point = new Point();
	}

	public function addAllowedCircle(x:Float, y:Float, r:Float):Int {
		return allowed.push(new Circle(x, y, r));
	}

	public function addAllowedCorridor(startX:Float, startY:Float, endX:Float, endY:Float, width:Float):Int {
		return allowed.push(new Corridor(startX, startY, endX, endY, width));
	}

/**
*       Returns most distant position visible fpom (x1, y1) in the diraction of (x2, y2)
**/

	public function getPosition(x1, y1, x2, y2):Position {
		var intersected:Array<ICollidable> = allowed.filter(function(circle:ICollidable):Bool {return circle.getInsideIntersectedRayLength(x1, y1, x2, y2) > -1;});
		intersected.sort(function(circle1:ICollidable, circle2:ICollidable):Int {return Std.int(circle1.getInsideIntersectedRayLength(x1, y1, x2, y2) - circle2.getInsideIntersectedRayLength(x1, y1, x2, y2));});
		var intersection = null;
		for (collider in intersected) {
			intersection = collider.getIntersectionFromInside(x1, y1, x2, y2);
			if (!isInside(intersection.x, intersection.y, collider)) {
				return collider.offsetIstide(intersection.x, intersection.y, 1);
			}
		}
		return Position.fromXY(x1, y1); // "Had not find outside point";
	}

	private  function isInside(x, y, ?excluded:ICollidable):Bool {
		for (circle in allowed) {
			if (circle == excluded) {
				continue;
			}
			if (circle.isInside(x, y)) {
				return true;
			}
		}
		return false;
	}

}





