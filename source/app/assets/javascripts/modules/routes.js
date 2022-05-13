(function(angular) {
  var module = angular.module("mc_doodle");

  module.config(["kantoProvider", function(provider) {
    provider.defaultConfig = {
      controller: "Cyberhawk.Controller",
      controllerAs: "gnc",
      templateBuilder: function(route, params) {
        return route + "?ajax=true";
      }
    }

    provider.configs = [{
      routes: ["/"],
      config: {
        controller: "Home.Controller",
        controllerAs: "hc"
      }
    }, {
      routes: ["/moves", "/moves/new", "/moves/:id", "/moves/:id/edit"]
    }];
    provider.$get().bindRoutes();
  }]);
}(window.angular));

