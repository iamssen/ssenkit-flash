package ssen.components.layouts {
import flash.geom.Rectangle;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class ArrayedHierarchyFlowLayout extends LayoutBase {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// itemHeights
	//---------------------------------------------
	private var _itemHeights:Vector.<int> = new <int>[30, 20, 10];

	/** itemHeights */
	public function get itemHeights():Vector.<int> {
		return _itemHeights;
	}

	public function set itemHeights(value:Vector.<int>):void {
		_itemHeights = value;
		// TODO
	}

	//---------------------------------------------
	// horizontalGaps
	//---------------------------------------------
	private var _horizontalGaps:Vector.<int> = new <int>[10, 0];

	/** horizontalGaps */
	public function get horizontalGaps():Vector.<int> {
		return _horizontalGaps;
	}

	public function set horizontalGaps(value:Vector.<int>):void {
		_horizontalGaps = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// verticalGaps
	//---------------------------------------------
	private var _verticalGaps:Vector.<int> = new <int>[5, 2, 2];

	/** verticalGaps */
	public function get verticalGaps():Vector.<int> {
		return _verticalGaps;
	}

	public function set verticalGaps(value:Vector.<int>):void {
		_verticalGaps = value;
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

	//==========================================================================================
	// update
	//==========================================================================================
	override public function updateDisplayList(width:Number, height:Number):void {
		var target:GroupBase = this.target;
		if (!target) return;
		if (target.numElements === 0 || width === 0 || (height === 0 && target.explicitMaxHeight === 0)) {
			target.setContentSize(Math.ceil(_paddingLeft + _paddingRight), Math.ceil(_paddingTop + _paddingBottom));
			return;
		}

		if (height === 0) height = target.explicitMaxHeight;

		var bound:Rectangle = new Rectangle(_paddingLeft, _paddingTop, width - _paddingLeft - _paddingRight, height - _paddingTop - _paddingBottom);

		var f:int;
		var fmax:int;
		var element:IArrayedHierarchyVisualElement;

		var ny:int = bound.top;

		var numElements:int = target.numElements;

		var topLevelColumns:Vector.<int> = new <int>[];
		var columnGapWidth:int = 0;

		f = -1;
		fmax = numElements;
		while (++f < fmax) {
			element = target.getElementAt(f) as IArrayedHierarchyVisualElement;

			if (f > 0) {
				if (element.treeDepth === 0) {
					columnGapWidth += _horizontalGaps[0];
					ny = 0;
				} else if (element.treeDepth === 1) {
					if (ny + getGroupHeight(target, f) > bound.height) {
						columnGapWidth += _horizontalGaps[1];
						ny = _itemHeights[0] + _verticalGaps[0];
					} else if (ny > _itemHeights[0]) {
						ny += _verticalGaps[1];
					}
				}
			}

			element.height = _itemHeights[element.treeDepth];
			element.setLayoutBoundsPosition(NaN, ny);

			ny += _itemHeights[element.treeDepth];
			if (ny > bound.height) {
				ny = _itemHeights[0];
			}
		}
	}

	// get total height under 1 level item heights
	private function getGroupHeight(target:GroupBase, startIndex:int):Number {
		var element:IArrayedHierarchyVisualElement;
		var h:Number = _itemHeights[1] + _verticalGaps[1];

		var f:int = startIndex;
		var fmax:int = target.numElements;
		while (++f < fmax) {
			element = target.getElementAt(f) as IArrayedHierarchyVisualElement;

			h += _itemHeights[element.treeDepth] + _verticalGaps[element.treeDepth];

			if (element.treeDepth < 2) {
				h -= _verticalGaps[element.treeDepth];
				break;
			}
		}

		return h;
	}
}
}


//