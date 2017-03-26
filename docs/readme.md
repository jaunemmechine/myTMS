# 前后端分离的任务管理系统
--------------------------
## 一.前端项目搭建
### 1.建立项目文件夹结构
    1. 新建文件夹myTMS,在其下建立2个文件夹client 和 server,其中client用来存放前端的代码,server文件夹存放node服务端代码
    2. 在client文件夹下建立src和dist两个目录
    3. 打开命令行,进入到client目录
       - 执行npm init命令 初始化项目
       
        name: (TMS) tms_client
        version: (1.0.0) 
        description: 
        entry point: (index.js) 
        test command: 
        git repository: 
        keywords: 
        author: jaune
        license: (ISC) MIT
        About to write to /Users/maggie/WebstormProjects/TMS/package.json:
          
        {
          "name": "tms_client",
          "version": "1.0.0",
          "description": "",
          "main": "index.js",
          "scripts": {
          "test": "echo \"Error: no test specified\" && exit 1"},
          "author": "jaune",
          "license": "MIT"
        }
          
          
        Is this ok? (yes) yes
    4. 在src下创建文件夹assets,并在其下创建plugin
    5. 在plugin下创建angular,bootstrap,jquery文件夹,用来存放他们的js文件
### 2.使用bower安装需要用到的bootstrap,jquery等依赖
#### 使用 bower init 命令初始化
```
lvlaymac:client maggie$ bower init
?name tms_client
? description 
? main file index.js
? keywords 
? authors jaune
? license MIT
? homepage 
? set currently installed components as dependencies? Yes
? add commonly ignored files to ignore list? Yes
? would you like to mark this package as private which prevents it from being accidentally published to the registry? No

{
  name: 'tms_client',
  description: '',
  main: 'index.js',
  authors: [
    'jaune'
  ],
  license: 'MIT',
  homepage: '',
  ignore: [
    '**/.*',
    'node_modules',
    'bower_components',
    'test',
    'tests'
  ]
}

? Looks good? Yes
```
#### 使用 bower install bootstrap -save  安装bootstrap和jquery的依赖, 导入angularjs的文件
    将bower_components下的jquery和bootstrap的js文件复制到src/assets/plugin的相应目录下
    将angular的js文件复制到对应目录中
    
#### 使用HTML5 Boilerplate创建脚手架首页
    1. 使用WebStorm创建一个AngularJS项目项目名任意
    2. 将新项目中创建的index.html复制到client项目的src项目下
    3. 打开这个index.html删除不必要的连接,添加引入jquery,angular和bootstrap的链接
    
### 3.认识CoffeeScript
    1. 使用cnpm install coffee-script -g 安装CoffeeScript编译环境
    2. 使用 cnpm install --save-dev coffee-script再次本地安装
    3. 编写coffeescript代码,注意严格缩进
### 4.使用Gulp前端自动化构建工具
#### 安装Gulp
     1. 使用cnpm install gulp -g 全局安装
     2. 使用cnpm install --save-dev gulp 本地安装
#### 编写Gulp的任务脚本
     1. 在client项目根目录下新建coffee文件gulpfile.coffee
     2. 打开该文件,编写任务内容如下
```
gulp=require('gulp')
del=require('del')
runSequence = require('run-sequence')
uglify=require('gulp-uglify')
minifyCss=require('gulp-minify-css')
#unCss = require('gulp-uncss')
browserSync = require('browser-sync').create()

# task指定任务 第一个参数是任务名称,名称是default就是默认任务(任务的入口),第2个参数就是要执行的任务回调函数
gulp.task('default',(callback)->
   runSequence(['clean'],['build'],['server','watch'],callback)
)

gulp.task('clean',(callback)->
  del(['./dist'],callback)
)

gulp.task('build',(callback)->
  runSequence(['copy'],['minijs'],['minicss'],callback)
)

gulp.task('copy',->
  gulp.src('./src/**/*.*')
  .pipe(gulp.dest('./dist/'))
)

gulp.task('minijs',->
  gulp.src('./src/**/*.js')
  .pipe(uglify())
  .pipe(gulp.dest('./dist/'))
)
gulp.task('minicss',->
  gulp.src('./src/**/*.css')
  .pipe(minifyCss())
 # .pipe(unCss())
  .pipe(gulp.dest('./dist/'))
)

gulp.task('concat',->
  gulp.src('./src/*.js')
  .pipe(concat('all.js',{newLine:';\n'}))
  .pipe(gulp.dest('./dist/'))
)

gulp.task('server', ->
   browserSync.init({
     server:{

       baseDir:'./dist/'
     }
     port:7411

   })
)

#监视文件是否改变
gulp.task('watch',->
  gulp.watch('./src/**/*.*',['reload'])
)

#把上面的任务再做一次
gulp.task('reload',(callback)->
   runSequence(['copy','minijs','minicss'],['reload-browser'],callback)
)

gulp.task('reload-browser',->
   browserSync.reload()
)
```
#### 依次安装上面使用的Gulp插件
  1. 运行命令cnpm install gulp-uglify gulp-minify-css gulp-uncss del --save-dev
  2. 运行命令 cnpm install browser-sync --save-dev --msvs_version=2008
  3. 运行命令 cnpm install run-sequence --save-dev
  安装任务队列插件 这个插件可以执行我们的task任务,并且可以指定任务的执行顺序

