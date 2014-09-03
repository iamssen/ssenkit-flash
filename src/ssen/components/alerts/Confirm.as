package ssen.flexkit.components.popup
{
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class Confirm extends SkinnableComponent
	{
		
		public function Confirm()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}