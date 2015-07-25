package ssen.components.grid.contents {

import flash.display.Graphics;
import flash.geom.Rectangle;

import spark.components.Group;

import ssen.components.grid.GridElement;
import ssen.components.grid.GridUtils;
import ssen.components.grid.headers.HeaderLayoutMode;
import ssen.components.grid.headers.IHeader;

public class Showcase__GridContents extends GridElement implements IGridContent {
	//---------------------------------------------
	// header
	//---------------------------------------------
	private var _header:IHeader;

	/** header */
	public function get header():IHeader {
		return _header;
	}

	public function set header(value:IHeader):void {
		_header = value;
		invalidateDisplayList();
	}

	//==========================================================================================
	// invalidation
	//==========================================================================================
	public function invalidateColumnLayout():void {
		invalidate_columnLayout();
	}

	public function invalidateScroll():void {
		invalidate_scroll();
	}

	//---------------------------------------------
	// inavalidate columnLayout
	//---------------------------------------------
	private var columnLayoutChanged:Boolean = true;

	final protected function invalidate_columnLayout():void {
		columnLayoutChanged = true;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// inavalidate scroll
	//---------------------------------------------
	private var scrollChanged:Boolean = true;

	final protected function invalidate_scroll():void {
		scrollChanged = true;
		invalidateDisplayList();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!_header || !unlockedContainer) {
			return;
		}

		if (columnLayoutChanged) {
			commit_columnLayout();
			columnLayoutChanged = false;
		}

		if (scrollChanged) {
			commit_scroll();
			scrollChanged = false;
		}

		unlockedContainer.x = _header.computedFrontLockedBlockWidth + _header.columnSeparatorSize;
		unlockedContainer.width = _header.computedUnlockedBlockWidth;
		unlockedContainer.height = unscaledHeight;

		if (frontLockedContainer.visible) {
			frontLockedContainer.height = unscaledHeight;
		}

		if (backLockedContainer.visible) {
			backLockedContainer.height = unscaledHeight;
		}

		//----------------------------------------------------------------
		// graphics
		//----------------------------------------------------------------
		if (header.columnLayoutMode === HeaderLayoutMode.FIXED) {
			var frontGap:Number = 0;
			var backGap:Number = 0;

			if (header.frontLockedColumnCount > 0) {
				frontLockedContainer.visible = true;
				frontLockedContainer.includeInLayout = true;

				frontGap = header.columnSeparatorSize;
			} else {
				frontLockedContainer.visible = false;
				frontLockedContainer.includeInLayout = false;

				frontGap = 0;
			}

			if (header.backLockedColumnCount > 0) {
				backLockedContainer.visible = true;
				backLockedContainer.includeInLayout = true;

				backGap = header.columnSeparatorSize;
			} else {
				backLockedContainer.visible = false;
				backLockedContainer.includeInLayout = false;

				backGap = 0;
			}

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = header.computedFrontLockedColumnWidthTotal + frontGap;
			unlockedContainer.measuredWidth = unscaledWidth - header.computedFrontLockedColumnWidthTotal - frontGap - header.computedBackLockedColumnWidthTotal - backGap;
			unlockedContainer.measuredHeight = unscaledHeight;

			unlockedContainer.invalidateSize();

			if (header.frontLockedColumnCount > 0) {
				frontLockedContainer.measuredWidth = header.computedFrontLockedColumnWidthTotal;
				frontLockedContainer.measuredHeight = unscaledHeight;

				frontLockedContainer.invalidateSize();
			}

			if (header.backLockedColumnCount > 0) {
				backLockedContainer.x = unlockedContainer.x + unlockedContainer.width + header.columnSeparatorSize;
				backLockedContainer.measuredWidth = header.computedBackLockedColumnWidthTotal;
				backLockedContainer.measuredHeight = unscaledHeight;

				backLockedContainer.invalidateSize();
			}
		} else {
			frontLockedContainer.visible = false;
			frontLockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			backLockedContainer.visible = false;
			backLockedContainer.includeInLayout = false;

			unlockedContainer.x = 0;
			unlockedContainer.measuredWidth = unscaledWidth;
			unlockedContainer.measuredHeight = unscaledHeight;

			unlockedContainer.invalidateSize();
		}

		frontLockedContainer.graphics.clear();
		unlockedContainer.graphics.clear();
		backLockedContainer.graphics.clear();

		var g:Graphics;
		var bound:Rectangle = new Rectangle;
		var block:Group;

		var widthList:Vector.<Number> = header.computedColumnWidthList;
		var positionList:Vector.<Number> = header.computedColumnPositionList;
		var blockId:int;

		var alpha:Number = 1;

		var f:int = -1;
		var fmax:int = widthList.length;
		while (++f < fmax) {
			blockId = GridUtils.getContainerId(header, f);

			bound.x = GridUtils.columnDrawX(positionList, f, blockId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
			bound.y = 0;
			bound.width = widthList[f];
			bound.height = unscaledHeight;

			block = getBlock(blockId);
			g = block.graphics;

//			trace("Showcase__GridContents.updateDisplayList()", f, blockId, bound.x, block.id, block.width);

			g.beginFill(0, alpha);
			g.drawRect(bound.x, bound.y, bound.width, bound.height);
			g.endFill();

			alpha -= 0.1;
		}
	}

	//---------------------------------------------
	// commit columnLayout
	//---------------------------------------------
	protected function commit_columnLayout():void {
		if (!_header) {
			return;
		}
	}

	//---------------------------------------------
	// commit scroll
	//---------------------------------------------
	protected function commit_scroll():void {
		if (!_header || !unlockedContainer) {
			return;
		}

		unlockedContainer.horizontalScrollPosition = _header.horizontalScrollPosition;
	}
}
}
