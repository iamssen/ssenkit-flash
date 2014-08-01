package ssen.drawingkit {
import flash.geom.Rectangle;

/**
 * 대상을 특정 사이즈에 맞게 줄일때 필요한 곱하기 비율을 알아낸다
 * @param bounds scaling 시킬 대상의 bound
 * @param targetCoordinateSpace scaling 시킬 공간의 bound
 * @return scaling 시키기 위해서 곱해줄 비율
 */
public function getScalingMinimizeRatio(bounds:Rectangle, targetCoordinateSpace:Rectangle):Number {
	var hratio:Number=(bounds.width > targetCoordinateSpace.width) ? targetCoordinateSpace.width / bounds.width : 1;
	var vratio:Number=(bounds.height > targetCoordinateSpace.height) ? targetCoordinateSpace.height / bounds.height : 1;

	return (hratio > vratio) ? vratio : hratio;

}
}
