(function(angular, _) {
  var module = angular.module('move/item/controllers', ['cyberhawk']);

  var withCategories = {
    requestCategories: function() {
      this.requester.http.get('/categories')
        .then(this._setCategories)
    },

    _setCategories: function(response) {
      this.categories = response.data;
    },

    _transformData: function() {
      if (!this.data.category || !this.data.category.id) {
        return
      }

      this.data.category.id = this.data.category.id.toString();
    }
  };

  module.config(['cyberhawkProvider', function(provider) {
    var Controller = provider.$get().controller,
      formPaths = ['/moves/:move_id/items/new', '/moves/:move_id/items/:id/edit'];

    Controller.withPath(formPaths, withCategories);

    Controller.on(formPaths, 'request', 'requestCategories');
    Controller.on(formPaths, 'loaded', '_transformData');
  }]);
}(window.angular, window._));
