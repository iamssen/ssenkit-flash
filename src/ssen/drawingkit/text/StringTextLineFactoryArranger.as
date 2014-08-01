package ssen.drawingkit.text {
import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.VerticalAlign;

import ssen.common.MathUtils;
import ssen.drawingkit.getScalingMinimizeRatio;
import ssen.drawingkit.display.unionDisplayObjectBounds;

/** StringTextLineFactory 의 createTextLine 을 랩핑해서, 특정 공간치를 넘어갈 경우 TextLine 을 공간에 맞게 Resize 해준다 */
public class StringTextLineFactoryArranger {
	/** StringTextLineFactory */
	public var factory:StringTextLineFactory;

	private var lines:Vector.<TextLine>;

	/** TextLine 을 만든다 */
	public function createTextLines(callback:Function, forcePadding:Boolean=true):void {
		if (!factory) {
			throw new Error("factory is null");
		}


		lines=new Vector.<TextLine>;

		// factory 의 composition bounds 를 읽는다
		var orCompositionBounds:Rectangle=factory.compositionBounds;
		var compositionBounds:Rectangle=factory.compositionBounds.clone();

		// padding 적용을 원할 경우 padding 들을 composition bounds 에 적용한다
		if (forcePadding) {
			var paddingLeft:int=MathUtils.nanTo(factory.textFlowFormat.paddingLeft);
			var paddingRight:int=MathUtils.nanTo(factory.textFlowFormat.paddingRight);
			var paddingTop:int=MathUtils.nanTo(factory.textFlowFormat.paddingTop);
			var paddingBottom:int=MathUtils.nanTo(factory.textFlowFormat.paddingBottom);

			compositionBounds.x+=paddingLeft;
			compositionBounds.y+=paddingTop;
			compositionBounds.width-=paddingLeft + paddingRight;
			compositionBounds.height-=paddingLeft + paddingBottom;
		}

		var DUMMY_WIDTH:int=3000;
		var DUMMY_HEIGHT:int=3000;

		var textAlign:String=factory.textFlowFormat.textAlign;
		var verticalAlign:String=factory.textFlowFormat.verticalAlign;

		// factory 에 가상의 큰 커다란 compositon bounds 를 적용시켜서 text 를 만들고,
		factory.compositionBounds=new Rectangle(0, 0, DUMMY_WIDTH, DUMMY_HEIGHT);
		factory.createTextLines(createdTextLines);
		// factory 의 원래 composition bounds 를 복구 시켜준다 
		factory.compositionBounds=orCompositionBounds;

		var f:int, fmax:int;
		var line:TextLine;

		var displays:Vector.<DisplayObject>=new Vector.<DisplayObject>(lines.length, true);

		f=-1;
		fmax=lines.length;

		while (++f < fmax) {
			displays[f]=lines[f];
		}

		var linesBounds:Rectangle=unionDisplayObjectBounds(displays);
		var ratio:Number=getScalingMinimizeRatio(linesBounds, compositionBounds);

		// 리사이즈 필요성에 의한 분기
		if (ratio < 1) {
			var fixedBounds:Rectangle=new Rectangle(linesBounds.x, linesBounds.y, linesBounds.width * ratio, linesBounds.height * ratio);

			switch (textAlign) {
				case TextAlign.CENTER:
					fixedBounds.x=(compositionBounds.width / 2) - (fixedBounds.width / 2) + compositionBounds.x;
					break;
				case TextAlign.RIGHT:
					fixedBounds.x=compositionBounds.width - fixedBounds.width + compositionBounds.x;
					break;
				default:
					fixedBounds.x=compositionBounds.x;
					break;
			}

			switch (verticalAlign) {
				case VerticalAlign.MIDDLE:
					fixedBounds.y=(compositionBounds.height / 2) - (fixedBounds.height / 2) + compositionBounds.y;
					break;
				case VerticalAlign.BOTTOM:
					fixedBounds.y=compositionBounds.height - fixedBounds.height + compositionBounds.y;
					break;
				default:
					fixedBounds.y=compositionBounds.y;
					break;
			}

			f=-1;
			fmax=lines.length;

			while (++f < fmax) {
				line=lines[f];
				line.width=line.width * ratio;
				line.height=line.height * ratio;
				line.x=fixedBounds.x + ((line.x - linesBounds.x) * ratio);
				line.y=fixedBounds.y + ((line.y - linesBounds.y) * ratio) + (line.ascent * line.scaleY);
			}

			f=-1;
			fmax=lines.length;
			while (++f < fmax) {
				callback(lines[f]);
			}
		} else {
			f=lines.length;
			while (--f >= 0) {
				line=lines[f];
				TextLineRecycler.addLineForReuse(line);
				line=null;
			}
			lines=null;

			factory.createTextLines(callback);
		}

		lines=null;
	}

	private function createdTextLines(line:TextLine):void {
		lines.push(line);
	}
}
}
