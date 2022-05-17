(function(angular, _) {
  var module = angular.module('move/item/controllers', ['cyberhawk']);

  var Methods = {
    requestCategories: function() {
      this.requester.http.get('/categories')
        .then(this._setCategories)
    },

    _setCategories: function(response) {
      this.categories = response.data;
    }
  };

  module.config(['cyberhawkProvider', function(provider) {
    var Controller = provider.$get().controller,
      path = '/moves/:move_id/items/new';

    Controller.withPath(path, Methods);

    Controller.on(path, 'request', 'requestCategories');
  }]);
}(window.angular, window._));
