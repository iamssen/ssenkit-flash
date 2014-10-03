package ssen.components.alerts {

import spark.components.RichText;

import ssen.components.graphics.SVGImage;
import ssen.text.TextLineFactory;

public class RichTextAlertBase extends AlertBase {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[Embed(source="snippets/assets/alert.svg")]
	private static const AlertImage:Class;

	[SkinPart]
	public var symbolImage:SVGImage;

	[SkinPart]
	public var messageText:RichText;

	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// properties
	//----------------------------------------------------------------
	//---------------------------------------------
	// symbol
	//---------------------------------------------
	private var _symbol:*;

	/** symbol */
	public function get symbol():* {
		return _symbol;
	}

	public function set symbol(value:*):void {
		_symbol = value;
		invalidate_message();
	}

	//---------------------------------------------
	// message
	//---------------------------------------------
	private var _message:String;

	/** message */
	public function get message():String {
		return _message;
	}

	public function set message(value:String):void {
		_message = value;
		invalidate_message();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	//---------------------------------------------
	// inavalidate message
	//---------------------------------------------
	private var messageChanged:Boolean;

	final protected function invalidate_message():void {
		messageChanged = true;
		invalidateProperties();
	}


	override protected function commitProperties():void {
		super.commitProperties();

		if (messageChanged) {
			commit_message();
			messageChanged = false;
		}
	}

	//---------------------------------------------
	// commit message
	//---------------------------------------------
	protected function commit_message():void {
		if (messageText) {
			messageText.textFlow = TextLineFactory.getTextFlow(_message);
		}

		if (symbolImage) {
			if (!_symbol) _symbol = AlertImage;
			symbolImage.source = _symbol;
		}
	}

	//==========================================================================================
	// skin
	//==========================================================================================
	/** @private */
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === messageText) {
			commit_message();
		}
	}
}
}