#### 运行gulpfile文件查看运行结果

#### 选中生成的dist文件 右键菜单Mark Directory as 选中Excluded


## 二.后端node服务器搭建
####  1.建立项目文件夹结构
    1.进入server文件夹 运行npm init初始化项目
    2.使用express-generator创建express脚手架项目
       运行 express src 命令
    3.使用WebStorm打开server项目,将src文件夹中的package.json复制到server根目录下
    4.运行cnpm install --save安装依赖
    5.运行 npm install --save-dev coffee-script 安装本地coffee环境
    6.将bin/www文件复制到src目录下 删除bin文件夹
    7.创建config目录  创建libs文件夹
    8.将src目录下的app.js移动到libs文件夹下
    9.在config文件加下创建config.coffee文件, 内容如下
```
module.exports ={
   port:7410
}
```
    10.改写www文件为www.coffee格式,完成后代码如下
```
#!/usr/bin/env node


app = require('./libs/app')
debug = require('debug')('src:server')
http = require('http')
config = require('./config/config')

port = config.port;
console.log("port="+port);
app.set('port', port);


server = http.createServer(app);

onListening = ()->
  addr = server.address()
  if typeof addr is 'string'
    bind = 'pipe ' + addr
  else
    bind =  'port ' + addr.port
  console.log(bind);
  debug('Listening on ' + bind)


onError=(error)->
   if error.syscall isnt 'listen'
        throw error
   if typeof port is 'string'
     bind = 'Pipe ' + port
   else
     bind = 'Port ' + port

#handle specific listen errors with friendly messages
   switch (error.code)
     when 'EACCES'
       console.error(bind + ' requires elevated privileges')
       process.exit(1)
       break
     when 'EADDRINUSE'
       console.error(bind + ' is already in use')
       process.exit(1)
       break;
     else
       throw error;

server.listen(port)
server.on('error', onError)
server.on('listening', onListening)

```

    11.改写libs\app.js为coffee格式
```
express = require('express')
path = require('path')
logger = require('morgan')
bodyParser = require('body-parser')

apiRouters = require('./../routes/api')

app = express()
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: false}))

console.log('进来了');
app.use('/api', apiRouters)

# catch 404 and forward to error handler
app.use((req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)
)

# error handler
app.use((err, req, res, next) ->
# set locals, only providing error in development
  res.locals.message = err.message;
  if req.app.get('env') is 'development'
    res.locals.error = err
  else
    res.locals.error = {}

#render the error page
  res.status(err.status || 500)
  res.send('error')
)

module.exports = app;

```
#### 2.创建api路由文件
    1.在routes文件夹下创建api.coffee文件
```
express = require('express');
router = express.Router();

router.get('/faq', (req, res, next) ->
  res.send('I am fine  你好吗');
)
module.exports = router;
```
#### 2.使用Gulp构建后端项目
    1.在项目根目录下新建gulpfile.coffee文件
```
gulp = require('gulp')
del = require('del')
runSequence = require('run-sequence')
developServer = require('gulp-develop-server')
notify = require('gulp-notify')

gulp.task('default',(callback)->
   runSequence(['clean'],['copy'],['server','watch'],callback)
)

gulp.task('clean',(callback) ->
  del('./dist/',callback)
)


gulp.task('copy', ->

  gulp.src('./src/**/*.js')
  .pipe(gulp.dest('./dist/'))
)

gulp.task('server',->

  developServer.listen({
    path:'./dist/www.js'
  })
)

gulp.task('watch', ->
  gulp.watch('./src/**/*.js',['reload'])
)

gulp.task('reload',(callback) ->

     runSequence(['copy'],['reload-node'],callback)
)

gulp.task('reload-node', ->
   developServer.restart()
   gulp.src('./dist/www.js')
   .pipe(notify('Server restarted'))
)
```
    2.安装所需要的依赖
