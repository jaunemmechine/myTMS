// Generated by CoffeeScript 1.12.4
(function() {
  var db, express, router, userBiz;

  express = require('express');

  db = require('./../libs/db');

  userBiz = require('./../biz/userBiz');

  router = express.Router();

  router.post('/user/regist', userBiz.isPwdEq, userBiz.isUserExist, userBiz.regist);

  router.post('/user/login', userBiz.login);

  router.post('/user/logout', userBiz.logout);

  module.exports = router;

}).call(this);

//# sourceMappingURL=user.js.map