package shoo.hxdet;
import shoo.hxdet.GeomUtils.Line;
using shoo.hxdet.GeomUtils.Line;
class Corridor implements ICollidable {


	@:allow(CorridorTest)
	var carrier:Line;
	@:allow(CorridorTest)
	var normal:Line;
	var dw1:Float;
	var dw2:Float;
	var directionX:Float;
	var directionY:Float;

	inline static var EPS = 0.0001;

	public var x:Float;
	public var y:Float;

	var cross1:Position;
	var cross2:Position;

	public function new(startX:Float, startY:Float, endX:Float, endY:Float, width:Float) {
		width /= 2;
		var a = startY - endY;
		var b = endX - startX;
		var cc = -a * (startX + b / 2) - b * (startY - a / 2);
		var cn = b * (startX + b / 2) - a * (startY - a / 2);
		dw1 = width * width * 2 ;
		dw2 = (a * a + b * b) / 2;
		var length = Math.sqrt(a * a + b * b) / 2;
		directionX = b / (2*length);
		directionY = -a / (2*length);
		var carrierEquationFactor = width / length;
		carrier = GeomUtils.lineFromABC(a * carrierEquationFactor, b * carrierEquationFactor, cc * carrierEquationFactor);
		normal = GeomUtils.lineFromABC(-b, a, cn);

	}

	public function isInside(x:Float, y:Float):Bool {
		return inStrictLengthwiseBounds(x, y) && inStrictTransversalBounds(x, y);
	}
	public inline function inStrictLengthwiseBounds(x:Float, y:Float):Bool {
		var d = normal.a * x + normal.b * y + normal.c;
		return (Math.abs(d) < dw2 - EPS);
	}

	public inline function inStrictTransversalBounds(x:Float, y:Float):Bool {
		var d = carrier.a * x + carrier.b * y + carrier.c;
		return (Math.abs(d) < dw1 - EPS);
	}

	public inline function inLengthwiseBounds(x:Float, y:Float, eps = 0.000001):Bool {
		var d = normal.a * x + normal.b * y + normal.c;
		return (dw2 - Math.abs(d) >= -eps);
	}

	public inline function inTransversalBounds(x:Float, y:Float, eps = 0.000001):Bool {
		var d = carrier.a * x + carrier.b * y + carrier.c;
		return (dw1 - Math.abs(d) >= -eps );
	}


