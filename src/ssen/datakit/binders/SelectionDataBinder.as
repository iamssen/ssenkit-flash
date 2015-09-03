package ssen.datakit.binders {
import flash.events.EventDispatcher;

import mx.collections.ArrayList;
import mx.collections.IList;
import mx.events.PropertyChangeEvent;

public class SelectionDataBinder extends EventDispatcher {
	//---------------------------------------------
	// list
	//---------------------------------------------
	private var _list:IList;

	/** list */
	[Bindable]
	public function get list():IList {
		return _list;
	}

	public function set list(value:IList):void {
		var oldValue:IList = _list;
		_list = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "list", oldValue, _list));
		}

		var oldSelectedIndex:int = _selectedIndex;
		var oldSelectedValue:* = _selectedValue;

		if (!value || value.length === 0) {
			_selectedIndex = 0;
			_selectedValue = null;
		} else {
			var index:int = (value.length > _selectedIndex) ? _selectedIndex : 0;
			_selectedIndex = index;
			_selectedValue = value.getItemAt(index);
		}

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedIndex", oldSelectedIndex, _selectedIndex));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedValue", oldSelectedValue, _selectedValue));
		}

		if (changeHandler !== null) changeHandler();
	}

	//---------------------------------------------
	// selectedIndex
	//---------------------------------------------
	private var _selectedIndex:int;

	/** selectedIndex */
	[Bindable]
	public function get selectedIndex():int {
		return _selectedIndex;
	}

	public function set selectedIndex(value:int):void {
		var oldValue:int = _selectedIndex;
		_selectedIndex = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedIndex", oldValue, _selectedIndex));
		}

		set_selectedValue(_list.getItemAt(value));

		if (changeHandler !== null) changeHandler();
	}

	//---------------------------------------------
	// selectedValue
	//---------------------------------------------
	private var _selectedValue:*;

	/** selectedValue */
	[Bindable(event="propertyChange")]
	public function get selectedValue():* {
		return _selectedValue;
	}

	private function set_selectedValue(value:*):void {
		var oldValue:* = _selectedValue;
		_selectedValue = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedValue", oldValue, _selectedValue));
		}
	}

	private var changeHandler:Function;

	public function SelectionDataBinder(list:* = null, selectedIndex:int = 0, changeHandler:Function = null) {
		_list = (list is IList) ? list : (list is Array) ? new ArrayList(list) : null;
		_selectedIndex = selectedIndex;
		if (_list && _list.length > 0) _selectedValue = _list.getItemAt(_selectedIndex);

		this.changeHandler = changeHandler;
	}
}
}
