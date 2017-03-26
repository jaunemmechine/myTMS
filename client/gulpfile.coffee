gulp = require('gulp')
del = require('del')
fs = require('fs')
runSequence = require('run-sequence')
uglify=require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
concat = require('gulp-concat')
browserSync = require('browser-sync')


#读取assets.json文件
assets =   JSON.parse(fs.readFileSync("assets.json"))

#新建默认任务
gulp.task('default',(callback)->
  #runSequence任务队列中 参数与参数之间的任务是按顺序执行,也就是同步的。
  #同一个参数数组中的任务是并列同时执行
  runSequence(['clean'],['build'],['server'],['watch'],callback)
)

#直接删除dist目录,方便重新构建
gulp.task 'clean',(callback)->
  del(['./dist'],callback)

#创建build任务链  按顺序执行copy minijs和 minicss任务
gulp.task('build',(callback)->

  runSequence(
    ['assetsJs','assetsCss','assetsFont'],
    ['appJs','appCss','copyHtml','copyConfig'],
    callback)
)

#合并所有的第三方JS文件
gulp.task 'assetsJs', ->
  gulp.src(assets.assetsJs)
#通过pipe管道读取的js数据流流经uglify处理,变成压缩后的数据流
#  .pipe(uglify())
  .pipe(concat('assets.js',{newLine:'\n\n'}))
  .pipe(gulp.dest './dist/assets/js/')

#合并所有的第3方css文件为assets.css
gulp.task 'assetsCss', ->
  gulp.src(assets.assetsCss)
#通过pipe管道读取的js数据流流经uglify处理,变成压缩后的数据流
#  .pipe(minifyCss())
  .pipe(concat('assets.css',{newLine:'\n\n'}))
  .pipe(gulp.dest './dist/assets/css/')

#copy所有的第三方的字体文件
gulp.task 'assetsFont',->
  gulp.src(assets.assetsFont)
  .pipe(gulp.dest './dist/assets/fonts/')

#新建一个任务 将所有的自己写的js文件拼接成一个名叫app.js的文件
gulp.task 'appJs',->
  gulp.src(assets.appJs)
  .pipe(concat('app.js',{newLine:';\n'}))
  .pipe(gulp.dest('./dist/assets/js'))
#新建一个任务 将所有的自己写的CSS文件拼接成一个名叫app.css的文件
gulp.task 'appCss',->
  gulp.src(assets.appCss)
  .pipe(concat('app.css',{newLine:'\n\n'}))
  .pipe(gulp.dest('./dist/assets/css'))
#copy所有的html文件到dist目录下
gulp.task 'copyHtml', ->
   gulp.src(['./src/**/*.html'])
   .pipe(gulp.dest('./dist/'))
#复制config文件
gulp.task 'copyConfig', ->
  gulp.src(['./src/config/**/*.js'])
  .pipe(gulp.dest('./dist/config/'))

#新建创建服务器的任务,来让浏览器运行我们的前端页面
gulp.task('server', ->
     browserSync.init(
       {
         server:{
           baseDir:'./dist/'
         }
         port:3005
       }
     )
)
#监视文件是否改变
gulp.task('watch',->
    gulp.watch('./src/**/*.*',['reload'])

)

#定义文件修改后要自动执行的任务

gulp.task('reload',(callback) ->
   runSequence(['build'],['reload-browser'],callback)
)


#刷新浏览器的任务
gulp.task('reload-browser',->
   browserSync.reload()
)











