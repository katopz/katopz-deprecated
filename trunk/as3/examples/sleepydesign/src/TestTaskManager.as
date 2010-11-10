package
{
	import com.sleepydesign.core.Task;
	import com.sleepydesign.core.TaskManager;
	
	import flash.display.Sprite;

	public class TestTaskManager extends Sprite
	{
		public function TestTaskManager()
		{
			// try change true -> !true for toggle Parallel task
			var _taskManager:TaskManager = new TaskManager(!true);
			
			// test add task
			_taskManager.addTask(new MyTask2);
			_taskManager.addTask(new MyTask2);
			_taskManager.addTask(new MyTask1);
			_taskManager.addTask(new MyTask3);
			
			// test remove task
			var _removeTask:Task = _taskManager.addTask(new MyTask1) as Task;
			_taskManager.removeTask(_removeTask);
			
			_taskManager.addTask(new MyTask3);
			
			// start!
			_taskManager.completeSignal.addOnce(onAllComplete);
			_taskManager.start();
		}
		
		private function onAllComplete():void
		{
			trace(" ! onAllComplete");
		}
	}
}
import com.greensock.TweenLite;
import com.sleepydesign.core.Task;
import com.sleepydesign.core.TaskManager;
import com.sleepydesign.system.DebugUtil;

internal class MyTask1 extends Task
{
	override public function doTask():void
	{
		trace(" > MyTask1");
		for (var i:int = 0; i < 10; i++)
			DebugUtil.trace([" * MyTask1 : " + i]);
		trace(" < MyTask1");
	}
}

internal class MyTask2 extends Task
{
	override public function doTask():void
	{
		trace(" > MyTask2");
		var _taskManager:TaskManager = new TaskManager();
		_taskManager.addTask(new MyTask4);
		_taskManager.addTask(new MyTask5);
		_taskManager.completeSignal.addOnce(onTaskComplete);
		_taskManager.start();
	}
	
	private function onTaskComplete():void
	{
		trace(" < MyTask2");
		_completeSignal.dispatch();
	}
}

internal class MyTask3 extends Task
{
	override public function doTask():void
	{
		for (var i:int = 0; i < 5; i++)
			DebugUtil.trace([" * MyTask3 : " + i]);
	}
}

internal class MyTask4 extends Task
{
	override public function doTask():void
	{
		trace(" * MyTask4");
		TweenLite.to(this, 1, {onComplete:super.doTask});
	}
	
	override public function complete():void
	{
		trace(" * MyTask4.onComplete");
		super.complete();
	}
}

internal class MyTask5 extends Task
{
	override public function doTask():void
	{
		trace(" * MyTask5");
		TweenLite.to(this, 3, {onComplete:_completeSignal.dispatch});
	}
}