express = require('express')
db = require('./../libs/db')
taskBiz = require('./../biz/taskBiz')
commonBiz = require('./../biz/commonBiz')
router = express.Router()

#按照Restful设计原则规划路由
#添加任务
console.log("router luyou")
router.post('/task',commonBiz.setUserinfo,commonBiz.isLogined ,taskBiz.addTask)
#修改任务
router.put('/task',commonBiz.setUserinfo,
  commonBiz.isLogined,
  taskBiz.updateTask)
#删除
router.delete('/task/:id',commonBiz.setUserinfo,
  commonBiz.isLogined,
  taskBiz.deleteTask)
#查询单个任务
router.get('/task/:id',commonBiz.setUserinfo,
  commonBiz.isLogined,
  taskBiz.findTaskById)
#查询多个任务的列表
router.get('/task',commonBiz.setUserinfo,
  commonBiz.isLogined,
  taskBiz.findTaskList)

module.exports = router
