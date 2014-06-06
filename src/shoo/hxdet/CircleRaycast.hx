package shoo.hxdet;
import flash.geom.Point;
class CircleRaycast {


    public static function getDistanceFromPointToRay(point:Point, rayStart:Point, rayDirection:Point):Float {
        var a = Point.distance(rayStart, rayDirection);
        var b = Point.distance(rayStart, point);
        var c = Point.distance(point, rayDirection);
        var p = (a + b + c) / 2;
        var h = 2 / a * Math.sqrt(p * (p - a) * (p - b) * (p - c));
        if (a * a + b * b < c * c) {
//            return b; // (|.).>
            return -1;
        }
        return h;
    }

    public static function getT(point:Point, rayStart:Point, rayDirection:Point, r:Float):Float {
        var a = Point.distance(rayStart, rayDirection);
        var b = Point.distance(rayStart, point);
        var c = Point.distance(point, rayDirection);
        var p = (a + b + c) / 2;
        var h = 2 / a * Math.sqrt(p * (p - a) * (p - b) * (p - c));
        var d = Math.sqrt(r * r - h * h);
        var x = Math.sqrt(b * b - h * h);
        if (b > r) {
            return -d + x;
        } else if (a * a + b * b < c * c) {
            return d - x;
        } else {
            return d + x;

        }
    }

}