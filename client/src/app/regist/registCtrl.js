// Generated by CoffeeScript 1.12.4
(function() {
  angular.module('myApp').controller('RegistCtrl', [
    '$scope', '$location', '$http', 'tmsUtils', function($scope, $location, $http, tmsUtils) {
      console.log('注册的控制器');
      $scope.userEntity = {
        username: '',
        password: '',
        password2: ''
      };
      $scope.doRegist = function() {
        console.log($scope.userEntity);
        $http.post(Tms.apiAddr + "/api/user/regist", {
          username: $scope.userEntity.username,
          password: $scope.userEntity.password,
          password2: $scope.userEntity.password2
        }).then(function(res) {
          var data;
          data = res.data;
          return $location.path("/login").replace();
        }, tmsUtils.processHttpError);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=registCtrl.js.map
