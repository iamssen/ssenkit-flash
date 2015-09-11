package ssen.components.chart.pola {
import mx.core.UIComponent;
import mx.core.mx_internal;

import spark.components.supportClasses.SkinnableComponent;

import ssen.common.DisposableUtils;
import ssen.components.base.setDefaultSkin;
import ssen.ssen_internal;

use namespace mx_internal;

[DefaultProperty("axis")]

[SkinState("noContent")]

[Deprecated(message="Remove when end of project")]

public class PolaChart extends SkinnableComponent {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var backgroundElementsHolder:UIComponent;

	[SkinPart(required="true")]
	public var annotationElementsHolder:UIComponent;

	[SkinPart(required="true")]
	public var seriesHolder:UIComponent;

	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// logical
	//----------------------------------------------------------------
	//---------------------------------------------
	// axis
	//---------------------------------------------
	private var _axis:Vector.<IPolaAxis>;

	/** axis */
	public function get axis():Vector.<IPolaAxis> {
		return _axis;
	}

	public function set axis(value:Vector.<IPolaAxis>):void {
		_axis = value;
		invalidate_axis();
	}

	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	//---------------------------------------------
	// gutterLeft
	//---------------------------------------------
	private var _gutterLeft:int = 30;

	/** gutterLeft */
	public function get gutterLeft():int {
		return _gutterLeft;
	}

	public function set gutterLeft(value:int):void {
		_gutterLeft = value;
		invalidate_render();
	}

	//---------------------------------------------
	// gutterRight
	//---------------------------------------------
	private var _gutterRight:int = 30;

	/** gutterRight */
	public function get gutterRight():int {
		return _gutterRight;
	}

	public function set gutterRight(value:int):void {
		_gutterRight = value;
		invalidate_render();
	}

	//---------------------------------------------
	// gutterTop
	//---------------------------------------------
	private var _gutterTop:int = 20;

	/** gutterTop */
	public function get gutterTop():int {
		return _gutterTop;
	}

	public function set gutterTop(value:int):void {
		_gutterTop = value;
		invalidate_render();
	}

	//---------------------------------------------
	// gutterBottom
	//---------------------------------------------
	private var _gutterBottom:int = 20;

	/** gutterBottom */
	public function get gutterBottom():int {
		return _gutterBottom;
	}

	public function set gutterBottom(value:int):void {
		_gutterBottom = value;
		invalidate_render();
	}

	//----------------------------------------------------------------
	// drawable points
	//----------------------------------------------------------------
	//---------------------------------------------
	// computedCenterX
	//---------------------------------------------
	private var _computedCenterX:Number;

	/** computedCenterX */
	public function get computedCenterX():Number {
		return _computedCenterX;
	}

	//---------------------------------------------
	// computedCenterY
	//---------------------------------------------
	private var _computedCenterY:Number;

	/** computedCenterY */
	public function get computedCenterY():Number {
		return _computedCenterY;
	}

	//---------------------------------------------
	// computedContentRadius
	//---------------------------------------------
	private var _computedContentRadius:Number;

	/** computedContentRadius */
	public function get computedContentRadius():Number {
		return _computedContentRadius;
	}

	//==========================================================================================
	// callbacks for children
	//==========================================================================================
	ssen_internal function render():void {
		invalidate_render();
	}

	//==========================================================================================
	// internal containers
	//==========================================================================================
	public function PolaChart() {
		setDefaultSkin(styleManager, PolaChart, PolaChartSkin);
	}

	override protected function attachSkin():void {
		if (!getStyle("skinClass") && !getStyle("skinFactory")) setStyle("skinClass", PolaChartSkin);
		super.attachSkin();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	//---------------------------------------------
	// inavalidate axis
	//---------------------------------------------
	private var axisChanged:Boolean;

	final protected function invalidate_axis():void {
		axisChanged = true;
		invalidateProperties();
		invalidateSkinState();
	}

	//---------------------------------------------
	// inavalidate render
	//---------------------------------------------
	private var renderChanged:Boolean;

	final protected function invalidate_render():void {
		renderChanged = true;
		invalidateDisplayList();
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	//---------------------------------------------
	// commit axis
	//---------------------------------------------
	protected function commit_axis():void {
		if (!_axis || _axis.length === 0) {
			return;
		}

		var f:int = _axis.length;
		while (--f >= 0) {
			_axis[f].chart = this;
		}

		invalidate_render();
	}

	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (axisChanged) {
			commit_axis();
			axisChanged = false;
		}
	}

	/** @private */
	override public function setActualSize(w:Number, h:Number):void {
		super.setActualSize(w, h);
		invalidate_render();
	}

	/** @private */
	override protected function measure():void {
		super.measure();
		invalidate_render();
	}

	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		DisposableUtils.disposeDisplayContainer(backgroundElementsHolder, true);
		DisposableUtils.disposeDisplayContainer(seriesHolder, true);
		DisposableUtils.disposeDisplayContainer(annotationElementsHolder, true);

		if (!renderChanged || !_axis || _axis.length === 0 || !backgroundElementsHolder || !annotationElementsHolder || !seriesHolder) {
			return;
		}

		var w2:int = (unscaledWidth - _gutterLeft - _gutterRight) / 2;
		var h2:int = (unscaledHeight - _gutterTop - _gutterBottom) / 2;
		var cx:int = w2 + _gutterLeft;
		var cy:int = h2 + _gutterTop;
		var r:int = (w2 < h2) ? w2 : h2;

		if (_computedCenterX !== cx || _computedCenterY !== cy || _computedContentRadius !== r) {
			_computedCenterX = cx;
			_computedCenterY = cy;
			_computedContentRadius = r;
		}

		var f:int;
		var fmax:int;

		f = -1;
		fmax = _axis.length;
		while (++f < fmax) {
			_axis[f].render();
		}

		//		var g:Graphics = backgroundElementsHolder.graphics;
		//		g.clear();
		//		g.beginFill(0x000000, 0.05);
		//		g.drawCircle(_computedCenterX, _computedCenterY, _computedContentRadius);
		//		g.endFill();

		renderChanged = false;
	}


	//==========================================================================================
	// skin
	//==========================================================================================
	/** @private */
	override protected function getCurrentSkinState():String {
		if (!_axis || _axis.length === 0) {
			return "noContent";
		}

		return enabled ? "normal" : "disabled";
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === seriesHolder || instance === annotationElementsHolder || instance === backgroundElementsHolder) {
			invalidate_render();
		}
	}
}
}
