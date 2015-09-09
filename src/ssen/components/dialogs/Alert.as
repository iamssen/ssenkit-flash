package ssen.components.dialogs {

import flash.events.MouseEvent;

import spark.components.Button;

import ssen.components.dialogs.snippets.AlertSkin;

public class Alert extends RichTextAlertBase {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart]
	public var okButton:Button;

	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// callbacks
	//----------------------------------------------------------------
	public var closeCallback:Function;

	//---------------------------------------------
	// okText
	//---------------------------------------------
	private var _okText:String = "OK";

	/** okText */
	public function get okText():String {
		return _okText;
	}

	public function set okText(value:String):void {
		_okText = value;
		invalidateOkText();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var okTextChanged:Boolean = true;

	protected function invalidateOkText():void {
		if (_okText) {
			okTextChanged = true;
			invalidateProperties();
		}
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (okTextChanged) {
			commitOkText();
			okTextChanged = false;
		}
	}

	protected function commitOkText():void {
		if (okButton) {
			okButton.label = _okText;
		}
	}

	//==========================================================================================
	// implements skin
	//==========================================================================================
	/** @private */
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === okButton) {
			invalidateOkText();
			okButton.addEventListener(MouseEvent.CLICK, okHandler, false, 0, true);
		}
	}

	/** @private */
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

	override protected function createChildren():void {
		if (!getStyle("skinClass") && !getStyle("skinFactory")) setStyle("skinClass", AlertSkin);
		super.createChildren();
	}

	//==========================================================================================
	// override
	//==========================================================================================
	/** @private */
	override protected function applyCallback(args:Array = null):void {
		if (closeCallback !== null) {
			closeCallback();
		}
	}
}
}
