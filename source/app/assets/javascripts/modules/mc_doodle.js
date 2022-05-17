(function(angular) {
  var module = angular.module('mc_doodle', [
    'global',
    'cyberhawk',
    'kanto',
    'home',
    'login',
    'move'
  ]);

  module.config(['$httpProvider', function($httpProvider) {
    $httpProvider.defaults.headers.patch = {
      'Content-Type': 'application/json;charset=utf-8'
    };
  }]);
}(window.angular));
