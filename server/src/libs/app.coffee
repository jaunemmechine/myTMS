express = require('express')
path = require('path')
logger = require('morgan')
bodyParser = require('body-parser')
index = require('./../routes/index')
userRouter = require('./../routes/user')
taskRouter = require('./../routes/task')
cors = require('cors')

app = express()

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors())


#采用Restful设计原则
#路径有/api/user
app.use('/api', index)
app.use('/api',userRouter)
#/api/task
app.use('/api',taskRouter)


app.use((req, res, next)->
   err = new Error('Not Found')
   err.status = 404
   next(err)
)

app.use((err, req, res, next)->
  res.send(err.status || 500, {
      message:err.message
  })
);


module.exports = app;
