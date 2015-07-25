package ssen.components.grid {

import flash.events.Event;

import mx.core.IVisualElement;
import mx.core.mx_internal;

import spark.components.HScrollBar;
import spark.components.VGroup;

import ssen.components.grid.contents.IGridContent;
import ssen.components.grid.headers.HeaderEvent;
import ssen.components.grid.headers.HeaderLayoutMode;
import ssen.components.grid.headers.IHeader;

use namespace mx_internal;

public class GridContainer extends VGroup {
	private var header:IHeader;
	private var scroll:HScrollBar;
	private var contents:Vector.<IGridContent> = new Vector.<IGridContent>;

	public function GridContainer() {
		gap = 1;
	}

	private function scrollChanged(event:HeaderEvent):void {
		for each (var content:IGridContent in contents) {
			content.invalidateScroll();
		}
	}

	private function renderComplete(event:HeaderEvent):void {

	}

	private function columnChanged(event:HeaderEvent):void {

	}

	private function columnLayoutChanged(event:HeaderEvent):void {
		for each (var content:IGridContent in contents) {
			content.invalidateColumnLayout();
		}

		updateScrollDisplay();
	}

	override mx_internal function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean = true):void {
		super.mx_internal::elementAdded(element, index, notifyListeners);

		element.percentWidth = 100;

		if (element is IHeader) {
			initialHeader(element as IHeader);
		} else if (element is HScrollBar) {
			initialScroll(element as HScrollBar);
		} else if (element is IGridContent) {
			initialContent(element as IGridContent);
		}
	}


	override mx_internal function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean = true):void {
		super.mx_internal::elementRemoved(element, index, notifyListeners);

		if (element === header) {
			clearHeader(header);
		} else if (element === scroll) {
			clearScroll(scroll);
		} else if (contents.indexOf(element) > -1) {
			clearContent(element as IGridContent);
		}
	}

	private function initialHeader(element:IHeader):void {
		if (header) {
			throw new Error("header는 하나만 필요함");
		}

		header = element;
		header.addEventListener(HeaderEvent.COLUMN_LAYOUT_CHANGED, columnLayoutChanged);
		header.addEventListener(HeaderEvent.COLUMN_CHANGED, columnChanged);
		header.addEventListener(HeaderEvent.RENDER_COMPLETE, renderComplete);
		header.addEventListener(HeaderEvent.SCROLL, scrollChanged);
		header.addEventListener(Event.RESIZE, resize);

		if (scroll) {
			scroll.viewport = header;
		}

		if (contents.length > 0) {
			var f:int = -1;
			var fmax:int = contents.length;
			while (++f < fmax) {
				contents[f].header = header;
			}
		}

		updateScrollDisplay();
	}

	private function resize(event:Event):void {
		updateScrollDisplay();
	}

	private function clearHeader(element:IHeader):void {
		element.removeEventListener(HeaderEvent.COLUMN_LAYOUT_CHANGED, columnLayoutChanged);
		element.removeEventListener(HeaderEvent.COLUMN_CHANGED, columnChanged);
		element.removeEventListener(HeaderEvent.RENDER_COMPLETE, renderComplete);
		element.removeEventListener(HeaderEvent.SCROLL, scrollChanged);
		element.removeEventListener(Event.RESIZE, resize);

		header = null;
	}

	private function initialScroll(element:HScrollBar):void {
		if (scroll) {
			throw new Error("scroll은 하나만 필요함");
		}

		scroll = element;

		if (header) {
			scroll.viewport = header;
		}

		updateScrollDisplay();
	}

	private function clearScroll(element:HScrollBar):void {
		element.viewport = null;
		scroll = null;
	}

	private function initialContent(element:IGridContent):void {
		contents.push(element);

		if (header) {
			element.header = header;
		}
	}

	private function clearContent(element:IGridContent):void {
		var index:int = contents.indexOf(element);
		contents.splice(index, 1);
		element.header = null;
	}

	private function updateScrollDisplay():void {
		if (!header || !scroll) {
			return;
		}

		//		var viewport:IViewport = header;
		//		trace("GridContainer.updateScrollDisplay()", viewport.contentWidth < viewport.width, viewport.width);
		if (header.columnLayoutMode === HeaderLayoutMode.RATIO || header.contentWidth < header.width) {
			scroll.includeInLayout = false;
			scroll.visible = false;
		} else {
			scroll.includeInLayout = true;
			scroll.visible = true;

			scroll.left = header.computedFrontLockedBlockWidth;
			scroll.right = header.computedBackLockedBlockWidth;
		}
	}
}
}
