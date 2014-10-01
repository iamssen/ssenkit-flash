package ssen.components.sparkDatagridSupportClasses.columns {

import flashx.textLayout.formats.TextAlign;

import mx.core.ClassFactory;

import spark.formatters.NumberFormatter;

import ssen.components.sparkDatagridSupportClasses.editors.NumberGridEditor;

public class NumberGridColumn extends BasicGridColumn {
	private static var numberFormatter:NumberFormatter;

	private static function getNumberFormatter():NumberFormatter {
		if (!numberFormatter) {
			numberFormatter = new NumberFormatter;
			numberFormatter.fractionalDigits = 0;
		}

		return numberFormatter;
	}

	public var minimumField:String;
	public var maximumField:String;
	public var useDecimalPoint:Boolean = false;

	public function NumberGridColumn(columnName:String = null) {
		super(columnName);
		textAlign = TextAlign.RIGHT;
		itemEditor = new ClassFactory(NumberGridEditor);
		formatter = getNumberFormatter();
	}
}
}
