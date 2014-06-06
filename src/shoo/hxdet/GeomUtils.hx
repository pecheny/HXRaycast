package shoo.hxdet;
class GeomUtils {

	private static inline var ROUND_PERC:Float = 10000;

	public static inline function distanceBetween(x1:Float, y1:Float, x2:Float, y2:Float):Float {
        var dx = x2 - x1;
        var dy = y2 - y1;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public static inline function length(p:Position):Float {
           var dx = p.x;
           var dy = p.y;
           return Math.sqrt(dx * dx + dy * dy);
       }

    public static inline function distanceBetweenPositions(p1:Position, p2:Position):Float {
        var dx = p2.x - p1.x;
        var dy = p2.y - p1.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public static inline function calulateKB(x1, y1, x2, y2):KB {
        var k = (y2 - y1) / (x2 - x1);
        var b = y1 - k * x1;
        return {k:k, b:b};
    }

    public static inline function intersectLines(l1:Line, l2:Line):Position {
        var alpha = l1.b / l2.b;
        var denominator = l1.a - alpha * l2.a;
        if (denominator == 0) {
            throw "There is no intersection";
        }
        var x = (-l1.c + alpha * l2.c) / (denominator);
        var y = -(l2.a * x + l2.c) / l2.b;
        return Position.fromXY(x, y);
    }

    public static inline function intersectLinesWithOffset(l1:Line, l2:Line):Position {
            var alpha = l1.b / l2.b;
            var denominator = l1.a - alpha * l2.a;
            if (denominator == 0) {
                throw "There is no intersection";
            }
            var x = (-l1.c + alpha * l2.c) / (denominator);
            var y = -(l2.a * x + l2.c) / l2.b;
            return Position.fromXY(x, y);
        }

    public static inline function  lineFromPoints(x1:Float, y1:Float, x2:Float, y2:Float):Line {
        var a = y1 - y2;
        var b = x2 - x1;
        var c = -a * x1 - b * y1;
        return {a: a, b: b, c: c};
    }

    public static inline function segmentFromPoints(x1:Float, y1:Float, x2:Float, y2:Float):Segment {
        var a = y1 - y2;
        var b = x2 - x1;
        var c = -a * x1 - b * y1;
        var len = Math.sqrt(a * a + b * b);
        return {a: a, b: b, c: c, x0: x1, y0:y1, length:len};
    }

    public static inline function lineFromABC(a, b, c):Line {
        return {a: a, b: b, c: c};
    }



    public static inline function areParallel(l1:Line, l2:Line):Bool {
        var oneHorisontal = ((l1.a == 0) || (l2.a == 0)) && (l1.a != l2.a);
        var oneVertica = ((l1.b == 0) || (l2.b == 0)) && (l1.b != l2.b);
        var ratio1 = Std.int((l1.a / l1.b) * ROUND_PERC);
        var ratio2 = Std.int((l2.a / l2.b) * ROUND_PERC);
        return (ratio1 == ratio2) && !oneHorisontal && !oneVertica;
    }

    public static function rayCrossLine(rayStartX:Float, rayStartY:Float, rayDirX:Float, rayDirY:Float, line:Line):Bool {
        if (areParallel(line, lineFromPoints(rayStartX, rayStartY, rayDirX, rayDirY))) {
            return false;
        }
        var l1 = line.a * rayStartX + line.b * rayStartY + line.c;
        var l2 = line.a * rayDirX + line.b * rayDirY + line.c;
        if ((l1 * l2 >= 0) && (l2 * l2 > l1 * l1)) {
            return false;
        }
        return true;
    }

    public static function rayCrossSegment(rayStartX:Float, rayStartY:Float, rayDirX:Float, rayDirY:Float, segment:Segment):Bool {
        if (!rayCrossLine(rayStartX, rayStartY, rayDirX, rayDirY, segment)) {
            return false;
        }
        var t = distanceBetweenPositions(Position.fromXY(segment.x0, segment.y0), intersectLines(segment, lineFromPoints(rayStartX, rayStartY, rayDirX, rayDirY)));
        return ((t >= 0) && (t <= segment.length));
    }
}

typedef KB = {
k:Float,
b:Float
}

typedef Line = {
a:Float,
b:Float,
c:Float
}

typedef Segment = {
a:Float,
b:Float,
c:Float,
x0:Float,
y0:Float,
length:Float
}