package ssen.common {

public class MathUtils {
	/** 0 ~ 360 까지의 Radian 값을 가지고 있다 */
	public static const RADIAN:Array=[0, 0.017, 0.035, 0.052, 0.070, 0.087, 0.105, 0.122, 0.140, 0.157, 0.175, 0.192, 0.209, 0.227, 0.244, 0.262, 0.279, 0.297, 0.314, 0.332, 0.349,
									  0.367, 0.384, 0.401, 0.419, 0.436, 0.454, 0.471, 0.489, 0.506, 0.524, 0.541, 0.559, 0.576, 0.593, 0.611, 0.628, 0.646, 0.663, 0.681, 0.698,
									  0.716, 0.733, 0.750, 0.768, 0.785, 0.803, 0.820, 0.838, 0.855, 0.873, 0.890, 0.908, 0.925, 0.942, 0.960, 0.977, 0.995, 1.012, 1.030, 1.047,
									  1.065, 1.082, 1.100, 1.117, 1.134, 1.152, 1.169, 1.187, 1.204, 1.222, 1.239, 1.257, 1.274, 1.292, 1.309, 1.326, 1.344, 1.361, 1.379, 1.396,
									  1.414, 1.431, 1.449, 1.466, 1.484, 1.501, 1.518, 1.536, 1.553, 1.571, 1.588, 1.606, 1.623, 1.641, 1.658, 1.676, 1.693, 1.710, 1.728, 1.745,
									  1.763, 1.780, 1.798, 1.815, 1.833, 1.850, 1.868, 1.885, 1.902, 1.920, 1.937, 1.955, 1.972, 1.990, 2.007, 2.025, 2.042, 2.059, 2.077, 2.094,
									  2.112, 2.129, 2.147, 2.164, 2.182, 2.199, 2.217, 2.234, 2.251, 2.269, 2.286, 2.304, 2.321, 2.339, 2.356, 2.374, 2.391, 2.409, 2.426, 2.443,
									  2.461, 2.478, 2.496, 2.513, 2.531, 2.548, 2.566, 2.583, 2.601, 2.618, 2.635, 2.653, 2.670, 2.688, 2.705, 2.723, 2.740, 2.758, 2.775, 2.793,
									  2.810, 2.827, 2.845, 2.862, 2.880, 2.897, 2.915, 2.932, 2.950, 2.967, 2.985, 3.002, 3.019, 3.037, 3.054, 3.072, 3.089, 3.107, 3.124, 3.142,
									  3.159, 3.176, 3.194, 3.211, 3.229, 3.246, 3.264, 3.281, 3.299, 3.316, 3.334, 3.351, 3.368, 3.386, 3.403, 3.421, 3.438, 3.456, 3.473, 3.491,
									  3.508, 3.526, 3.543, 3.560, 3.578, 3.595, 3.613, 3.630, 3.648, 3.665, 3.683, 3.700, 3.718, 3.735, 3.752, 3.770, 3.787, 3.805, 3.822, 3.840,
									  3.857, 3.875, 3.892, 3.910, 3.927, 3.944, 3.962, 3.979, 3.997, 4.014, 4.032, 4.049, 4.067, 4.084, 4.102, 4.119, 4.136, 4.154, 4.171, 4.189,
									  4.206, 4.224, 4.241, 4.259, 4.276, 4.294, 4.311, 4.328, 4.346, 4.363, 4.381, 4.398, 4.416, 4.433, 4.451, 4.468, 4.485, 4.503, 4.520, 4.538,
									  4.555, 4.573, 4.590, 4.608, 4.625, 4.643, 4.660, 4.677, 4.695, 4.712, 4.730, 4.747, 4.765, 4.782, 4.800, 4.817, 4.835, 4.852, 4.869, 4.887,
									  4.904, 4.922, 4.939, 4.957, 4.974, 4.992, 5.009, 5.027, 5.044, 5.061, 5.079, 5.096, 5.114, 5.131, 5.149, 5.166, 5.184, 5.201, 5.219, 5.236,
									  5.253, 5.271, 5.288, 5.306, 5.323, 5.341, 5.358, 5.376, 5.393, 5.411, 5.428, 5.445, 5.463, 5.480, 5.498, 5.515, 5.533, 5.550, 5.568, 5.585,
									  5.603, 5.620, 5.637, 5.655, 5.672, 5.690, 5.707, 5.725, 5.742, 5.760, 5.777, 5.794, 5.812, 5.829, 5.847, 5.864, 5.882, 5.899, 5.917, 5.934,
									  5.952, 5.969, 5.986, 6.004, 6.021, 6.039, 6.056, 6.074, 6.091, 6.109, 6.126, 6.144, 6.161, 6.178, 6.196, 6.213, 6.231, 6.248, 6.266, 6.283];


	/** random 한 16 진수 문자열을 만든다 */
	public static function randHex(length:int=8):String {
		var str:String="";
		length++;
		while (--length >= 0) {
			str+=MathUtils.rand(0, 14).toString(16);
		}
		return str;
	}

	/** min 과 max 사이에서 random 한 값을 만든다 */
	public static function rand(min:int, max:int):int {
		return Math.random() * (max - min + 1) + min;
	}

	/** degree 값을 radian 으로 바꿔준다 */
	public static function deg2rad(deg:Number):Number {
		var rad:Number=deg * Math.PI / 180;
		return rad;
	}

	/** radian 값을 degree 로 바꿔준다 */
	public static function rad2deg(rad:Number):Number {
		return rad * 180 / Math.PI;
	}

	/**
	 * null 이나 undefined, 혹은 NaN 과 같은 숫자형 에러일 경우 기본값으로 바꿔준다
	 * @param value 체크할 값
	 * @param defaultValue 대치할 값
	 */
	public static function nanTo(value:*, defaultValue:Number=0):Number {
		if (value === null || value === undefined) {
			return defaultValue;
		}

		var n:Number=Number(value);

		if (isNaN(n)) {
			return defaultValue;
		}

		return value;
	}

	public static function rangeOf(value:Number, min:Number, max:Number):Boolean {
		return value >= min && value <= max;
	}
}
}

