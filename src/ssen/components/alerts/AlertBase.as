package ssen.components.alerts {
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

import mx.core.FlexGlobals;

import spark.components.Button;
import spark.components.RichText;
import spark.components.SkinnablePopUpContainer;

import ssen.common.StringUtils;

public class AlertBase extends SkinnablePopUpContainer {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart]
	public var titleText:RichText;

	[SkinPart]
	public var messageText:RichText;

	[SkinPart]
	public var closeButton:Button;

	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// title
	//---------------------------------------------
	private var _title:String;

	/** title */
	public function get title():String {
		return _title;
	}

	public function set title(value:String):void {
		_title=value;
		invalidateTitle();
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
		_message=value;
		invalidateMessage();
	}

	//==========================================================================================
	// methods
	//==========================================================================================
	public function openCenter(modal:Boolean=false):void {
		var app:DisplayObjectContainer=FlexGlobals.topLevelApplication as DisplayObjectContainer;
		open(app, modal);
		invalidateCenter();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var titleChanged:Boolean;
	private var messageChanged:Boolean;
	private var alignCenter:Boolean;

	protected function invalidateTitle():void {
		titleChanged=true;
		invalidateProperties();
	}

	protected function invalidateMessage():void {
		messageChanged=true;
		invalidateProperties();
	}

	protected function invalidateCenter():void {
		alignCenter=true;
		invalidateSize();
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	override protected function measure():void {
		super.measure();

		if (alignCenter) {
			var w:Number=getExplicitOrMeasuredWidth();
			var h:Number=getExplicitOrMeasuredHeight();

			x=int((stage.stageWidth - w) / 2);
			y=int((stage.stageHeight - h) / 2);

			alignCenter=false;
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();

		if (titleChanged) {
			commitTitle();
			titleChanged=false;
		}

		if (messageChanged) {
			commitMessage();
			messageChanged=false;
		}
	}

	protected function commitTitle():void {
		if (titleText) {
			titleText.textFlow=StringUtils.convertTextFlow(_title);
		}
	}

	protected function commitMessage():void {
		if (messageText) {
			messageText.textFlow=StringUtils.convertTextFlow(_message);
		}
	}

	//==========================================================================================
	// open
	//==========================================================================================
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === titleText) {
			invalidateTitle();
		} else if (instance === messageText) {
			invalidateMessage();
		} else if (instance === closeButton) {
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler, false, 0, true);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		if (instance === closeButton && closeButton.hasEventListener(MouseEvent.CLICK)) {
			closeButton.removeEventListener(MouseEvent.CLICK, closeButtonClickHandler);
		}

		super.partRemoved(partName, instance);
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function closeButtonClickHandler(event:MouseEvent):void {
		close();
	}
}
}
