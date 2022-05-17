(function(angular, _) {
  var module = angular.module('move/item/index_controller', ['cyberhawk']);

  var Methods = {
    requestCategories: function() {
      var that = this;
      this.requester.http.get('/categories')
        .then(function(response) {
          that.categories = response.data;
        });
    }
  };

  module.config(['cyberhawkProvider', function(provider) {
    var Controller = provider.$get().controller,
      path = '/moves/:move_id/items/new';

    Controller.withPath(path, Methods);

    Controller.on(path, 'request', 'requestCategories');
  }]);
}(window.angular, window._));
