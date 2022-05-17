(function(angular) {
  angular
    .module("mc_doodle")
    .filter("string", function() {
      return function(input) { 
        return input.toString();
      };
    });
})(window.angular);
