express = require('express')
db = require('./../libs/db')
router = express.Router()

#http://127.0.0.1:3010/api/hello
router.get('/hello', (req, res, next)->
   db.users.insert({username:'tom'}, (err,user)->
       return next(err) if err
       console.log(user)
       res.json(user)
       return
   )
)

module.exports = router
