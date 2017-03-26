angular.module('myApp')
.controller('IndexCtrl',['$scope','$location','$http','tmsUtils',($scope,$location,$http,tmsUtils)->
     console.log('这是首页控制器')
     $scope.task=
          description:'' #任务的描述信息

     #任务列表
     $scope.taskList=[]

     # 用户退出
     $scope.exit=()->
       console.log("退出登录")
       $http.post("#{Tms.apiAddr}/api/user/logout")
       .then(()->
           alert('用户已注销')
           $location.path("/login")
         ,tmsUtils.processHttpError)

     #init函数用来查出这个用户的所有的task任务,并放到taskList中,以便在首页显示出来
     init = ->
          $http.get("#{Tms.apiAddr}/api/task")
          .then((res)->
               tasks=res.data
               $scope.taskList=tasks
          ,tmsUtils.processHttpError)
          return

     #调用init执行
     init()

     #添加任务到任务列表中的事件
     $scope.addTask= ->
          task = angular.copy($scope.task);
          task.checked = false;
          $http.post("#{Tms.apiAddr}/api/task",task)
          .then((res)->
             newTask = res.data
             #获得服务端传回的新加任务的json对象后,要把改对象添加进
             #任务列表
             task._id=newTask._id
             task.deleted=newTask.deleted
             $scope.taskList.push(task)
             $scope.task.description=''
          ,tmsUtils.processHttpError)

     #修改任务的状态 状态有两个取值 InProgress 和 Finish
     $scope.changeTaskStatus =(task) ->
          task.status= if task.checked then 'Finish' else 'InProgress'

     #控制当前任务是否进入编辑状态
     $scope.editTask = (task) ->
           task.isEditing=true
           task.tempDescription=task.description

     #退出编辑状态
     $scope.cancelEditTask=(task)->
          task.isEditing=false

     #保存编辑
     $scope.saveTask=(task)->
        console.log('保存编辑')
        oldDescription = task.description
        task.description=task.tempDescription
        $http.put("#{Tms.apiAddr}/api/task",task)
        .then(
          (res)->
             task.isEditing=false
          ,
          (res)->
             task.description=oldDescription
             tmsUtils.processHttpError(res)
        )

     $scope.deleteTask = (task,index) ->
         task.deleted = true
         $http.put("#{Tms.apiAddr}/api/task",task)
         .then(
           (res)->
             $scope.taskList.splice(index,1)
           ,tmsUtils.processHttpError)

     return

])