// Generated by CoffeeScript 1.12.4
(function() {
  var db, isPwdEq, isUserExist, jwt, login, logout, regist;

  db = require('./../libs/db');

  jwt = require('jsonwebtoken');

  regist = function(req, res, next) {
    var body, postData;
    body = req.body;
    console.log(body);
    if (!body || !body.username || !body.password) {
      return next(new Error('请提交用户注册数据'));
    }
    postData = {
      username: body.username,
      password: body.password,
      token: '',
      expiredTime: Date.now()
    };
    db.users.insert(postData, function(err, user) {
      if (err) {
        return next(err);
      }
      return res.json(true);
    });
  };

  isPwdEq = function(req, res, next) {
    if (req.body.password !== req.body.password2) {
      return next(new Error('两次密码不一致'));
    }
    return next();
  };

  isUserExist = function(req, res, next) {
    return db.users.findOne({
      username: req.body.username
    }, function(err, user) {
      if (err) {
        return next(err);
      }
      if (user) {
        return next(new Error('用户名已存在'));
      }
      return next();
    });
  };

  logout = function(req, res, next) {
    var token;
    token = req.headers['x-token'];
    return db.users.update({
      token: token
    }, {
      $set: {
        token: '',
        expiredTime: Date.now()
      }
    }, function(err, num) {
      if (err) {
        return next(err);
      }
      if (num === 0) {
        return next(new Error("注销失败"));
      }
      return res.json(true);
    });
  };

  login = function(req, res, next) {
    var password, username;
    console.log('处理登陆');
    username = req.body.username;
    password = req.body.password;
    return db.users.findOne({
      username: username,
      password: password
    }, function(err, user) {
      var expiredTime, token;
      if (err) {
        return next(err);
      }
      if (!user) {
        return next(new Error('用户名或密码错,请重新登陆'));
      }
      token = jwt.sign({
        username: username
      }, 'lvlay');
      expiredTime = Date.now() + 24 * 60 * 60 * 1000;
      return db.users.update({
        _id: user._id
      }, {
        $set: {
          token: token,
          expiredTime: expiredTime
        }
      }, function(err, num) {
        if (err) {
          return next(err);
        }
        if (num === 0) {
          return next(new Error("服务器正忙,请稍后再试"));
        }
        return res.json({
          token: token
        });
      });
    });
  };

  module.exports = {
    regist: regist,
    login: login,
    isUserExist: isUserExist,
    isPwdEq: isPwdEq,
    logout: logout
  };

}).call(this);

//# sourceMappingURL=userBiz.js.map