	public function getIntersection(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Position {
		cross1 = null;
		cross2 = null;
		var x:Float;
		var y:Float;
		var alpha:Float;
		var rayLine = GeomUtils.lineFromPoints(rayStartX, rayStartY, rayDirectionX, rayDirectionY);


//       if ray starts after end of the corridor along the ray direction

		var transversalFactor = getDirectionFactor(carrier, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		var solve = resolveEquation(carrier, rayStartX, rayStartY);
		if (checkBehindRayDirection(-transversalFactor, solve, dw1, 1)) {
			return null;
		}
		var lengthwiseFactor = -getDirectionFactor(normal, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		solve = resolveEquation(normal, rayStartX, rayStartY);
		if (checkBehindRayDirection(lengthwiseFactor, solve, dw2, 1)) {
			return null;
		}


		if (isInside(rayStartX, rayStartY)) {
			return getIntersectionFromInside(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		}

		if (rayLine.b == 0) {
			return getIntersectionWithVertivalRay(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		}

		alpha = carrier.b / rayLine.b;

		if (!GeomUtils.areParallel(rayLine, carrier)) {
			x = (dw1 - carrier.c + alpha * rayLine.c) / (carrier.a - rayLine.a * alpha);
			y = -(rayLine.c + rayLine.a * x) / rayLine.b;

			if (inLengthwiseBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
			x = (-dw1 - carrier.c + alpha * rayLine.c) / (carrier.a - rayLine.a * alpha);
			y = -(rayLine.c + rayLine.a * x) / rayLine.b;

			if (inLengthwiseBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
		}

		alpha = normal.b / rayLine.b;

		if (!GeomUtils.areParallel(rayLine, normal)) {
			x = (dw2 - normal.c + alpha * rayLine.c) / (normal.a - rayLine.a * alpha);
			y = -(rayLine.c + rayLine.a * x) / rayLine.b;

			if (inTransversalBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
			x = (-dw2 - normal.c + alpha * rayLine.c) / (normal.a - rayLine.a * alpha);
			y = -(rayLine.c + rayLine.a * x) / rayLine.b;

			if (inTransversalBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
		}
		return cross1;
	}

	@:allow(CorridorTest)
	private inline function getDirectionFactor(line:Line, rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Float {
		var len1:Float = 0;
		var len2:Float = 0;
		len1 = line.a * rayStartX + line.b * rayStartY + line.c;
		len2 = line.a * rayDirectionX + line.b * rayDirectionY + line.c;
		return len2 - len1;
	}

	private inline function resolveEquation(line:Line, x:Float, y:Float):Float {
		return line.a * x + line.b * y + line.c;
	}

	private function checkBehindRayDirection(directionFactor:Float, rayStartOffset:Float, maxOffset:Float, maxOffsetSign:Int):Bool {
		return (((directionFactor > 0) && (rayStartOffset < -maxOffset * maxOffsetSign)) || ((directionFactor < 0) && (rayStartOffset > maxOffset * maxOffsetSign)));
	}


	public function finalizeIntersection(rayStartX:Float, rayStartY:Float):Position {
		if (GeomUtils.distanceBetween(rayStartX, rayStartY, cross1.x, cross1.y) > GeomUtils.distanceBetween(rayStartX, rayStartY, cross2.x, cross2.y)) {
			return cross2;
		}
		return cross1;

	}

	private inline function addCrossAndCheckComplete(x, y):Bool {
		if (cross1 == null) {
			cross1 = Position.fromXY(x, y);
			return false;
		} else {
			cross2 = Position.fromXY(x, y);
			return true;
		}
	}

	public function getIntersectionFromInside(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Position {
		cross1 = null;
		cross2 = null;
		var x:Float;
		var y:Float;

		var rayLine = GeomUtils.lineFromPoints(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		if (rayLine.b == 0) {
			return getInsideIntersectionWithVertivalRay(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		}

		var alpha = carrier.b / rayLine.b;
		var denominator = carrier.a - alpha * rayLine.a;

		var transversalFactor = getDirectionFactor(carrier, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		var solve = resolveEquation(carrier, rayStartX, rayStartY);
		if (checkBehindRayDirection(-transversalFactor, solve, dw1, 1)) {
			return null;
		}
		var lengthwiseFactor = -getDirectionFactor(normal, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		solve = resolveEquation(normal, rayStartX, rayStartY);
		if (checkBehindRayDirection(lengthwiseFactor, solve, dw2, 1)) {
			return null;
		}

		if (!GeomUtils.areParallel(rayLine, carrier)) {
			if (transversalFactor > 0) {
				x = (dw1 - carrier.c + alpha * rayLine.c) / (denominator);
				y = -(rayLine.c + rayLine.a * x) / rayLine.b;
				if (inLengthwiseBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
			} else {
				x = (-dw1 - carrier.c + alpha * rayLine.c) / (denominator);
				y = -(rayLine.c + rayLine.a * x) / rayLine.b;
				if (inLengthwiseBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				} }
		}
		alpha = normal.b / rayLine.b;
		denominator = normal.a - alpha * rayLine.a;
		if (!GeomUtils.areParallel(rayLine, normal)) {
			if (lengthwiseFactor > 0) {
				x = (-dw2 - normal.c + alpha * rayLine.c) / (denominator);
				y = -(rayLine.c + rayLine.a * x) / rayLine.b;
				if (inTransversalBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
			} else {
				x = (dw2 - normal.c + alpha * rayLine.c) / (denominator);
				y = -(rayLine.c + rayLine.a * x) / rayLine.b;
				if (inTransversalBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
			}
		}

		return cross1;
	}

	public function getInsideIntersectedRayLength(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Float {
		var cross = getIntersectionFromInside(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		if (cross != null) {
			return GeomUtils.distanceBetween(rayStartX, rayStartY, cross.x, cross.y);
		} else {
			return -1;
		}
	}

	public function getIntersectedRayLength(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Float {
		var cross = getIntersection(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		if (cross != null) {
			return GeomUtils.distanceBetween(rayStartX, rayStartY, cross.x, cross.y);
		} else {
			return -1;
		}
	}

	public function offsetIstide(x:Float, y:Float, offset:Float):Position {
		var pos = new Position();
		var pnXnorm = (normal.a * x + normal.b * y + normal.c) / dw2;
		var pnXcarr = (carrier.a * x + carrier.b * y + carrier.c) / dw1;
		var xs = (pnXnorm > 0) ? 1 : -1;
		var ys = (pnXcarr > 0) ? 1 : -1;
		var longwise = (Math.abs(pnXnorm) > Math.abs(pnXcarr));
		if (longwise) {
			pos.x = x + xs * directionX * offset;
			pos.y = y + xs * directionY * offset;
		} else {
			pos.x = x + directionY * offset * ys;
			pos.y = y + directionX * offset * ys * (-1);
		}
		return pos;
	}

	private function getIntersectionWithVertivalRay(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Position {
		cross1 = null;
		cross2 = null;
		var y:Float;
		var len1:Float = 0;
		var len2:Float = 0;
		var transversalFactor:Float = 0;
		var lengthwiseFactor:Float = 0;
		var rayLine = GeomUtils.lineFromPoints(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		var x:Float = -rayLine.c / rayLine.a;

		var transversalFactor = getDirectionFactor(carrier, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		var solve = resolveEquation(carrier, rayStartX, rayStartY);
		if (checkBehindRayDirection(-transversalFactor, solve, dw1, 1)) {
			return null;
		}
		var lengthwiseFactor = -getDirectionFactor(normal, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		solve = resolveEquation(normal, rayStartX, rayStartY);
		if (checkBehindRayDirection(lengthwiseFactor, solve, dw2, 1)) {
			return null;
		}

		if (isInside(rayStartX, rayStartY)) {
			return getInsideIntersectionWithVertivalRay(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		}


		if (!GeomUtils.areParallel(rayLine, carrier)) {
			y = (-dw1 - carrier.c + carrier.a * x) / carrier.b;
			if (inLengthwiseBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
			y = (dw1 - carrier.c + carrier.a * x) / carrier.b;
			if (inLengthwiseBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
		}
		if (!GeomUtils.areParallel(rayLine, normal)) {

			y = (dw2 - normal.c + normal.a * x) / normal.b;
			if (inTransversalBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
			y = (-dw2 - normal.c + normal.a * x) / normal.b;
			if (inTransversalBounds(x, y)) {
				if (addCrossAndCheckComplete(x, y)) {
					return finalizeIntersection(rayStartX, rayStartY);
				}
			}
		}
		return cross1;
	}


	private function getInsideIntersectionWithVertivalRay(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Position {
		cross1 = null;
		cross2 = null;
		var y:Float;
		var len1:Float = 0;
		var len2:Float = 0;
		var transversalFactor:Float = 0;
		var lengthwiseFactor:Float = 0;
		var rayLine = GeomUtils.lineFromPoints(rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		var x:Float = -rayLine.c / rayLine.a;
		var y0:Float;
		var transversalFactor = getDirectionFactor(carrier, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		var solve = resolveEquation(carrier, rayStartX, rayStartY);
		if (checkBehindRayDirection(-transversalFactor, solve, dw1, 1)) {
			return null;
		}
		var lengthwiseFactor = -getDirectionFactor(normal, rayStartX, rayStartY, rayDirectionX, rayDirectionY);
		solve = resolveEquation(normal, rayStartX, rayStartY);
		if (checkBehindRayDirection(lengthwiseFactor, solve, dw2, 1)) {
			return null;
		}
		if (!GeomUtils.areParallel(rayLine, carrier)) {
			y0 = -(carrier.c + carrier.a * x)/ carrier.b;
			if (transversalFactor > 0) {
				y = y0 + Math.sqrt(dw1/2) / ( directionX) ;
				if (inLengthwiseBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
		} else {
				y = y0 - Math.sqrt(dw1/2) / ( directionX);
				if (inLengthwiseBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
		}
		}
		if (!GeomUtils.areParallel(rayLine, normal)) {
			y0 = -(normal.c + normal.a * x) / normal.b;
			if (lengthwiseFactor > 0) {
				y = y0+ Math.sqrt(dw2/2) / ( directionY);
				if (inTransversalBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
		} else {
				y = y0 - Math.sqrt(dw2/2) / ( directionY);
				if (inTransversalBounds(x, y)) {
					if (addCrossAndCheckComplete(x, y)) {
						return finalizeIntersection(rayStartX, rayStartY);
					}
				}
		}
		}
		return cross1;
	}
}