class NotUse {
	/** 1 ~ 100 까지의 prime number 집합 */
	public static const PRIME_NUMBER_100:Array=[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];

	/** 음의 정수 */
	public static const TYPE_NEGATIVE:String="negative";

	/** 양의 정수, 자연수 */
	public static const TYPE_NATURAL:String="natural";

	/** 0 을 나타냄 */
	public static const TYPE_0:String="zero";

	/** 소수 */
	public static const TYPE_DECIMAL:String="decimal";

	/** 지정된 숫자까지의 prime number 를 가져온다 */
	public static function primeNumbers(max:int):Array {
		var arr:Array=new Array;

		for (var f:int=2; f <= max; f++) {
			for (var s:int=2; s <= f; s++) {
				if (f == s) {
					arr.push(f);
				} else if ((f % s) == 0) {
					break;
				}
			}
		}
		return arr;
	}

	public static function pow2Size(value:int):int {
		var x:int=2;
		while (x < value) {
			x*=2;
		}
		return x;
	}

	/** 소인수 분해 */
	public static function factorizationPrime(x:int):Array {
		var arr:Array=new Array;
		var flag:Boolean=true;
		var d:int;

		while (flag) {
			if (isPrime(x)) {
				flag=false;
				arr.push(x);
			} else {
				d=findPrimeFactor(x);
				x=x / d;
				arr.push(d);
			}
		}

		return arr;
	}

	/** 나누어 떨어지는 소인수 찾기 */
	public static function findPrimeFactor(x:int):int {
		var f:int;
		for each (f in PRIME_NUMBER_100) {
			if (x % f == 0) {
				return f;
			}
		}
		return x;
	}

	/** prime number 인지 확인 */
	public static function isPrime(x:int):Boolean {
		var f:int;
		for each (f in PRIME_NUMBER_100) {
			if (x == f) {
				return true;
			}
		}
		return false;
	}

	/** 2,2,3,3,4 와 같은 배열을 [2]=3, [3]=1, [4]=1 과 형태의 제곱수 배열로 바꿔준다 */
	public static function convertSquares(arr:Array):Object {
		var arr2:Object=new Object;

		for each (var f:int in arr) {
			if (arr2[f] == undefined) {
				arr2[f]=1;
			} else {
				arr2[f]++;
			}
		}
		return arr2;
	}

	/** 최소공배수 구하기 */
	public static function leastCommonMultiple(... nums):int {
		var x:int=nums[0];
		var cnt:int;
		for (cnt=1; cnt <= nums.length - 1; cnt++) {
			x=lcm(x, nums[cnt]);
		}

		return x;
	}

	/** 최대공약수 구하기 */
	public static function greatestCommonDivisor(... nums):int {
		var x:int=nums[0];
		var cnt:int;
		for (cnt=1; cnt <= nums.length - 1; cnt++) {
			x=gcd(x, nums[cnt]);
		}

		return x;
	}

	/** 최대공약수 구하기 */
	public static function gcd(a:int, b:int):int {
		return (b == 0) ? a : gcd(b, a % b);
	}

	/** 최소공배수 구하기 */
	public static function lcm(a:int, b:int):int {
		return a * b / gcd(a, b);
	}

	/** 정수인지 확인한다 */
	public static function isInteger(x:Number):Boolean {
		if (x - int(x) == 0) {
			return true;
		}
		return false;
	}

	/** 숫자의 형태를 가져온다 */
	public static function numberTypeOf(x:Number):String {
		if (x == 0) {
			return TYPE_0;
		} else if (x - int(x) != 0) {
			return TYPE_DECIMAL;
		} else if (x > 0) {
			return TYPE_NATURAL;
		} else {
			return TYPE_NEGATIVE;
		}
	}
}
