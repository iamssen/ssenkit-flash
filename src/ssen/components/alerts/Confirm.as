package ssen.components.alerts {

import flash.events.MouseEvent;

import spark.components.Button;

public class Confirm extends AlertBase {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart]
	public var confirmButton:Button;

	[SkinPart]
	public var cancelButton:Button;

	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// confirmText
	//---------------------------------------------
	private var _confirmText:String;

	/** confirmText */
	public function get confirmText():String {
		return _confirmText;
	}

	public function set confirmText(value:String):void {
		_confirmText=value;
		invalidateConfirmText();
	}

	//---------------------------------------------
	// cancelText
	//---------------------------------------------
	private var _cancelText:String;

	/** cancelText */
	public function get cancelText():String {
		return _cancelText;
	}

	public function set cancelText(value:String):void {
		_cancelText=value;
		invalidateCancelText();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var confirmTextChanged:Boolean;
	private var cancelTextChanged:Boolean;

	protected function invalidateConfirmText():void {
		if (_confirmText) {
			confirmTextChanged=true;
			invalidateProperties();
		}
	}

	protected function invalidateCancelText():void {
		if (_cancelText) {
			cancelTextChanged=true;
			invalidateProperties();
		}
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (confirmTextChanged) {
			commitConfirmText();
			confirmTextChanged=false;
		}

		if (cancelTextChanged) {
			commitCancelText();
			cancelTextChanged=false;
		}
	}

	protected function commitConfirmText():void {
		if (confirmButton) {
			confirmButton.label=_confirmText;
		}
	}

	protected function commitCancelText():void {
		if (cancelText) {
			cancelButton.label=_cancelText;
		}
	}

	//==========================================================================================
	// implements skin
	//==========================================================================================
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === confirmButton) {
			invalidateConfirmText();
			confirmButton.addEventListener(MouseEvent.CLICK, confirmButtonClickHandler, false, 0, true);
		} else if (instance === cancelButton) {
			invalidateCancelText();
			cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler, false, 0, true);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		if (instance === confirmButton) {
			confirmButton.removeEventListener(MouseEvent.CLICK, confirmButtonClickHandler);
		} else if (instance === cancelButton) {
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
		}

		super.partRemoved(partName, instance);
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function cancelButtonClickHandler(event:MouseEvent):void {
		close();
	}

	private function confirmButtonClickHandler(event:MouseEvent):void {
		close(true, true);
	}
}
}