```
    cnpm install gulp --save-dev
    cnpm install gulp-develop-server --save-dev
    cnpm install del --save-dev
    cnpm install run-sequence --save-dev
    cnpm install gulp-notify --save-dev
```

## 三.项目功能编写
### 1.登陆注册设计
#### 1.1 路由搭建
    1.复制angular-route.js到src/assets/angular下
    2.在src下新建文件夹app/login
    3.在src/app/login下新建 login.html和loginCtrl.coffee两个文件
    4.编写index.coffee文件如下
```
angular.module('tmsApp', ['ngRoute'])
.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/login', {

    templateUrl: '/app/login/login.html',
    controller: 'LoginCtrl'

  })
])
.run(['$location',($location) ->
    $location.path('/login').replace()
])
```
    5.在index.html文件中加入js文件的引用 注意引用顺序
```
<script src="/assets/plugin/jquery/jquery.js"></script>
<script src="/assets/plugin/angular/angular.js"></script>
<script src="/assets/plugin/angular/angular-route.js"></script>
<script src="/index.js"></script>
<script src="/app/login/loginCtrl.js"></script>

```
    6.编写login.coffee文件如下
```
angular.module('tmsApp')
       .controller('LoginCtrl',['$scope',($scope) ->

])
```
####1.2登录界面实现
#####1.2.1登陆界面左右分栏
    0.安装gulp-concat插件 cnpm install gulp-concat --save-dev
    1.修改gulpfile.coffee文件,添加合并css文件的代码
```
#在引入部分加入
concat = require('gulp-concat')

#找到task('minicss')任务修改如下
gulp.task('minicss',->
  gulp.src('./src/**/*.css')
  .pipe(minifyCss())
  .pipe(concat('app.css',{newLine:'\n\n'}))
 # .pipe(unCss())
  .pipe(gulp.dest('./dist/assets/css/'))
)
```
    1.修改login.html模板如下
```
<div class="login-container">
    <div class="login-left">aaa</div>
    <div class="login-split"></div>
    <div class="login-right">bbb</div>
</div>
```
    2.在src/css下新建login.css
```
.login-container{
    width:80%;
    margin:0 auto;
    margin-top: 50px;
    display: flex;
}

.login-left,.login-right{
     float:left;
     height: 500px;
    border:1px solid red;
}

.login-left{
    flex: 6;
    margin-right: 50px;
}
.login-split{
    flex:1;
}

.login-right{
    flex:3;
}
```
    
    3.在index.html文件中加入引入app.css文件代码
```
    <link rel="stylesheet" href="assets/css/app.css">

```
    4.修改右部区域如下
```

    <div class="login-right">
        <fieldset>
            <legend>登陆</legend>
            <div>
                <label for="">用户名:</label>
                <input type="text" placeholder="请输入用户名">
            </div>
            <div>
                <label for="">密码:</label>
                <input type="text" placeholder="请输入密码">
            </div>
            <div>

                <label><input type="checkbox">记住我</label>
            </div>
            <div>
                <button>登陆</button>
                <span>我要<a href="/register">注册</a></span>
            </div>
        </fieldset>
    </div>
```
#####1.2.2 修改loginCtrl.coffee如下
   
```
    angular.module('tmsApp')
      .controller('LoginCtrl',['$scope',($scope) ->
          $scope.userEntity={
            username:'',
            password:''
          }
          $scope.rememberMe =false;
          $scope.doLogin= ->
            console.log($scope.userEntity);
    
      ])
```
#####1.2.3在登陆页面绑定数据

####1.3注册界面实现
#####1.3.1 创建注册页面和注册的控制器
    1.在src/app下创建regist文件夹
    2.在regist文件夹下新建注册页面index.html内容如下
