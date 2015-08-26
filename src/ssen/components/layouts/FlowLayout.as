package ssen.components.layouts {
import flash.geom.Rectangle;

import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.supportClasses.LayoutBase;

public class FlowLayout extends LayoutBase {
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
	// itemVerticalAlign
	//---------------------------------------------
	private var _itemVerticalAlign:String = "top";

	/** itemVerticalAlign */
	public function get itemVerticalAlign():String {
		return _itemVerticalAlign;
	}

	[Inspectable(defaultValue="top", enumeration="top,middle,bottom")]
	public function set itemVerticalAlign(value:String):void {
		_itemVerticalAlign = value;
		if (target) target.invalidateDisplayList();
	}

	//---------------------------------------------
	// horizontalAlign
	//---------------------------------------------
	private var _horizontalAlign:String = "left";

	/** horizontalAlign */
	public function get horizontalAlign():String {
		return _horizontalAlign;
	}

	[Inspectable(defaultValue="left", enumeration="left,center,right")]
	public function set horizontalAlign(value:String):void {
		_horizontalAlign = value;
		if (target) target.invalidateDisplayList();
	}

	//==========================================================================================
	// navigation control
	//==========================================================================================
	override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int {
		if (!target || target.numElements < 1) {
			return -1;
		}

		var maxIndex:int = target.numElements - 1;

		switch (navigationUnit) {
			case NavigationUnit.HOME:
				return 0;

			case NavigationUnit.END:
				return target.numElements - 1;

			case NavigationUnit.UP:
			case NavigationUnit.LEFT:
				return (currentIndex === 0) ? maxIndex : currentIndex - 1;

			case NavigationUnit.DOWN:
			case NavigationUnit.RIGHT:
				return (currentIndex === maxIndex) ? 0 : currentIndex + 1;

			default:
				return -1;
		}
	}

	//==========================================================================================
	// update
	//==========================================================================================
	override public function measure():void {
		var target:GroupBase = this.target;

		if (target.contentHeight !== target.measuredHeight) {
			target.measuredHeight = target.contentHeight;
		}
	}

	override public function updateDisplayList(width:Number, height:Number):void {
		var target:GroupBase = this.target;
		if (!target) return;
		if (target.numElements === 0 || width === 0) {
			target.setContentSize(Math.ceil(_paddingLeft + _paddingRight), Math.ceil(_paddingTop + _paddingBottom));
			return;
		}

		var element:ILayoutElement;
		var lineElement:ILayoutElement;
		var nextElement:ILayoutElement;
		var lineElements:Vector.<ILayoutElement> = new Vector.<ILayoutElement>;

		var elementWidth:int, elementHeight:int, elementX:int, elementY:int;

		var bound:Rectangle;
		var lineBound:Rectangle;

		bound = new Rectangle;
		bound.x = _paddingLeft;
		bound.y = _paddingTop;
		bound.width = width - _paddingLeft - _paddingRight;
		bound.height = _paddingTop + _paddingBottom;

		lineBound = new Rectangle;
		lineBound.width = 0;
		lineBound.height = 0;
		lineBound.x = 0;
		lineBound.y = bound.y;

		var f:int = -1;
		var fmax:int = target.numElements;
		var s:int;
		var smax:int;

		while (++f < fmax) {
			element = target.getElementAt(f);
			nextElement = (f + 1 < target.numElements) ? target.getElementAt(f + 1) : null;

			// pass excluded element
			if (element === null || !element.includeInLayout) continue;
			lineElements.push(element);

			// clear layout bound to element
			if (nextElement) nextElement.setLayoutBoundsSize(NaN, NaN);
			elementWidth = element.getLayoutBoundsWidth();
			elementHeight = element.getLayoutBoundsHeight();

			// increase line bound width
			lineBound.width += elementWidth;

			// increase line bound height
			if (elementHeight > lineBound.height) lineBound.height = elementHeight;

			//			trace("FlowLayout.updateDisplayList()", f, lineBound, bound);

			//---------------------------------------------
			// line break
			//---------------------------------------------
			if (!nextElement || lineBound.width + nextElement.getLayoutBoundsWidth() + _horizontalGap > bound.width) {
				// horizontal align
				switch (_horizontalAlign) {
					case "center":
						lineBound.x = int(bound.x + ((bound.width - lineBound.width) / 2));
						break;
					case "right":
						lineBound.x = bound.x + bound.width - lineBound.width;
						break;
					default:
						lineBound.x = bound.x;
						break;
				}

				// apply position to line elements
				elementX = lineBound.x;

				s = -1;
				smax = lineElements.length;

				while (++s < smax) {
					lineElement = lineElements[s];

					// vertical align in line
					switch (_itemVerticalAlign) {
						case "middle":
							elementY = int(lineBound.y + ((lineBound.height - lineElement.getLayoutBoundsHeight()) / 2));
							break;
						case "bottom":
							elementY = lineBound.y + lineBound.height - lineElement.getLayoutBoundsHeight();
							break;
						default:
							elementY = lineBound.y;
							break;
					}

					lineElement.setLayoutBoundsPosition(elementX, elementY);

					elementX += lineElement.getLayoutBoundsWidth() + _horizontalGap;
				}

				// increase bound height
				bound.height += lineBound.height + _verticalGap;

				// initial line bound
				lineBound.x = 0;
				lineBound.y += lineBound.height + _verticalGap;
				lineBound.width = 0;
				lineBound.height = 0;

				lineElements.length = 0;
			} else {
				// increase horizontal gap to line bound
				lineBound.width += _horizontalGap;
			}
		}

		bound.height -= _verticalGap;

		target.setContentSize(width, bound.height);
		if (height !== bound.height) target.invalidateSize();
	}
}
}
