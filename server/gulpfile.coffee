gulp = require('gulp')
del = require('del')
developServer = require('gulp-develop-server')
runSequence = require('run-sequence')
notify = require('gulp-notify')

gulp.task('default',(callback)->
   runSequence(['clean'],['copy'],['server'],['watch'],callback)
)

#删除dist目录
gulp.task('clean',(callback)->
   del('./dist/',callback)
)

#将src中的代码复制到dist目录

gulp.task('copy',->
   gulp.src('./src/**/*.js')
   .pipe(gulp.dest('./dist/'))
)

#启动服务器
gulp.task('server',->
   developServer.listen({
      path:'./dist/www.js'
   })
)

#添加watch监控服务端代码的变化

gulp.task('watch',->
  gulp.watch('./src/**/*.js',['reload'])
)

#重启服务的任务队列
gulp.task('reload',(callback)->
    runSequence(['copy'],['reload-node'],callback)

)

gulp.task('reload-node',->
   developServer.restart();
   gulp.src('./dist/www.js')
   .pipe(notify('服务器已重启')
   )
)