```
<div class="login-container">
    <div class="login-left">aaa</div>
    <div class="login-split"></div>
    <div class="login-right">
        <fieldset>
            <legend>注册新账户</legend>
            <div>
                <label for="">用户名:</label>
                <input type="text" ng-model="userEntity.username" placeholder="请输入用户名">
            </div>
            <div>
                <label for="">密码:</label>
                <input type="text" ng-model="userEntity.password" placeholder="请输入密码">
            </div>
            <div>
                <label for="">确认密码:</label>
                <input type="text" ng-model="userEntity.password2" placeholder="请输入密码">
            </div>
            <div>
                <button ng-click="doReg()">注册</button>
                <span>已有账户<a href="#/login">登陆</a></span>
            </div>
        </fieldset>
    </div>
</div>
```
    3.在regist文件夹下新建控制器registCtrl.coffee,内容如下
```
angular.module('tmsApp')
  .controller('registCtrl',['$scope',($scope) ->
      $scope.userEntity={
              username:'',
              password:'',
              password2:'',
      }
      $scope.doReg= ->
        console.log($scope.userEntity)


])
```
    4.在首页index.html中引入注册的控制器文件
```
<script src="/app/regist/registCtrl.js"></script>

```
    5.在index.coffee中添加注册的路由如下
```
  $routeProvider.when('/login', {

    templateUrl: '/app/login/index.html',
    controller: 'LoginCtrl'

  }).when('/regist',{
    templateUrl: '/app/regist/index.html',
    controller: 'RegistCtrl'
  })
```
####1.4使用bootstrap美化登陆注册页面
#####1.4.1 在首页的主容器div中添加contain样式
```
   <div class="view-container"  ng-view></div>
```
#####1.4.2 修改登陆页面login/index.html如下
```
<div class="row login-box">
    <div class="col-md-4 col-md-offset-4">
        <div class="panel panel-info">
            <div class="panel-heading">登陆</div>
            <div class="panel-body">
                <form action="">
                    <div class="form-group">
                        <label for="">用户名:</label>
                        <input type="text" class="form-control" ng-model="userEntity.username" placeholder="请输入用户名">
                    </div>
                    <div class="form-group">
                        <label for="">密码:</label>
                        <input type="password" class="form-control" ng-model="userEntity.password" placeholder="请输入密码">
                    </div>
                    <div class="form-group">
                        <label><input type="checkbox" ng-model="rememberMe">记住我</label>
                    </div>
                    <div class="form-group">
                        <div class="col-md-4 col-md-offset-4">
                            <button class="btn btn-primary" style="width:100%" ng-click="doLogin()">登陆</button>
                        </div>
                        <div class="login-tip-box">
                            <span>我要<a href="#/regist">注册</a></span>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>

</div>

```
#####1.4.3 修改注册页面regist/index.html
```
<div class="row login-box">
    <div class="col-md-4 col-md-offset-4">
        <div class="panel panel-info">
            <div class="panel-heading">欢迎注册</div>
            <div class="panel-body">
                <form action="">
                    <div class="form-group">
                        <label for="">用户名:</label>
                        <input type="text" class="form-control" ng-model="userEntity.username" placeholder="请输入用户名">
                    </div>
                    <div class="form-group">
                        <label for="">密码:</label>
                        <input type="password" class="form-control" ng-model="userEntity.password" placeholder="请输入密码">
                    </div>
                    <div class="form-group">
                        <label for="">确认密码:</label>
                        <input type="password" class="form-control" ng-model="userEntity.password2" placeholder="请输入密码">
                    </div>
                    <div class="form-group">
                        <div class="col-md-4 col-md-offset-4">
                            <button class="btn btn-primary" style="width:100%" ng-click="doReg()">注册</button>
                        </div>
                        <div class="login-tip-box">
                            <span>我要<a href="#/login">登陆</a></span>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>

</div>

```
#####1.4.4 修改css/login.css如下
```
.login-box{
    margin-top:50px;
}
.login-tip-box{
    font-size:12px;
    line-height: 34px;
}
```

### 2.主页设计
####2.1添加主页路由
#####2.1.1添加主页文件
    1.在app目录新建index文件夹
    2.在index文件夹中新建页面index.html
    3.在index文件夹中新建控制器文件indexCtrl.coffee
```
angular.module('tmsApp')
  .controller('IndexCtrl',['$scope','$rootScope','$location',($scope,$rootScope,$location) ->
   1

  ])
```
    4.在首页index.html中添加引用主页控制器
```
<script src="/app/index/indexCtrl.js"></script>

```
    5.修改登陆的控制器,添加登陆成功的逻辑
