package ssen.layouts {
import flash.geom.Rectangle;

import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.events.PropertyChangeEvent;

import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.supportClasses.LayoutBase;

public class FlowLayout extends LayoutBase {
	//=========================================================
	// properties
	//=========================================================
	//---------------------------------------------
	// horizontalGap
	//---------------------------------------------
	private var _horizontalGap:int = 10;

	/** horizontalGap */
	[Bindable]
	public function get horizontalGap():int {
		return _horizontalGap;
	}

	public function set horizontalGap(value:int):void {
		var oldValue:int = _horizontalGap;
		_horizontalGap = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalGap", oldValue, _horizontalGap));
		}
	}

	//---------------------------------------------
	// verticalGap
	//---------------------------------------------
	private var _verticalGap:int = 10;

	/** verticalGap */
	[Bindable]
	public function get verticalGap():int {
		return _verticalGap;
	}

	public function set verticalGap(value:int):void {
		var oldValue:int = _verticalGap;
		_verticalGap = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalGap", oldValue, _verticalGap));
		}
	}

	//---------------------------------------------
	// itemVerticalAlign
	//---------------------------------------------
	private var _itemVerticalAlign:String = "top";

	/** itemVerticalAlign */
	[Bindable]
	public function get itemVerticalAlign():String {
		return _itemVerticalAlign;
	}

	[Inspectable(defaultValue="top", enumeration="top,middle,bottom")]
	public function set itemVerticalAlign(value:String):void {
		var oldValue:String = _itemVerticalAlign;
		_itemVerticalAlign = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "itemVerticalAlign", oldValue, _itemVerticalAlign));
		}
	}

	//---------------------------------------------
	// horizontalAlign
	//---------------------------------------------
	private var _horizontalAlign:String = "left";

	/** horizontalAlign */
	[Bindable]
	public function get horizontalAlign():String {
		return _horizontalAlign;
	}

	[Inspectable(defaultValue="left", enumeration="left,center,right")]
	public function set horizontalAlign(value:String):void {
		var oldValue:String = _horizontalAlign;
		_horizontalAlign = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalAlign", oldValue, _horizontalAlign));
		}
	}

	//---------------------------------------------
	// paddingLeft
	//---------------------------------------------
	private var _paddingLeft:int;

	/** paddingLeft */
	[Bindable]
	public function get paddingLeft():int {
		return _paddingLeft;
	}

	public function set paddingLeft(value:int):void {
		var oldValue:int = _paddingLeft;
		_paddingLeft = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingLeft", oldValue, _paddingLeft));
		}
	}

	//---------------------------------------------
	// paddingRight
	//---------------------------------------------
	private var _paddingRight:int;

	/** paddingRight */
	[Bindable]
	public function get paddingRight():int {
		return _paddingRight;
	}

	public function set paddingRight(value:int):void {
		var oldValue:int = _paddingRight;
		_paddingRight = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingRight", oldValue, _paddingRight));
		}
	}

	//---------------------------------------------
	// paddingTop
	//---------------------------------------------
	private var _paddingTop:int;

	/** paddingTop */
	[Bindable]
	public function get paddingTop():int {
		return _paddingTop;
	}

	public function set paddingTop(value:int):void {
		var oldValue:int = _paddingTop;
		_paddingTop = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingTop", oldValue, _paddingTop));
		}
	}

	//---------------------------------------------
	// paddingBottom
	//---------------------------------------------
	private var _paddingBottom:int;

	/** paddingBottom */
	[Bindable]
	public function get paddingBottom():int {
		return _paddingBottom;
	}

	public function set paddingBottom(value:int):void {
		var oldValue:int = _paddingBottom;
		_paddingBottom = value;
		invalidateLayout();
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingBottom", oldValue, _paddingBottom));
		}
	}

	//=========================================================
	// item index control
	//=========================================================
	override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int {
		if (!target || target.numElements < 1)
			return -1;

		var maxIndex:int = target.numElements - 1;

		switch (navigationUnit) {
			case NavigationUnit.HOME:
				return 0;

			case NavigationUnit.END:
				return target.numElements - 1;

			case NavigationUnit.UP:
			case NavigationUnit.LEFT:
				if (currentIndex == 0)
					return maxIndex; else
					return currentIndex - 1;
				break;

			case NavigationUnit.DOWN:
			case NavigationUnit.RIGHT:
				if (currentIndex == maxIndex)
					return 0; else
					return currentIndex + 1;
				break;

			default:
				return -1;
		}
	}

	//=========================================================
	// align
	//=========================================================
	private var changed:Boolean;
	private var oldContainerWidth:Number;
	private var oldContainerHeight:Number;
	private var contentWidth:int;
	private var contentHeight:int;

	private function invalidateLayout():void {
		if (target) {
			changed = true;
			target.invalidateDisplayList();
		}
	}

	override public function measure():void {
		var t:GroupBase = target;
		t.measuredWidth = contentWidth;
		t.measuredHeight = contentHeight;
	}

	override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void {
		if (oldContainerWidth !== containerWidth || oldContainerHeight !== containerHeight) {
			oldContainerWidth = containerWidth;
			oldContainerHeight = containerHeight;
			changed = true;
		}

		if (!changed) {
			return;
		}

		var t:GroupBase = target;
		var el:ILayoutElement, e:ILayoutElement;
		var w:int, h:int, x:int, y:int;
		var els:Vector.<ILayoutElement> = new Vector.<ILayoutElement>;

		var f:int = -1;
		var fmax:int = t.numElements;
		var s:int;
		var smax:int;

		//			var nx:int = 0;
		var nel:IVisualElement;

		//			var lineStart:int = 0;
		//			var lineEnd:int = 0;

		var container:Rectangle;
		var line:Rectangle;

		//			var maxX:int, maxY:int;

		container = new Rectangle;
		line = new Rectangle;

		container.width = containerWidth - _paddingLeft - _paddingRight;
		container.height = 0;
		container.x = _paddingLeft;
		container.y = _paddingTop;
		line.width = 0;
		line.height = 0;
		line.x = 0;
		line.y = container.y;

		while (++f < fmax) {
			if (useVirtualLayout) {
				el = t.getVirtualElementAt(f);
				nel = (f + 1 < t.numElements) ? t.getVirtualElementAt(f + 1) : null;
			} else {
				el = t.getElementAt(f);
				nel = (f + 1 < t.numElements) ? t.getElementAt(f + 1) : null;
			}

			if (el === null || !el.includeInLayout) {
				continue;
			}

			el.setLayoutBoundsSize(NaN, NaN);

			w = el.getLayoutBoundsWidth();
			h = el.getLayoutBoundsHeight();

			// 열 바꾸기 이전
			line.width += w;
			if (h > container.height) {
				container.height = h;
				line.height = h;
			}
			els.push(el);

			if (nel === null || line.width + nel.width + _horizontalGap > container.width) {
				// 정렬에 따른 line 의 x 설정
				switch (_horizontalAlign) {
					case "center":
						line.x = int(container.x + (container.width / 2) - (line.width / 2));
						break;
					case "right":
						line.x = container.x + container.width - line.width;
						break;
					default:
						line.x = container.x;
						break;
				}

				//					trace("FlowLayout.updateDisplayList line", container, line);

				// 정렬
				s = -1;
				smax = els.length;
				x = line.x;

				while (++s < smax) {
					e = els[s];

					switch (_itemVerticalAlign) {
						case "middle":
							y = int(container.y + (container.height / 2) - (e.getLayoutBoundsHeight() / 2));
							break;
						case "bottom":
							y = container.y + container.height - e.getLayoutBoundsHeight();
							break;
						default:
							y = container.y;
							break;
					}

					//						trace("FlowLayout.updateDisplayList item", x, y);
					e.setLayoutBoundsPosition(x, y);

					x += e.getLayoutBoundsWidth() + _horizontalGap;
				}

				// line 증가 및 초기화
				container.y += _verticalGap + container.height;
				container.height = 0;
				line.width = 0;
				line.height = 0;
				line.x = 0;
				line.y = container.y;
				els.length = 0;
			} else {
				line.width += _horizontalGap;
			}
		}

		contentWidth = container.x + container.width + _paddingRight;
		contentHeight = container.y + container.height + _paddingBottom;
		t.setContentSize(contentWidth, contentHeight);
		t.measuredWidth = contentWidth;
		t.measuredHeight = contentHeight;

		changed = false;

		//			trace("FlowLayout.updateDisplayList content", contentWidth, contentHeight, t.measuredWidth,
		//				  t.measuredHeight);
	}
}
}
