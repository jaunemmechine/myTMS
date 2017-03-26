// Generated by CoffeeScript 1.12.4
(function() {
  angular.module("myApp").factory('tmsUtils', [
    function() {
      var processHttpError;
      processHttpError = function(res) {
        var data;
        data = res.data;
        console.log("data=" + data);
        if (data.message) {
          return alert(data.message);
        }
      };
      return {
        processHttpError: processHttpError
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=tmsUtils.js.map