```
angular.module('tmsApp')
  .controller('LoginCtrl',['$scope','$location',($scope,$location) ->
      $scope.userEntity={
        username:'',
        password:''
      }
      $scope.rememberMe =false;
      $scope.doLogin= ->
        console.log($scope.userEntity)
        $location.path('/').replace()

  ])
```
    6.在index.coffee文件中添加主页路由
```
.when('/',{
    templateUrl: '/app/index/index.html',
    controller: 'IndexCtrl'
  })
```

####2.2建立主页框架
#####2.2.1修改主页文件index/index.html如下
```
<div>
    <div class="task-container">
        <div class="col-md-2">
            <div class="panel panel-info">
                <div class="panel-heading">Task1</div>
                <div class="panel-body">xxx</div>
            </div>
        </div>
    </div>
    <div class="slide-right">

    </div>

</div>
```
#####2.2.2在css文件夹下新增index.css如下
```
.slide-right{
    width:300px;
    position: fixed;
    top:0;
    bottom: 0;
    right:0;
    border: 1px solid red;
}
```
####2.3完善主页页面/app/index/index.html
#####2.3.1修改/app/index/index.html 如下
```
<div>
    <div class="task-container col-md-8 col-xs-8 no-padding-left padding-right-sm">
        <div class="panel panel-primary">
            <div class="panel-heading">便签
                <button class="btn btn-danger btn-xs pull-right">
                    <i class="glyphicon glyphicon-plus"></i>
                </button>
            </div>
            <div class="panel-body"></div>
        </div>
    </div>
    <div class="slide-right col-md-4 col-xs-8 no-padding-right padding-left-sm">
        <div class="panel panel-primary">
            <div class="panel-heading">任务面板</div>
            <div class="panel-body">

            </div>
        </div>
    </div>
</div>
```
#####2.3.2修改index.css如下
```
.task-container,
.slide-right{
    height: 100%;
    position: fixed;
}
.task-container > .panel,
.slide-right > .panel{
    height: 100%;
}
.slide-right{
    right: 0;
}
.no-padding-left{
    padding-left: 0;
}
.no-padding-right{
    padding-right: 0;
}
.padding-left-sm{
    padding-left: 5px;
}
.pandding-right-sm{
    padding-right: 5px;
}
```
#####2.3.3 重新构建gulp任务,规划js和css文件的合并
    1.在client根目录下新建assets.json文件,配置合并文件的路径
```
{
  "assetsJs": [
    "./src/assets/plugins/jquery/jquery.js",
    "./src/assets/plugins/bootstrap/js/bootstrap.js",
    "./src/assets/plugins/angular/angular.js",
    "./src/assets/plugins/angular/angular-*.js"
  ],
  "assetsCss": [
    "./src/assets/plugins/bootstrap/css/bootstrap.css"
  ],
  "assetsFonts": [
    "./src/assets/plugins/bootstrap/fonts/*.*"
  ],
  "appJs": [
    "./src/index.js",
    "./src/app/**/*.js"
  ],
  "appCss": [
    "./src/css/*.css"
  ]
}
```
    2.修改gulp任务文件gulpfile.coffee文件如下
