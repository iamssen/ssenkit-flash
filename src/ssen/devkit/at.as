package ssen.devkit {
public function at():String {
	var at:String;
	try {
		throw new Error("");
	} catch (error:Error) {
		at=error.getStackTrace().split("\n")[2].replace("\t", "--");
	}

	return at;
}
}
