package ssen.components.alerts {

import flash.events.MouseEvent;

import spark.components.Button;

public class Alert extends AlertBase {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart]
	public var okButton:Button;

	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// okText
	//---------------------------------------------
	private var _okText:String;

	/** okText */
	public function get okText():String {
		return _okText;
	}

	public function set okText(value:String):void {
		_okText=value;
		invalidateOkText();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var okTextChanged:Boolean;

	protected function invalidateOkText():void {
		if (_okText) {
			okTextChanged=true;
			invalidateProperties();
		}
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (okTextChanged) {
			commitOkText();
			okTextChanged=false;
		}
	}

	protected function commitOkText():void {
		if (okButton) {
			okButton.label=_okText;
		}
	}

	//==========================================================================================
	// implements skin
	//==========================================================================================
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === okButton) {
			invalidateOkText();
			okButton.addEventListener(MouseEvent.CLICK, okHandler, false, 0, true);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		if (instance === okButton) {
			okButton.removeEventListener(MouseEvent.CLICK, okHandler);
		}

		super.partRemoved(partName, instance);
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function okHandler(event:MouseEvent):void {
		close();
	}
}
}
