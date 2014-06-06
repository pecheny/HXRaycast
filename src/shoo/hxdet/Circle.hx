package shoo.hxdet;
import flash.geom.Point;
using shoo.hxdet.GeomUtils;
class Circle implements ICollidable {

    private var point:Point;
	inline static var EPS:Float = 0.00001;
    public var x:Float;
    public var y:Float;
    public var r:Float;

    public function new(x:Float, y:Float, r:Float):Void {
        point = new Point();
        this.x = x;
        this.y = y;
        this.r = r;
    }

	public function isInside( x:Float, y:Float):Bool {
        var dx = this.x - x;
        var dy = this.y - y;
        var sq = dx * dx + dy * dy;
        return (sq < r * r - EPS);
    }

    public function getIntersection(rayStartX, rayStartY, rayDirectionX, rayDirectionY):Position {
        var t = getIntersectedRayLength(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
        point.setTo(rayDirectionX - rayStartX, rayDirectionY - rayStartY);
        point.normalize(t);
        return Position.fromXY(rayStartX + point.x, rayStartY + point.y);
    }

    public function getIntersectionFromInside(rayStartX, rayStartY, rayDirectionX, rayDirectionY):Position {
        var t = getInsideIntersectedRayLength(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
        point.setTo(rayDirectionX - rayStartX, rayDirectionY - rayStartY);
        point.normalize(t);
        return Position.fromXY(rayStartX + point.x, rayStartY + point.y);
    }

    public function getInsideIntersectedRayLength(rayStartX, rayStartY, rayDirectionX, rayDirectionY):Float {
        var a = GeomUtils.distanceBetween(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
        if (a < 1) {
            return 1;
        }
        var b = GeomUtils.distanceBetween(rayStartX, rayStartY, x, y);
        var c = GeomUtils.distanceBetween(x, y, rayDirectionX, rayDirectionY);
        var p = (a + b + c) / 2;
        var h = 2 / a * Math.sqrt(p * (p - a) * (p - b) * (p - c)); // shortes distance from circle center to the ray
        var d = Math.sqrt(r * r - h * h);
        var x = Math.sqrt(b * b - h * h);
        if (h > r) {
            return -1;
        }

        if (a * a + b * b > c * c) {   //       (a * a + b * b > c * c) - ray intersects normal diameter / (.|) - 1; (|.) -0
            if (b > r) {  //       b > r - start point is outside
                return x + d;
            } else {
                return d + x;
            }
        }

        if (b > r) {
            return -1;
        } else {
            return d - x;
        }

    }

    public function getIntersectedRayLength(rayStartX, rayStartY, rayDirectionX, rayDirectionY):Float {
        var a = GeomUtils.distanceBetween(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
        var b = GeomUtils.distanceBetween(rayStartX, rayStartY, x, y);
        var c = GeomUtils.distanceBetween(x, y, rayDirectionX, rayDirectionY);
        var p = (a + b + c) / 2;
        var h = 2 / a * Math.sqrt(p * (p - a) * (p - b) * (p - c)); // shortes distance from circle center to the ray
        var d = Math.sqrt(r * r - h * h);
        var x = Math.sqrt(b * b - h * h);

        if (h > r) {
            return -1;
        }

        if (a * a + b * b > c * c) {  //       (a * a + b * b > c * c) - ray intersects normal diameter / (.|) - 1; (|.) -0
            if (b > r) {   //      b > r - start point is outside
                return x - d;
            } else {
                return d + x;
            }
        }

        if (b > r) {
            return -1;
        } else {
            return d - x;
        }
    }

    public function offsetIstide(x:Float, y:Float, offset:Float):Position {
    // todo move to getIntersection offset arg?
        point.setTo(this.x - x, this.y - y);
        point.normalize(offset);
        return Position.fromXY(x + point.x, y + point.y);
    }
}