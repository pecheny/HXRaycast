package ;

import massive.munit.Assert;
import org.hamcrest.MatchersBase;
import shoo.hxdet.Corridor;
class CorridorTest extends MatchersBase {
	var corridor:Corridor;

	@Before public function startup() {

	}


	@Test public function horizontal_corridor_horisontal_ray_outside():Void {
		corridor = new Corridor(-1, 0, 7, 0, 2);
		var l = corridor.getIntersectedRayLength(-5, 0, 5, 0);

		var intersection = corridor.getIntersection(-5, 0.5, 5, 0.5);
		assertThat(intersection.x, closeTo(-1, 0.2));
		assertThat(intersection.y, closeTo(0.5, 0.2));

		var intersection = corridor.getIntersection(0, 0.5, 5, 0.5);
		assertThat(intersection.x, closeTo(7, 0.2));
		assertThat(intersection.y, closeTo(0.5, 0.2));

		intersection = corridor.getIntersection(8, 0.5, 9, 0.5);
		Assert.isNull(intersection);

		intersection = corridor.getIntersection(6, 1.01, 6, 8);
		Assert.isNull(intersection);
		intersection = corridor.getIntersection(6, 1, 6, 8);
		assertThat(intersection.x, closeTo(6, 0.2));
		assertThat(intersection.y, closeTo(1, 0.2));

		var intersection = corridor.getIntersectionFromInside(6, 1, 6, 8);
		assertThat(intersection.x, closeTo(6, 0.3));
		assertThat(intersection.y, closeTo(1, 0.3));
	}

	@Test public function vertical_corridor_horisontal_ray_outside():Void {
		corridor = new Corridor(1, -1, 1, 1, 2);
		var l = corridor.getIntersectedRayLength(-5, 0, 5, 0);
		assertThat(l, closeTo(5, 0.2));
		var intersection = corridor.getIntersection(-5, 0, 5, 0);
		assertThat(intersection.x, closeTo(0, 0.2));
		assertThat(intersection.y, closeTo(0, 0.2));

	}

	@Test public function tiled_corridor_tiled_ray_inside():Void {
		corridor = new Corridor(350, 260, 500, 500, 40);
		var intersection = corridor.getIntersectionFromInside(503, 490, 511, 500);
		Assert.isTrue(corridor.isInside(504, 491));
		Assert.isFalse(corridor.isInside(511, 500));
		Assert.isFalse(corridor.isInside(intersection.x, intersection.y));

		corridor = new Corridor(0,0,200,200, 2 * Math.sqrt(2));
		var intersection = corridor.getIntersectionFromInside(100,100, 200,300);
		Assert.isFalse(corridor.isInside(intersection.x, intersection.y));
	}

	@Test public function horizontal_corridor_vertical_ray_outside():Void {
		corridor = new Corridor(0, 0, 10, 0, 2);
		var intersection = corridor.getIntersection(2, 2, 2, 0);
		assertThat(intersection.x, closeTo(2, 0.2));
		assertThat(intersection.y, closeTo(1, 0.2));

	}

	@Test public function vertical_corridor_vertical_ray_outside():Void {
		corridor = new Corridor(1, -1, 1, 1, 10);
		var intersection = corridor.getIntersection(2, 2, 2, 0);
		assertThat(intersection.x, closeTo(2, 0.2));
		assertThat(intersection.y, closeTo(1, 0.2));
	}

	@Test public function horizontal_corridor_horisontal_ray_inside():Void {
		corridor = new Corridor(0, 0, 10, 0, 2);

		var intersection = corridor.getIntersectionFromInside(5, 0, 15, 0);
		assertThat(intersection.x, closeTo(10, 0.2));
		assertThat(intersection.y, closeTo(0, 0.2));
	}


	@Test public function vertical_ray_from_inside():Void {
		corridor = new Corridor(1, -1, 1, 1, 10);
		var intersection = corridor.getIntersectionFromInside(2, 2, 2, 0);
		assertThat(intersection.x, closeTo(2, 0.2));
		assertThat(intersection.y, closeTo(-1, 0.2));
		intersection = corridor.getIntersectionFromInside(2, 0, 2, 2);
		assertThat(intersection.x, closeTo(2, 0.2));
		assertThat(intersection.y, closeTo(1, 0.2));
	}

	@Test public function tilted_corridor_horisontal_ray_outside():Void {
		corridor = new Corridor(0, 0, 3, 3, Math.sqrt(8));
		var intersection = corridor.getIntersection(-1, 2, 5, 2);
		assertThat(intersection.x, closeTo(0, 0.2));
		assertThat(intersection.y, closeTo(2, 0.2));
	}

	@Test public function vertical_ray_tiled_corridor():Void {
		corridor = new Corridor(100, 100, 300, 300, 1000);
		var intersection = corridor.getIntersection(200, 150, 200, -100);
		assertThat(intersection.x, closeTo(200, 0.2));
		assertThat(intersection.y, closeTo(0, 0.2));
	}

	@Test public function inLengthwiseBounds_test():Void {
		corridor = new Corridor(0, 0, 3, 0, 10);
		Assert.isTrue(corridor.inStrictLengthwiseBounds(0.01, 5));
		Assert.isTrue(corridor.inStrictLengthwiseBounds(2.99, 5));
		Assert.isFalse(corridor.inStrictLengthwiseBounds(3, 5));
		Assert.isFalse(corridor.inStrictLengthwiseBounds(0, 5));

		corridor = new Corridor(1, -1, 1, 1, 10);
		Assert.isFalse(corridor.inStrictLengthwiseBounds(1, 1));
	}

	@Test public function inTransversalBounds_test():Void {
		corridor = new Corridor(1.5, -1, 1.5, 1, 3);
		Assert.isTrue(corridor.inStrictTransversalBounds(0.01, 5));
		Assert.isTrue(corridor.inStrictTransversalBounds(2.99, 5));
		Assert.isFalse(corridor.inStrictTransversalBounds(3, 5));
		Assert.isFalse(corridor.inStrictTransversalBounds(0, 5));
	}

	@Test public function getDirectionFactor_test():Void {
		corridor = new Corridor(1, 0, 5, 0, 2);
		var lengthwiseFactor = corridor.getDirectionFactor(corridor.normal, 0, 0, 0.5, 0);
		assertThat(lengthwiseFactor, lessThan(0));
		lengthwiseFactor = corridor.getDirectionFactor(corridor.normal, -10, 0, -5, 0);
		assertThat(lengthwiseFactor, lessThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.normal, -10, 0, 5, 0);
		assertThat(lengthwiseFactor, lessThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.normal, 1, 0, 5, 0);
		assertThat(lengthwiseFactor, lessThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.normal, 4, 0, 5, 0);
		assertThat(lengthwiseFactor, lessThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.normal, 6, 0, 15, 0);
		assertThat(lengthwiseFactor, lessThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.carrier, 0, 0, 0, 0.5);
		assertThat(lengthwiseFactor, greaterThan(0));
		lengthwiseFactor = corridor.getDirectionFactor(corridor.carrier, 0, -10, 0, -5);
		assertThat(lengthwiseFactor, greaterThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.carrier, 0, -10, 0, 5);
		assertThat(lengthwiseFactor, greaterThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.carrier, 0, 1, 0, 5);
		assertThat(lengthwiseFactor, greaterThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.carrier, 0, 4, 0, 5);
		assertThat(lengthwiseFactor, greaterThan(0));

		lengthwiseFactor = corridor.getDirectionFactor(corridor.carrier, 0, 6, 0, 15);
		assertThat(lengthwiseFactor, greaterThan(0));
	}
}