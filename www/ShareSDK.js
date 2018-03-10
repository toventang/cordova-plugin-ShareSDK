var exec = require("cordova/exec");

module.exports = {
  oneKeyShare: function(args, success, error) {
    exec(success, error, "ShareSDK", "share", [args]);
  }
};