```

fs = require('fs')
gulp = require('gulp')
runSequence = require('run-sequence')
del = require('del')
uglify = require('gulp-uglify')
concat = require('gulp-concat')
minifyCss = require('gulp-minify-css')
# unCss = require('gulp-uncss')
browserSync = require('browser-sync').create()

# 读取assets.json文件
assets = JSON.parse(fs.readFileSync('assets.json'))

# 默认构建任务
gulp.task('default',(callback) ->
  runSequence(['clean'], ['build'], ['serve', 'watch'], callback)
)

gulp.task('clean', (callback)->
  del(['./dist/'], callback)
)

gulp.task('build', (callback) ->
  runSequence(
    ['assetsJs', 'assetsCss', 'assetsFonts'],
    ['appJs', 'appCss', 'copyHtml'],
    callback
  )
)

# 合并所有的第三方js文件为assets.js
gulp.task('assetsJs', ->
  gulp.src(assets.assetsJs)
  .pipe(concat('assets.js', {newLine: ';\n'}))
  .pipe(gulp.dest('./dist/assets/js/'))
)

#合并所有的第三方css文件为assets.css文件
gulp.task('assetsCss', ->
  gulp.src(assets.assetsCss)
  .pipe(concat('assets.css', {newLine: '\n\n'}))
  .pipe(gulp.dest('./dist/assets/css/'))
)
#合并字体文件
gulp.task('assetsFonts', ->
  gulp.src(assets.assetsFonts)
  .pipe(gulp.dest('./dist/assets/fonts/'))
)

# 拷贝所有的html目录到dist目录下

gulp.task('copyHtml', ->
  gulp.src(['./src/**/*.html'])
  .pipe(gulp.dest('./dist/'))
)
#合并我们所有自己写的js为app.js
gulp.task('appJs', ->
  gulp.src(assets.appJs)
  .pipe(concat('app.js', {newLine: ';\n'}))
  .pipe(gulp.dest('./dist/assets/js/'))
)
#合并我们所有自己写的css文件为app.css
gulp.task('appCss', ->
  gulp.src(assets.appCss)
  .pipe(concat('app.css', {newLine: '\n\n'}))
  .pipe(gulp.dest('./dist/assets/css/'))
)

gulp.task('serve', ->
  browserSync.init({
    server: {
      baseDir: './dist/'
    }
    port: 7411
  })
)

gulp.task('watch', ->
  gulp.watch('./src/**/*.*', ['reload'])
)

gulp.task('reload', (callback)->
  runSequence(['build'], ['reload-browser'], callback)
)

gulp.task('reload-browser', ->
  browserSync.reload()
)

```
    3.修改index.html里的css文件和js文件的引入
```
<link rel="stylesheet" href="/assets/css/assets.css">
<link rel="stylesheet" href="/assets/css/app.css">

<script src="/assets/js/assets.js"></script>
<script src="/assets/js/app.js"></script>

```
####2.4编写任务面板
#####2.4.1 修改app/index/index.html如下
```
<div>
    <div class="task-container col-md-8 col-sm-7 no-padding-left padding-right-sm hidden-xs">
        <div class="panel panel-primary">
            <div class="panel-heading">便签
                <button class="btn btn-danger btn-xs pull-right">
                    <i class="glyphicon glyphicon-plus"></i>
                </button>
            </div>
            <div class="panel-body"></div>
        </div>
    </div>
    <div class="slide-right col-md-4 col-sm-5 col-xs-12 no-padding-right padding-left-sm">
        <div class="panel panel-primary">
            <div class="panel-heading">任务面板</div>
            <div class="panel-body">
                <div class="task-part">
                    <form ng-submit="addTask();">
                        <input type="text" class="form-control" placeholder="需要做什么？" required ng-model="task.description"/>
                    </form>
                    <table class="table table-striped table-bordered table-hover task-list">
                        <tr ng-repeat="task in taskList track by $index">
                            <td class="text-center task-check no-padding-left no-padding-right">
                                <input type="checkbox" ng-model="task.checked"/></td>
                            <td ng-class="{'task-completed': task.checked}">{{task.description}} </td>
                            <td class="text-center task-operate no-padding-left no-padding-right">
                                <div class="btn-group">
                                    <button class="btn btn-info btn-xs">编辑</button>
                                    <button class="btn btn-danger btn-xs">删除</button>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
```
#####2.4.2修改/css/index.css如下
```
.task-container,
.slide-right{
    height: 100%;
    position: fixed;
}
.task-container > .panel,
.slide-right > .panel{
    height: 100%;
}
.slide-right{
    right: 0;
}
.no-padding-left{
    padding-left: 0 !important;
}
.no-padding-right{
    padding-right: 0 !important;
}
.padding-left-sm{
    padding-left: 5px;
}
.pandding-right-sm{
    padding-right: 5px;
}

.task-list .task-check{
    width: 20px;
}
.task-list .task-operate{
    width: 80px;
}
.task-list .task-completed{
    text-decoration: line-through;
    color: lightgray;
}

@media( max-width: 767px){
    .padding-left-sm{
        padding-left: 0;
    }
}

```
#####2.4.3 修改/app/index/index.coffee如下
```
angular.module('tmsApp')
.controller('IndexCtrl', ['$scope', '$location', '$rootScope', ($scope, $location, $rootScope) ->
# scope添加任务对象
  $scope.task = {
    description: ''
  }
  $scope.taskList = []

  # UI添加任务对象
  $scope.addTask = ->
    task = angular.copy($scope.task)
    task.checked = false
    task.status = 'InProgress'
    $scope.taskList.push(task)
    $scope.task.description = ''
])
```





    
