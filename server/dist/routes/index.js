// Generated by CoffeeScript 1.12.4
(function() {
  var db, express, router;

  express = require('express');

  db = require('./../libs/db');

  router = express.Router();

  router.get('/hello', function(req, res, next) {
    return db.users.insert({
      username: 'tom'
    }, function(err, user) {
      if (err) {
        return next(err);
      }
      console.log(user);
      res.json(user);
    });
  });

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
