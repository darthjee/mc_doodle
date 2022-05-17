(function(angular) {
  angular
    .module("mc_doodle")
    .filter("number", function() {
      return function(input) {
        if (!input) {
          return;
        }

        return parseInt(input);
      };
    });
})(window.angular);
