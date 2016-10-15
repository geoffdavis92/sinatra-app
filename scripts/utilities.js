export function curry (a) {
	return function (b) {
		return a+b;
	}
}