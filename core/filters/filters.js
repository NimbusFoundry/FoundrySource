// Generated by CoffeeScript 1.8.0
angular.module('foundry-ui').filter('utc_date', function() {
  return function(input, format) {
    var out;
    out = new Date(input);
    out = out.toDateString();
    return out;
  };
});
