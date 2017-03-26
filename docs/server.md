# 前后端分离的任务管理系统(服务器端)
--------------------------
##一 服务器端框架搭建
###1.文件目录
####1.1安装nedb数据库
    1.cnpm install nedb --save
    2.在src目录下新建database文件夹
    3.在config/config.coffee文件中加入数据库路径
```
path = require('path')


module.exports ={
   port:7410
   dbFilePath:path.join(__dirname,'./../database/')
}
```
    4.在libs文件夹下新建文件db.coffee 用来连接数据库
```
Datastore = require('nedb')
config = require('./../config/config')

db={}
dbPath = config.dbFilePath

db.users= new Datastore(dbPath+'users.db')
db.users.loadDatabase();
module.exports=db
```
    4.安装token验证包 express-jwt
```
cnpm install express-jwt --save
```
    5.安装token生成工具 jsonwebtoken
```
cnpm install jsonwebtoken --save

```
    6.测试数据库是否正常,在api.coffee中编写如下代码
```
router.get('/faq', (req, res, next) ->
  console.log('进入faq')
  db.users.insert({username:'tom'},(err,user)->
     return next(err) if err
     console.log(user)
     res.json(user)
     return
  )
)
```
####1.2 分拆路由
    1.在routes中新建user.coffee
    2.在/libs/app.coffee中添加路由分配
```
app.use('/api', userRouters)

```
###2.编写user用户相关逻辑
####2.1编写user的注册
    1.在user.coffee中编写注册代码如下
```
router.post('/user/regist', (req, res, next) ->
  body = req.body
  console.log(body)
  return next('请提交用户注册信息') if not body or not body.username or not body.password
  #正常注册
  console.log('bbbb')
  postData={
    username:body.username
    password:body.password
    token:''
    expiredTime:Date.now()
  }
  console.log('cccc')
  db.users.insert(postData,(err,user)->
    console.log(user)
    return next(err) if err
    res.json(true)
  )
  return

```
####2.2将业务逻辑代码与路由代码分离
    1.在server的根目录下新建文件夹biz,存放所有的业务处理类
    2.在biz文件夹下新建userBiz.coffee文件
```
db = require('./../libs/db')

regist=(req,res,next) ->
  body = req.body
  console.log(body)
  return next('请提交用户注册信息') if not body or not body.username or not body.password
  #正常注册
  console.log('bbbb')
  postData={
    username:body.username
    password:body.password
    token:''
    expiredTime:Date.now()
  }
  console.log('cccc')
  db.users.insert(postData,(err,user)->
    console.log(user)
    return next(err) if err
    res.json(true)
  )
  return

module.exports={
  regist:regist
}

``` 
    3.修改routes/user.coffee文件如下
```
express = require('express');
router = express.Router();
userBiz = require('./../biz/userBiz')
router.post('/user/login', (req, res, next) ->

   console.log(req.body)
   res.send('login')
   return
)
router.post('/user/regist', userBiz.regist)


module.exports = router;

```
####2.3注册验证的实现
    1.在userBiz.coffee文件中添加isUserExit函数
```
isUserExists = (req,res,next) ->
  db.users.findOne({username:req.body.username},(err,user) ->
      return next(err) if err
      if user
        return next('用户名已存在,请重新注册')
      next()
  )
  
module.exports={
  isUserExists:isUserExists
  regist:regist
}


```
    2.在routes/user.coffee文件中修改路由调用如下
```
router.post(
  '/user/regist'
  userBiz.isUserExists
  userBiz.regist
)
```
####2.4编写用户的登陆逻辑
    1.在userBiz.coffee中添加login方法
```
login = (req,res,next) ->
  username=req.body.username
  password=req.body.password
  console.log("username="+username+" pwd="+password)
  db.users.findOne({username:username,password:password},(err,user) ->
      return next(err) if err
      return next('登陆失败') if  !user
      token = jwt.sign({username:username},'lvlay')
      res.json({token:token})

  )
```
    2.暴露出login方法
```
module.exports={
  isUserExists:isUserExists
  regist:regist
  login:login
}

```
    3.修改routes/user.coffee文件 中的 router.post('/user/login')方法 
```
router.post('/user/login', userBiz.login)

```

###3.编写task用户相关逻辑
####3.1编写task的路由
    1.在routes中新建task.coffee路由文件
