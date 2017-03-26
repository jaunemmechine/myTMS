// Generated by CoffeeScript 1.12.4
(function() {
  angular.module('myApp', ['ngRoute']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/login', {
        templateUrl: '/app/login/login.html',
        controller: 'LoginCtrl'
      }).when('/regist', {
        templateUrl: '/app/regist/regist.html',
        controller: 'RegistCtrl'
      }).when('/', {
        templateUrl: '/app/index/index.html',
        controller: 'IndexCtrl'
      });
      console.log('主路由');
    }
  ]).run([
    '$location', function($location) {
      $location.path('/login').replace();
    }
  ]);

}).call(this);

//# sourceMappingURL=index.js.map
