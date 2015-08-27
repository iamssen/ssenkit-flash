package ssen.devkit {
public class CollectionPrinter {
	public static function printTable(list:Array, properties:Vector.<String>):void {
		var maxLengths:Vector.<int> = new Vector.<int>(properties.length, true);
		var strs:Array = [];

		var data:Object;
		var property:String;
		var str:String;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;

		const margin:int = 3;

		//---------------------------------------------
		// count max lengths
		//---------------------------------------------
		// count property name string
		f = -1;
		fmax = properties.length;
		while (++f < fmax) {
			property = properties[f];
			maxLengths[f] = property.length + margin;
		}

		// count value string and save string
		f = -1;
		fmax = list.length;
		while (++f < fmax) {
			data = list[f];
			strs.push({});

			s = -1;
			smax = properties.length;
			while (++s < smax) {
				property = properties[s];
				str = data[property].toString();

				// save string
				strs[f][property] = str;

				// save string count
				if (str.length + margin > maxLengths[s]) {
					maxLengths[s] = str.length + margin;
				}
			}
		}

		//---------------------------------------------
		// make lines
		//---------------------------------------------
		var lines:Array = [];
		var line:Array;

		// make property name line
		line = [];
		f = -1;
		fmax = properties.length;
		while (++f < fmax) {
			property = properties[f];
			line.push(fillSpace(property, maxLengths[f]));
		}
		lines.push(line);

		// make --- line
		line = [];
		f = -1;
		fmax = properties.length;
		while (++f < fmax) {
			property = properties[f];
			line.push(squareString("-", maxLengths[f]));
		}
		lines.push(line);

		// make value lines
		f = -1;
		fmax = strs.length;
		while (++f < fmax) {
			data = strs[f];

			line = [];

			s = -1;
			smax = properties.length;
			while (++s < smax) {
				line.push(fillSpace(data[properties[s]], maxLengths[s]));
			}
			lines.push(line);
		}

		//---------------------------------------------
		// print
		//---------------------------------------------
		var lineString:String;
		f = -1;
		fmax = lines.length;
		while (++f < fmax) {
			line = lines[f];
			lineString = "|" + line.join("|") + "|";
			trace(lineString);
		}
	}

	private static function squareString(character:String, length:int):String {
		var line:String = "";
		var f:int = -1;
		while (++f < length) {
			line += character;
		}
		return line;
	}

	private static function fillSpace(str:String, length:int):String {
		var f:int = str.length - 1;
		while (++f < length) {
			str += " ";
		}
		return str;
	}
}
}
