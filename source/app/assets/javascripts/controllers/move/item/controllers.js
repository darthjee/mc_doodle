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
      paths = ['/moves/:move_id/items/new', '/moves/:move_id/items/:id/edit'];

    Controller.withPath(paths, Methods);

    Controller.on(paths, 'request', 'requestCategories');
  }]);
}(window.angular, window._));
