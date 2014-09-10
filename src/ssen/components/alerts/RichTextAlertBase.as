package ssen.components.alerts {
import com.greensock.TweenLite;
import com.greensock.easing.Quad;

import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

import mx.core.FlexGlobals;
import mx.managers.PopUpManager;

import spark.components.Button;
import spark.components.RichText;
import spark.components.supportClasses.SkinnableComponent;

import ssen.common.StringUtils;

[SkinState("normal")]

public class RichTextAlertBase extends SkinnableComponent {
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
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	public var openDuration:Number = 0.5;
	public var openEase:Function = Quad.easeOut;

	public var closeDuration:Number = 0.5;
	public var closeEase:Function = Quad.easeOut;

	//----------------------------------------------------------------
	// properties
	//----------------------------------------------------------------
	//---------------------------------------------
	// type
	//---------------------------------------------
	private var _type:String;

	/** type */
	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
		// TODO
	}

	//---------------------------------------------
	// title
	//---------------------------------------------
	private var _title:String;

	/** title */
	public function get title():String {
		return _title;
	}

	public function set title(value:String):void {
		_title = value;
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
		_message = value;
		invalidateMessage();
	}

	//==========================================================================================
	// methods
	//==========================================================================================
	final protected function getGlobalContainer():DisplayObjectContainer {
		return FlexGlobals.topLevelApplication as DisplayObjectContainer;
	}

	//----------------------------------------------------------------
	// open
	//----------------------------------------------------------------
	final public function open():void {
		addPopup();
	}

	protected function addPopup():void {
		alpha = 0;
		PopUpManager.addPopUp(this, getGlobalContainer(), true);
		TweenLite.to(this, openDuration, {alpha: 1, ease: openEase});
		invalidateCenter();
	}

	//----------------------------------------------------------------
	// close
	//----------------------------------------------------------------
	final public function close(...args:Array):void {
		applyCallback(args);
		closePopup(removePopup);
	}

	private function removePopup():void {
		PopUpManager.removePopUp(this);
	}

	protected function closePopup(removePopup:Function):void {
		if (closeDuration > 0) {
			TweenLite.to(this, closeDuration, {alpha: 0, ease: closeEase, onComplete: removePopup});
		} else {
			removePopup();
		}
	}

	protected function applyCallback(args:Array = null):void {
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var titleChanged:Boolean;
	private var messageChanged:Boolean;
	private var alignCenter:Boolean;

	protected function invalidateTitle():void {
		titleChanged = true;
		invalidateProperties();
	}

	protected function invalidateMessage():void {
		messageChanged = true;
		invalidateProperties();
	}

	protected function invalidateCenter():void {
		alignCenter = true;
		invalidateSize();
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	/** @private */
	override protected function measure():void {
		super.measure();

		if (alignCenter) {
			var w:Number = getExplicitOrMeasuredWidth();
			var h:Number = getExplicitOrMeasuredHeight();

			x = int((stage.stageWidth - w) / 2);
			y = int((stage.stageHeight - h) / 2);

			alignCenter = false;
		}
	}

	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (titleChanged) {
			commitTitle();
			titleChanged = false;
		}

		if (messageChanged) {
			commitMessage();
			messageChanged = false;
		}
	}

	protected function commitTitle():void {
		if (titleText) {
			titleText.textFlow = StringUtils.convertTextFlow(_title);
			invalidateCenter();
		}
	}

	protected function commitMessage():void {
		if (messageText) {
			messageText.textFlow = StringUtils.convertTextFlow(_message);
			invalidateCenter();
		}
	}

	//==========================================================================================
	// open
	//==========================================================================================
	/** @private */
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

	/** @private */
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
