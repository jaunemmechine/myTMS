#专门处理访问路径是/api/user的请求
express = require('express')
db = require('./../libs/db')
userBiz = require('./../biz/userBiz')
router = express.Router()

#http://127.0.0.1:3010/api/user/regist
router.post('/user/regist',userBiz.isPwdEq,
                           userBiz.isUserExist,
                           userBiz.regist)

router.post('/user/login', userBiz.login)

router.post('/user/logout', userBiz.logout)



module.exports = router
