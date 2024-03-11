var t={};t=isFunction;var n=Object.prototype.toString;function isFunction(t){if(!t)return false;var o=n.call(t);return"[object Function]"===o||"function"===typeof t&&"[object RegExp]"!==o||"undefined"!==typeof window&&(t===window.setTimeout||t===window.alert||t===window.confirm||t===window.prompt)}var o=t;export default o;

