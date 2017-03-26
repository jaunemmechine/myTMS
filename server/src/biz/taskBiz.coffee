#task任务的业务处理文件
db = require('./../../dist/libs/db')
jwt =  require('jsonwebtoken')

#添加任务的逻辑处理函数
addTask = (req,res,next)->
  console.log 'Add Task'
  body = req.body
  token = req.headers['x-token']
  db.users.findOne({token:token},(err,user)->
        return next(err) if err
        return next(new Error('未授权')) if !user
        data =
          description:body.description
          createDate:Date.now()
          updateDate:Date.now()
          #新添加的任务默认是InProgress表示任务正在进行
          #任务做完了要把状态位改为finished
          status:"InProgress"
          deleted:false
    #任务的创建人ID,暂时写死
          creator:user._id
        db.tasks.insert(data,(err,task)->
          return next(err) if err
          return next(new Error('创建任务失败')) if !task
          res.json(task)
          return
        )
  )
  return

updateTask=(req,res,next)->
  console.log '编辑任务'
  body = req.body
  db.tasks.findOne({_id:body._id},(err,task)->
      return next(err) if err
      return next(new Error('未找到要跟新的任务')) if !task
      db.tasks.update(
        {_id:task._id},
        {
          $set:{
           description:body.description
           updateDate:Date.now()
           status:body.status
           deleted:false || body.deleted
         }
        },(err,num)->
            return next(err) if err
            return next(new Error('更新失败')) if num is 0
            res.json(true)
      )
  )

deleteTask = (req,res,next)->
    console.log '删除任务'
    body = req.body
    db.tasks.update(
          {_id:req.params.id},
          {
            $set:{
             deleted:false || body.deleted
            }
          },
        (err,num)->
          return next(err) if err
          return next(new Error('删除失败')) if num is 0
          res.json(true)
    )


findTaskById = (req,res,next)->
   taskId = req.params.id
   db.tasks.findOne({_id:taskId},(err,task)->
        return next(err) if err
        return next(new Error('查询失败')) if !task
        res.json(task)
   )

findTaskList = (req,res,next)->
    console.log '查任务列表'
    #首先要获得用户的id
    token = req.headers['x-token']
    db.users.findOne({token:token},(err,user)->
        return next(err) if err
        return next(new Error('未授权')) if !user
        db.tasks.find({deleted:false,creator:user._id},(err,tasks)->
            return  next(err) if err
            console.log("tasks="+tasks)
            res.json(tasks)
            return
        )
    )

module.exports ={
     addTask:addTask
     updateTask:updateTask
     deleteTask:deleteTask
     findTaskById:findTaskById
     findTaskList:findTaskList
}