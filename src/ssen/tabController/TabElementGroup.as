package ssen.tabController {
import mx.collections.ArrayList;
import mx.collections.IList;
import mx.core.IMXMLObject;
import mx.events.CollectionEvent;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerComponent;
import mx.managers.IFocusManagerContainer;

[DefaultProperty("initializeElements")]

public class TabElementGroup implements IMXMLObject {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// prev, next properties : focusComponentFunction > focusComponent > elementGroup > index
	//----------------------------------------------------------------
	public var prevTabElementGroup:TabElementGroup;
	public var nextTabElementGroup:TabElementGroup;

	public var prevFocusComponent:IFocusManagerComponent;
	public var nextFocusComponent:IFocusManagerComponent;

	public var prevFocusComponentFunction:Function;
	public var nextFocusComponentFunction:Function;

	//----------------------------------------------------------------
	// elements
	//----------------------------------------------------------------
	/** @private */
	[Inspectable(arrayType="ssen.tabController.TabElement")]
	public function set initializeElements(value:Array):void {
		elements=new ArrayList(value);
	}

	//---------------------------------------------
	// elements
	//---------------------------------------------
	private var _elements:IList;

	/** elements */
	public function get elements():IList {
		return _elements;
	}

	public function set elements(value:IList):void {
		_elements=value;
		_elements.addEventListener(CollectionEvent.COLLECTION_CHANGE, elementChanged, false, 0, true);
		setElements();
	}

	//---------------------------------------------
	// focusManagerContainer
	//---------------------------------------------
	private var _focusManagerContainer:IFocusManagerContainer;

	/** focusManagerContainer */
	public function get focusManagerContainer():IFocusManagerContainer {
		return _focusManagerContainer;
	}

	public function set focusManagerContainer(value:IFocusManagerContainer):void {
		_focusManagerContainer=value;
	}

	//==========================================================================================
	// construct
	//==========================================================================================
	public function initialized(document:Object, id:String):void {
		_focusManagerContainer=document as IFocusManagerContainer;
		setElements();
	}

	private function setElements():void {
		if (_elements) {
			var f:int=_elements.length;
			var element:TabElement;
			while (--f >= 0) {
				element=_elements.getItemAt(f) as TabElement;
				element.group=this;
				element.index=f;
			}
		}
	}

	//==========================================================================================
	// public api
	//==========================================================================================
	public function getFirstTabElementComponent():IFocusManagerComponent {
		var element:TabElement;

		if (_elements) {
			element=_elements.getItemAt(0) as TabElement;
		}

		return element ? element.component : null;
	}

	//==========================================================================================
	// internal apis
	//==========================================================================================
	internal function get focusManager():IFocusManager {
		return _focusManagerContainer.focusManager;
	}

	internal function getPrevFocusComponent(index:int):IFocusManagerComponent {
		var component:IFocusManagerComponent;

		if (_elements) {
			if (index - 1 < 0) {
				if (prevFocusComponentFunction !== null) {
					component=prevFocusComponentFunction();
				} else if (prevFocusComponent) {
					component=prevFocusComponent;
				} else if (prevTabElementGroup) {
					component=prevTabElementGroup.getFirstTabElementComponent();
				}
			} else {
				component=TabElement(_elements.getItemAt(index - 1)).component;
			}
		}

		return component;
	}

	internal function getNextFocusComponent(index:int):IFocusManagerComponent {
		var component:IFocusManagerComponent;

		if (_elements) {
			if (index + 1 >= _elements.length) {
				if (nextFocusComponentFunction !== null) {
					component=nextFocusComponentFunction();
				} else if (nextFocusComponent) {
					component=nextFocusComponent;
				} else if (nextTabElementGroup) {
					component=nextTabElementGroup.getFirstTabElementComponent();
				}
			} else {
				component=TabElement(_elements.getItemAt(index + 1)).component;
			}
		}

		return component;
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function elementChanged(event:CollectionEvent):void {
		setElements();
	}



}
}
