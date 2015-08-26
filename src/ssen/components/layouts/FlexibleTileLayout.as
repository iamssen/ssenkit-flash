package ssen.components.layouts {
import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.supportClasses.LayoutBase;

public class FlexibleTileLayout extends LayoutBase {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// horizontalGap
	//---------------------------------------------
	private var _horizontalGap:int = 10;

	/** horizontalGap */
	public function get horizontalGap():int {
		return _horizontalGap;
	}

	public function set horizontalGap(value:int):void {
		_horizontalGap = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// verticalGap
	//---------------------------------------------
	private var _verticalGap:int = 10;

	/** verticalGap */
	public function get verticalGap():int {
		return _verticalGap;
	}

	public function set verticalGap(value:int):void {
		_verticalGap = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingLeft
	//---------------------------------------------
	private var _paddingLeft:int = 0;

	/** paddingLeft */
	public function get paddingLeft():int {
		return _paddingLeft;
	}

	public function set paddingLeft(value:int):void {
		_paddingLeft = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingRight
	//---------------------------------------------
	private var _paddingRight:int = 0;

	/** paddingRight */
	public function get paddingRight():int {
		return _paddingRight;
	}

	public function set paddingRight(value:int):void {
		_paddingRight = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingTop
	//---------------------------------------------
	private var _paddingTop:int = 0;

	/** paddingTop */
	public function get paddingTop():int {
		return _paddingTop;
	}

	public function set paddingTop(value:int):void {
		_paddingTop = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingBottom
	//---------------------------------------------
	private var _paddingBottom:int = 0;

	/** paddingBottom */
	public function get paddingBottom():int {
		return _paddingBottom;
	}

	public function set paddingBottom(value:int):void {
		_paddingBottom = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// orientation
	//---------------------------------------------
	private var _orientation:String = "rows";

	/** orientation */
	public function get orientation():String {
		return _orientation;
	}

	[Inspectable(category="General", enumeration="rows,columns", defaultValue="rows")]
	public function set orientation(value:String):void {
		if (value !== "rows" && value !== "columns") value = "rows";
		_orientation = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// maxColumnCount
	//---------------------------------------------
	private var _maxColumnCount:int = -1;

	/** maxColumnCount */
	public function get maxColumnCount():int {
		return _maxColumnCount;
	}

	public function set maxColumnCount(value:int):void {
		_maxColumnCount = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// maxRowCount
	//---------------------------------------------
	private var _maxRowCount:int = -1;

	/** maxRowCount */
	public function get maxRowCount():int {
		return _maxRowCount;
	}

	public function set maxRowCount(value:int):void {
		_maxRowCount = value;
		if (target) target.invalidateDisplayList();
	}

	//==========================================================================================
	// navigation control
	//==========================================================================================
	private var _currentColumnCount:int;

	override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int {
		if (!target || target.numElements < 1) {
			return -1;
		}

		var maxIndex:int = target.numElements - 1;
		var nextIndex:int;

		switch (navigationUnit) {
			case NavigationUnit.HOME:
				return 0;

			case NavigationUnit.END:
				return target.numElements - 1;

			case NavigationUnit.UP:
				nextIndex = getPrevIncludedElementIndex(currentIndex, _currentColumnCount);
				return (nextIndex > 0) ? nextIndex : currentIndex;

			case NavigationUnit.LEFT:
				return (currentIndex === 0) ? maxIndex : currentIndex - 1;

			case NavigationUnit.DOWN:
				nextIndex = getNextIncludedElementIndex(currentIndex, _currentColumnCount);
				return (nextIndex < target.numElements) ? nextIndex : currentIndex;

			case NavigationUnit.RIGHT:
				return (currentIndex === maxIndex) ? 0 : currentIndex + 1;

			default:
				return -1;
		}
	}

	private function getPrevIncludedElementIndex(index:int, decrease:int):int {
		var target:GroupBase = this.target;
		while (--index >= 0 && decrease > 0) {
			if (target.getElementAt(index).includeInLayout) decrease--;
		}
		return index;
	}

	private function getNextIncludedElementIndex(index:int, increase:int):int {
		var target:GroupBase = this.target;
		var numElements:int = target.numElements;
		while (++index < numElements && increase > 0) {
			if (target.getElementAt(index).includeInLayout) increase--;
		}
		return index;
	}


	//==========================================================================================
	// update
	//==========================================================================================
	override public function updateDisplayList(width:Number, height:Number):void {
		var target:GroupBase = this.target;
		if (!target) return;
		if (target.numElements === 0 || width === 0 || height === 0) {
			target.setContentSize(Math.ceil(_paddingLeft + _paddingRight), Math.ceil(_paddingTop + _paddingBottom));
			return;
		}

		var f:int;
		var element:ILayoutElement;

		var numElements:int = target.numElements;
		var rows:int;
		var columns:int;

		// count columns and rows
		f = numElements;
		while (--f >= 0) {
			element = target.getElementAt(f);
			if (element === null || !element.includeInLayout) numElements--;
		}

		columns = Math.ceil(Math.sqrt(numElements));
		rows = Math.round(Math.sqrt(numElements));

		if (_maxColumnCount > 0 && columns > _maxColumnCount) {
			columns = _maxColumnCount;
			rows = Math.ceil(numElements / columns);
		} else if (_maxRowCount > 0 && rows > _maxRowCount) {
			rows = _maxRowCount;
			columns = Math.ceil(numElements / rows);
		}

		// apply layout to elements
		var breakCount:int;
		var itemWidth:int = (width - _paddingLeft - _paddingRight - (_horizontalGap * (columns - 1))) / columns;
		var itemHeight:int = (height - _paddingTop - _paddingBottom - (_verticalGap * (rows - 1))) / rows;
		var nx:int = _paddingLeft;
		var ny:int = _paddingTop;

		f = -1;
		breakCount = 0;
		numElements = target.numElements;

		while (++f < numElements) {
			// set layout size and position to element
			element = target.getElementAt(f);
			element.setLayoutBoundsPosition(nx, ny);
			element.setLayoutBoundsSize(itemWidth, itemHeight);

			// increase or break position for next element
			breakCount++;

			if (_orientation === "rows") {
				// 1 2 3
				// 4 5 6
				// 7 8 9
				if (breakCount >= columns) {
					nx = _paddingLeft;
					ny += itemHeight + _verticalGap;
					breakCount = 0;
				} else {
					nx += itemWidth + _horizontalGap;
				}
			} else {
				// 1 4 7
				// 2 5 8
				// 3 6 9
				if (breakCount >= rows) {
					nx += itemWidth + _horizontalGap;
					ny = _paddingTop;
					breakCount = 0;
				} else {
					ny += itemHeight + _verticalGap;
				}
			}
		}

		_currentColumnCount = columns;
		target.setContentSize(width - _paddingLeft - _paddingRight, height - _paddingTop - _paddingBottom);
	}
}
}
