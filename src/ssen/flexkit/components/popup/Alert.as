package ssen.flexkit.components.popup {

import flash.events.MouseEvent;

import spark.components.Button;
import spark.components.supportClasses.SkinnableComponent;

public class Alert extends SkinnableComponent {

	[SkinPart(required="true")]
	public var okButton:Button;

	[Bindable]
	public var title:String="";

	[Bindable]
	public var message:Object;

	override protected function getCurrentSkinState():String {
		return super.getCurrentSkinState();
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === okButton) {
			okButton.addEventListener(MouseEvent.CLICK, okHandler, false, 0, true);
		}
	}

	private function okHandler(event:MouseEvent):void {
		
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		if (instance === okButton) {
			okButton.removeEventListener(MouseEvent.CLICK, okHandler);
		}

		super.partRemoved(partName, instance);
	}
}
}
