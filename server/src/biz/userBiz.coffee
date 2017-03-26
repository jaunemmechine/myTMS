#user对象的业务逻辑处理类
db = require('./../libs/db')
#引入令牌插件
jwt = require('jsonwebtoken')

#定义专门处理注册的业务逻辑函数
regist= (req,res,next) ->
  body =   req.body
  console.log body
  return next(new Error('请提交用户注册数据')) if not body or not body.username or not body.password
  #取到了表单数据 走正常注册的流程
  postData ={
    username:body.username,
    password:body.password,
    token:'',
    expiredTime:Date.now()
  }
  db.users.insert(postData,(err,user)->
    return  next(err) if err
    res.json(true)
  )
  return
#判断两次密码是否正确
isPwdEq= (req,res,next)->
  if req.body.password!=req.body.password2
     return next(new Error('两次密码不一致'))

  next()

#判断用户名是否已存在
isUserExist = (req,res,next)->
  db.users.findOne({username:req.body.username},(err,user)->
            return next(err) if err
            if user
              return next(new Error('用户名已存在'))
            next()
  )

logout= (req,res,next)->
  token = req.headers['x-token']
  db.users.update({token:token},{$set:
       {token:'',expiredTime:Date.now()}},
    (err,num)->
      return next(err) if err
      return next(new Error("注销失败")) if num is 0
      res.json(true)
  )


login = (req,res,next)->
    console.log '处理登陆'
    username = req.body.username
    password = req.body.password
    db.users.findOne({username:username,password:password},(err,user)->
          return next(err) if err
          return next(new Error('用户名或密码错,请重新登陆')) if !user
          #user不为空则登陆成功,需要获得token令牌,第一个参数是产生令牌的内容,第2个参数是令牌加密的密钥
          token = jwt.sign({username:username},'jaune')
          expiredTime=Date.now()+24*60*60*1000
          db.users.update({_id:user._id},{
            $set:{
              token:token
              expiredTime:expiredTime
            }
          },(err,num)->
             return next(err) if err
             return next(new Error("服务器正忙,请稍后再试")) if num is 0
             #将用户的token,以及token的过期时间更新到user表中
             res.json({token:token})
          )
    )

module.exports = {
    regist: regist
    login: login
    isUserExist:isUserExist
    isPwdEq:isPwdEq
    logout:logout
}

