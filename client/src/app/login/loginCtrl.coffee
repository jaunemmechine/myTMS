#找到名叫myApp的模块
angular.module('myApp')
.controller('LoginCtrl',['$scope','$location','$http','tmsUtils',($scope,$location,$http,tmsUtils)->
     $scope.userEntity=
         username:''
         password:''
         rememberMe : false;
     console.log '登陆的控制器'

     $scope.doLogin = ->
       $http.post("#{Tms.apiAddr}/api/user/login",{
           username:$scope.userEntity.username
           password:$scope.userEntity.password
       }).then(
         (res) ->
           #成功的回调函数
           token=res.data.token
           #登陆成功后,所有的请求都必须携带这个token
           $http.defaults.headers.common['x-token']=token
           console.log("token=#{token}")
           #如果登陆成功,则转到首页
           $location.path("/").replace();
           return
         ,
         tmsUtils.processHttpError
       )
     return
])