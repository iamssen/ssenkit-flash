package ssen.datakit.file {

/** 파일을 다루는데 필요한 여러 유틸들 */
public class FileNameUtils {
	
	public static const DIRECTORY_INVALIDATE_CHARACTERS:Vector.<String>=new <String>["\\", "/", ":", "*", "?", '"', "'", "<", ">", "|", ",", ";"];

	/** 파일 이름에 확장자가 없을때, 확장자를 붙여준다 */
	public static function addExtensionToFileName(fileName:String, extension:String):String {
		var names:Array=fileName.split(".");

		if (names.length !== 1 && names[names.length - 1] == extension) {
			return fileName;
		}

		return fileName + "." + extension;
	}

	/** 파일 이름에서 확장자를 제거해준다 */
	public static function removeExtension(fileName:String):String {
		var names:Array=fileName.split(".");

		if (names.length > 1) {
			names.pop();
			return names.join(".");
		}

		return fileName;
	}
}
}
