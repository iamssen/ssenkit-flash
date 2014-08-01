package ssen.flexkit.components.grid.editors {
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import spark.components.gridClasses.GridItemEditor;

import ssen.common.MathUtils;

public class GridEditor extends GridItemEditor {
	//==========================================================================================
	// key moving
	//==========================================================================================
	override protected function keyDownHandler(event:KeyboardEvent):void {
		if (event.ctrlKey && event.altKey && MathUtils.rangeOf(event.keyCode, Keyboard.LEFT, Keyboard.DOWN)) {
			var moved:Boolean;

			// ctrl + alt + 방향키 이동
			if (event.keyCode === Keyboard.LEFT) {
				moved=GridEditorHelper.moveToPrevColumnCell(column, rowIndex);
			} else if (event.keyCode === Keyboard.RIGHT) {
				moved=GridEditorHelper.moveToNextColumnCell(column, rowIndex);
			} else if (event.keyCode === Keyboard.UP) {
				moved=GridEditorHelper.moveToPrevRowCell(column, rowIndex);
			} else if (event.keyCode === Keyboard.DOWN) {
				moved=GridEditorHelper.moveToNextRowCell(column, rowIndex);
			}

			if (moved) {
				event.preventDefault();
				event.stopPropagation();
				event.stopImmediatePropagation();
			}
		}
	}
}
}
