package ssen.tabController {
import flash.events.FocusEvent;
import flash.events.IEventDispatcher;

import mx.managers.IFocusManagerComponent;

import ssen.common.IDisposable;

public class TabElement implements IDisposable {
	//==========================================================================================
	// properties : focusComponentFunction > index
	//==========================================================================================
	//----------------------------------------------------------------
	// prev, next
	//----------------------------------------------------------------
	public var prevFocusComponentFunction:Function;
	public var nextFocusComponentFunction:Function;

	//----------------------------------------------------------------
	// internal
	//----------------------------------------------------------------
	/** index of group element list */
	internal var index:int;

	/** tab element group */
	internal var group:TabElementGroup;

	//---------------------------------------------
	// component
	//---------------------------------------------
	private var _component:IFocusManagerComponent;

	/** component */
	public function get component():IFocusManagerComponent {
		return _component;
	}

	public function set component(value:IFocusManagerComponent):void {
		removeEvents();
		_component=value;
		addEvents();
	}

	private function addEvents():void {
		if (_component) {
			var dispatcher:IEventDispatcher=_component as IEventDispatcher;
			dispatcher.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
			dispatcher.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, false, 0, true);
		}
	}

	private function removeEvents():void {
		if (_component) {
			var dispatcher:IEventDispatcher=_component as IEventDispatcher;
			dispatcher.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
			dispatcher.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
		}
	}


	//==========================================================================================
	// construct, deconstruct
	//==========================================================================================
	public function dispose():void {
		removeEvents();
		_component=null;
		group=null;
		index=-1;
	}

	//==========================================================================================
	// protected
	//==========================================================================================
	protected function get focusEnabled():Boolean {
		return _component !== null;
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function keyFocusChangeHandler(event:FocusEvent):void {
		var next:IFocusManagerComponent=getNextComponent(event.shiftKey);

		if (next) {
			focusToNextComponent(next, event);
		}
	}

	private function focusInHandler(event:FocusEvent):void {
		if (!focusEnabled) {
			var next:IFocusManagerComponent=getNextComponent(event.shiftKey);

			if (next) {
				focusToNextComponent(next, event);
			}
		}
	}

	//----------------------------------------------------------------
	// utils
	//----------------------------------------------------------------
	private function getNextComponent(shiftKey:Boolean):IFocusManagerComponent {
		var next:IFocusManagerComponent;

		if (index > -1) {
			if (shiftKey) {
				if (prevFocusComponentFunction !== null) {
					next=prevFocusComponentFunction(group, this);
				}
				if (!next) {
					next=group.getPrevFocusComponent(index);
				}
			} else {
				if (nextFocusComponentFunction !== null) {
					next=nextFocusComponentFunction(group, this);
				}
				if (!next) {
					next=group.getNextFocusComponent(index);
				}
			}
		} else {
			throw new Error("index is -1");
		}

		return next;
	}

	private function focusToNextComponent(next:IFocusManagerComponent, event:FocusEvent):void {
		event.preventDefault();
		event.stopImmediatePropagation();
		event.stopPropagation();

		group.focusManager.setFocus(next);
	}
}
}
