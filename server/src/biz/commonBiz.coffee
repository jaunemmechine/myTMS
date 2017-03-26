#提供鉴权等通用功能
db = require('./../libs/db')

#查看用户是否登陆

setUserinfo = (req,res,next)->
  #客户端在提交请求时,要将它的token令牌一起交过来,以便让服务器知道,这个请求是谁提交的
  #从req中获取客户端提交过来的token
  token = req.headers['x-token']
  #根据token去user表中查找对应的user
  db.users.findOne(
     {
       token:token,
       expiredTime:{
        $gt:Date.now()
      }
     },(err,user)->
       #将查询到的用户信息保存到request对象中
       req.userinfo = user if not err
       next()
    )
#检查用户是否已经登陆
isLogined=(req,res,next)->
   if not req.userinfo
      res.status(401)
      res.send('未授权')
      return
   next()


module.exports={
     setUserinfo:setUserinfo
     isLogined:isLogined
}