package ;
import shoo.hxdet.Circle;
import org.hamcrest.MatchersBase;
import massive.munit.Assert;
import shoo.hxdet.DungeonCollisionDetector;
using shoo.hxdet.DungeonCollisionDetector;

class DungeonDetectorTest extends MatchersBase {
    var dungeonCollisionDetector:DungeonCollisionDetector;

	private static inline var PERCISION:Float = 1;

    @Before public function setup():Void {
        dungeonCollisionDetector = new DungeonCollisionDetector();
    }


    @Test public function can_move_inside_oneCircle():Void {
        dungeonCollisionDetector.addAllowedCircle(0, 0, 100);
        Assert.isTrue(dungeonCollisionDetector.canMove(-99, 0, -80, 0));
        Assert.isTrue(dungeonCollisionDetector.canMove(0, 0, 99, 0));
        Assert.isTrue(dungeonCollisionDetector.canMove(0, -99, -50, -50));
        Assert.isFalse(dungeonCollisionDetector.canMove(0,-99, 0, -110));
    }

    @Test public function can_move_inside_several_circlesircle():Void {
        dungeonCollisionDetector.addAllowedCircle(0, 0, 110);
        dungeonCollisionDetector.addAllowedCircle(200, 0, 110);
        Assert.isTrue(dungeonCollisionDetector.canMove(80, 0, 108, 0));
        Assert.isTrue(dungeonCollisionDetector.canMove(108, 0, 112, 0));
        Assert.isTrue(dungeonCollisionDetector.canMove(80, 0, 120, 0));
        Assert.isFalse(dungeonCollisionDetector.canMove(0, 80, 0, 240));
    }


    @Test public function ray_lenght_test():Void {
        var circle = new Circle(0, 0, 100);
        assertThat(circle.getIntersectedRayLength(-50, 0, 200, 0), closeTo(150, 0.2));
        assertThat(circle.getIntersectedRayLength(0, 0, 200, 0), closeTo(100, 0.2));
        assertThat(circle.getIntersectedRayLength(75, 0, 200, 0), closeTo(25, 0.2));
        assertThat(circle.getIntersectedRayLength(105, 0, 200, 0), closeTo(-1, 0.2));
        assertThat(circle.getIntersectedRayLength(-200, 0, 200, 0), closeTo(100, 0.2));
        assertThat(circle.getIntersectedRayLength(-200, 200, 200, 200), closeTo(-1, 0.2));
    }

    @Test public function getPosition_test():Void {
        dungeonCollisionDetector.addAllowedCircle(0, 0, 150);
        var pos = dungeonCollisionDetector.getPosition(148, 0, 150, 0);
        assertThat(pos.x, closeTo(150, PERCISION));
        assertThat(pos.y, closeTo(0, PERCISION));
    }

    @Test public function getIntersectionFromInside_test():Void {
        var circle = new Circle(90, 10, 100);
        var len = circle.getInsideIntersectedRayLength(-200, 0, 200, 0);
        assertThat(len, closeTo(390, 0.6));
        var pos = circle.getIntersectionFromInside(-200, 0, 200, 0);
        assertThat(pos.x, closeTo(190, 0.6));
        assertThat(pos.y, closeTo(0, 0.5));

        circle = new Circle(350, 525 / 2, 150);
        var len = circle.getInsideIntersectedRayLength(365.45, 65.5, 365.4741001093139, 65.54988708651973);
        assertThat(len, lessThanOrEqualTo(2));
    }



    @Test public function vertical_ray_horisontal_corridor():Void {
        dungeonCollisionDetector.addAllowedCorridor(100, 200, 200, 200, 60);
        var intersection = dungeonCollisionDetector.getPosition(120, 170, 120, 169);
        assertThat(intersection.x, closeTo(120, 0.2));
        assertThat(intersection.y, closeTo(171, 0.2));
    }

    @Test public function vertical_ray_tiled_corridor():Void {
        dungeonCollisionDetector.addAllowedCorridor(100, 100, 300, 300, 100*Math.sqrt(8));
        var intersection = dungeonCollisionDetector.getPosition(200, 200, 200, -100);
        assertThat(intersection.x, closeTo(200, 1));
        assertThat(intersection.y, closeTo(0, 1));
    }
}