```
express = require('express');
router = express.Router();

#新增任务
router.post('/task')

#修改任务
router.put('/task')

#查找单个任务
router.get('/task/:id')

#获得多个任务列表
router.get('/task')

module.exports = router;

```
    2.修改app.coffee文件 增加task的路由
```
app.use('/api', taskRouters)
```
####3.2 编写新增task
#####3.2.1在biz文件夹下新增taskBiz.coffee文件
#####3.2.2在taskBiz.coffee文件中新增代码如下
```
db = require('./../libs/db')
jwt = require('jsonwebtoken')


addTask = (req,res,next) ->
  body = req.body
  data = {
    taskName:''
    createDate:Date.now()
    updateDate:Date.now()
    status:'未完成'
  }
  db.tasks.insert(data,(err,task) ->
    return next(err) if err
    return next('创建任务失败') if !task
    res.json(true)
    return

  )



module.exports ={
    addTask:addTask

}
```
#####3.2.3 修改routes/task.coffee如下
```
express = require('express');
router = express.Router();
taskBiz = require('./../biz/taskBiz')

#新增任务
router.post('/task',taskBiz.addTask)

#修改任务
#router.put('/task')

#查找单个任务
#router.get('/task/:id')

#获得多个任务列表
#router.get('/task')

module.exports = router;

```
#####3.2.4 修改数据库连接文件libs/db.coffee 在其中增加如下
```
db.tasks= new Datastore(dbPath+'tasks.db')
db.tasks.loadDatabase();
```

#####3.2.5 使用相同方式 增加 更新  查看单条  查看多条 等api,如下
```
db = require('./../libs/db')
jwt = require('jsonwebtoken')


addTask = (req,res,next) ->
  body = req.body
  data = {
    creator:'xxx'
    taskName:body.taskName
    createDate:Date.now()
    updateDate:Date.now()
    status:'未完成'
    deleted:false
  }
  db.tasks.insert(data,(err,task) ->
    return next(err) if err
    return next('创建任务失败') if !task
    res.json(true)
    return

  )

updateTask = (req,res,next) ->
  body = req.body
  db.tasks.findOne({_id:body._id},(err,task)->
    return next(err) if err
    return next('未找到要更新的任务') if !task
    db.tasks.update({_id:task._id},{$set:{
      creator:'xxx'
      taskName:body.taskName
      updateDate:Date.now()
      status:body.status
      deleted:body.deleted || false
    }},(err,num)->
      return next(err) if err
      return next('更新失败') if num is 0
      res.json(true)
    )

  )

getTask = (req,res,next) ->
  taskId=req.params.id
  db.tasks.findOne({_id:taskId},(err,task) ->
     return next(err) if err
     res.json(task)
  )

getTasks = (req,res,next) ->
  db.tasks.find({deleted:false,creator:'xxx'},(err,tasks) ->
    return next(err) if err
    res.json(tasks)

  )


module.exports ={
  addTask:addTask
  getTask:getTask
  getTasks:getTasks
  updateTask:updateTask
}
```

#####3.2.5 给添加 更新 等操作添加授权
    1.在biz文件夹中新建commonBiz.coffee文件,内容如下
```
db = require('./../libs/db')

module.exports ={

  setUserInfo :(req,res,next)->
    #客户端在提交请求时,要将他的令牌token一起提交过来,以便让服务器端知道它是谁
    token = req.headers['x-token']
    db.users.findOne({token:token,expiredTime:{$gt:Date.now()}},(err,user) ->
       req.userInfo = user if not err
       next()
    )

  validateUserinfo:(req,res,next) ->
    if not req.userInfo
      res.status(401)
      return res.send('未授权')
    next()
}
```
    2.给task的相关操作全部加上鉴权,修改routes/task.coffee如下
```
express = require('express');
router = express.Router();
taskBiz = require('./../biz/taskBiz')
commonBiz = require('./../biz/commonBiz')

#新增任务
router.post('/task',commonBiz.setUserInfo,commonBiz.validateUserinfo,taskBiz.addTask)

#修改任务
router.put('/task',commonBiz.setUserInfo,commonBiz.validateUserinfo,taskBiz.updateTask)

#查找单个任务
router.get('/task/:id',commonBiz.setUserInfo,commonBiz.validateUserinfo,taskBiz.getTask)

#获得多个任务列表
router.get('/task',commonBiz.setUserInfo,commonBiz.validateUserinfo,taskBiz.getTasks)

module.exports = router;

```

