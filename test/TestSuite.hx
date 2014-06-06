import massive.munit.TestSuite;

import CircleTest;
import CorridorTest;
import DungeonDetectorTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(CircleTest);
		add(CorridorTest);
		add(DungeonDetectorTest);
	}
}
