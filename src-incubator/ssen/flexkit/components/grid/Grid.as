package ssen.flexkit.components.grid {

import mx.events.PropertyChangeEvent;

import spark.components.supportClasses.SkinnableComponent;

[SkinState("disabled")]

public class Grid extends SkinnableComponent {

	//==========================================================================================
	// parts
	//==========================================================================================
	[SkinPart]
	public var header:GridHeader;

	//---------------------------------------------
	// columnMode
	//---------------------------------------------
	private var _columnMode:String="ratio";

	/** columnMode */
	[Bindable]
	[Inspectable(type="Array", enumeration="fixed, ratio", defaultValue="ratio")]
	public function get columnMode():String {
		return _columnMode;
	}

	public function set columnMode(value:String):void {
		var oldValue:String=_columnMode;
		_columnMode=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnMode", oldValue, _columnMode));
		}

		invalidateProperties();
	}


	override protected function getCurrentSkinState():String {
		return super.getCurrentSkinState();
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);
	}

}
}
