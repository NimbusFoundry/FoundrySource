// Generated by CoffeeScript 1.8.0
(function() {
  define('core/admin', function() {
    var admin_base_url, api, authAdmin, getUserCount;
    admin_base_url = 'https://apps-apis.google.com/a/feeds/domain/2.0/';
    authAdmin = function() {};
    getUserCount = function(domain, callback) {
      var des;
      des = admin_base_url + domain.name + '/general/currentNumberOfUsers';
      return $.ajax({
        url: des,
        success: function(data) {
          console.log(data);
          if (callback) {
            return callback(data);
          }
        }
      });
    };
    return api = {
      get_user_count: function(d, c) {
        return getUserCount(d, c);
      },
      auth: function() {
        return console.log('auth the api or not');
      }
    };
  });

}).call(this);
