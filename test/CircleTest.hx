package ;
import org.hamcrest.MatchersBase;
import shoo.hxdet.Circle;
class CircleTest extends MatchersBase{
    @Test public function almost_vertical_raycast():Void {
    var circle = new Circle(500, 200, 150);
        var intersection = circle.getIntersection(370.15, 124.85, 370.17136913350686, 122.88689168601941);
        assertThat(intersection.x, closeTo(370, 1));
        assertThat(intersection.y, closeTo(123, 3));
    }
}