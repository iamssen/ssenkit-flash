package ssen.text {

import flash.text.engine.FontLookup;

import flashx.textLayout.compose.ISWFContext;

import mx.core.EmbeddedFont;
import mx.core.IEmbeddedFontRegistry;
import mx.core.Singleton;
import mx.core.UIComponent;
import mx.core.mx_internal;

import ssen.common.StringUtils;

use namespace mx_internal;

/**
 * FTE, TLF에서 Embed Font를 사용할 때 필요한 도구들 입니다.
 *
 * Flex Application에 로딩된 Embed Font의 List를 가져오거나, 분리된 Context에 존재하는 Embed Font를 렌더링하는데 필수적인 `ISWFContext`를 가져옵니다.
 *
 * @see flashx.textLayout.factory.TextLineFactoryBase#swfContext
 * @see flashx.textLayout.compose.ISWFContext
 */
public class EmbededFontUtils {

	private static var fontInfos:Object;
	private static var fontNames:Vector.<String>;

	//==========================================================================================
	// read flex embeded font registry
	//==========================================================================================
	private static function readFonts():void {
		var infos:Object = {};
		var names:Vector.<String> = new Vector.<String>;

		var fontRegistry:IEmbeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
		var fonts:Array = fontRegistry.getFonts();
		var font:EmbeddedFont;
		var info:Info;

		var f:int = -1;
		var fmax:int = fonts.length;

		while (++f < fmax) {
			font = fonts[f];

			if (infos[font.fontName] !== undefined) {
				info = infos[font.fontName];
			} else {
				info = new Info;
				infos[font.fontName] = info;
			}

			if (font.bold) {
				if (font.italic) {
					info.hasBoldItalicFont = true;
				} else {
					info.hasBoldFont = true;
				}
			} else {
				if (font.italic) {
					info.hasItalicFont = true;
				} else {
					info.hasNormalFont = true;
				}
			}

			names.push(font.fontName);
		}

		fontInfos = infos;
		fontNames = names;
	}

	//==========================================================================================
	// api
	//==========================================================================================
	public static function getEmbededFontNames():Vector.<String> {
		if (!fontInfos) readFonts();
		return fontNames.slice();
	}

	public static function getFontLookup(font:String, isBold:Boolean = false, isItalic:Boolean = false):String {
		if (!fontInfos) readFonts();

		if (!fontInfos[font]) return FontLookup.DEVICE;

		var info:Info = fontInfos[font];

		if (isBold) {
			if (isItalic) {
				return info.hasBoldItalicFont ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
			} else {
				return info.hasBoldFont ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
			}
		} else {
			if (isItalic) {
				return info.hasItalicFont ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
			} else {
				return info.hasNormalFont ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
			}
		}
	}

	public static function getSwfContext(component:UIComponent, fontFamily:String, isBold:Boolean = false, isItalic:Boolean = false):ISWFContext {
		if (!fontInfos) readFonts();

		var fontName:String;

		if (fontFamily.indexOf(",") > -1) {
			var arr:Array = fontFamily.split(",");
			if (arr.length > 0) {
				fontName = StringUtils.clearBlank(arr[0]);
			}
		} else {
			fontName = fontFamily;
		}

		var info:Info = fontInfos[fontName];
		return (info) ? component.getFontContext(fontName, isBold, isItalic) as ISWFContext : null;
	}
}
}

class Info {
	public var hasNormalFont:Boolean;
	public var hasBoldFont:Boolean;
	public var hasItalicFont:Boolean;
	public var hasBoldItalicFont:Boolean;
}
