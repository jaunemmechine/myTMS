#tmsUtils文件提供了一系列的工具方法
angular.module("myApp")
 .factory('tmsUtils',[()->

  processHttpError = (res)->
    #获得服务器端的响应
    data = res.data
    console.log("data="+data)
    #如果有错误消息就用alert弹出来
    if data.message
      alert(data.message)
  return {
    processHttpError:processHttpError
  }
])