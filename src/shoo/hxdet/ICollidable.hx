package shoo.hxdet;
interface ICollidable {

	/**
	*   Returns <code>true</code> if the given point is inside the <code>ICollidable</code> instance.
	**/

function isInside(x:Float, y:Float):Bool;

	/**
	*  Returns first point of intersection of the line and the <code>ICollidable</code> instance in direction of thr given ray.
	**/


function getIntersection(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Position;

	/**
	*    Returns the point of intersection of the ray with the <code>ICollidable</code> instance in direction of thr given ray but ignores intersection with outer surface.
	**/

function getIntersectionFromInside(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Position;

	/**
	* Return length  from start of the ray to the first intersection point with inner surface.
	**/

function getInsideIntersectedRayLength(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Float;

	/**
	*   Return length  from start of the ray to the first intersection point with inner surface.
	**/


function getIntersectedRayLength(rayStartX:Float, rayStartY:Float, rayDirectionX:Float, rayDirectionY:Float):Float;

	/**
	*   Offset the given point inside the <code>ICollidable</code> along the normal.
	**/

function offsetIstide(x:Float, y:Float, offset:Float):Position;

var x:Float;
var y:Float;
}

