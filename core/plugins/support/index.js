// Generated by CoffeeScript 1.8.0
(function() {
  var define_controller;

  define('support', function() {
    return {
      name: 'support',
      title: 'Support',
      anchor: '#/support',
      type: 'plugin',
      icon: 'icon-info-sign',
      order: -15,
      init: function() {
        return foundry.initialized(this.name);
      },
      inited: function() {
        return define_controller();
      }
    };
  });

  define_controller = function() {
    var moduleName;
    moduleName = 'foundry';
    if (!foundry) {
      moduleName = 'foundry';
    }
    return angular.module(moduleName).controller('SupportController', [
      '$scope', '$foundry', function($scope, $foundry) {
        var defaultEmail;
        defaultEmail = 'admin@nimbusfoundry.com';
        return $scope.createTicket = function() {
          var ccEmails, emails, msg, template;
          msg = $scope.newTicket;
          $scope.newTicket = '';
          emails = [];
          if (foundry.supportEmail) {
            emails = foundry.supportEmail.split(',');
          } else {
            emails.push('release@nimbusbase.com');
          }
          Nimbus.Share.add_share_user_real(emails[0], function(user) {
            var data;
            console.log(user);
            data = {
              'id': user.id,
              'email': emails[0],
              'name': user.name,
              'role': 'Admin'
            };
            if (!foundry._user_list[user.id]) {
              return foundry._user_list[user.id] = data;
            }
          });
          template = "<table style='border-collapse:collapse;width:100%;'> <tr> <td style='background: #1fa086;color: #fff;padding: 10px;border: 1px solid #1fa086;width:20%;border-bottom-color:#ddd;'>Workspace Name</td> <td style='border:1px solid #ddd; padding-left: 20px;'>" + Nimbus.realtime.c_file.title + "</td> </tr> <tr> <td style='background: #1fa086;color: #fff;padding: 10px;border: 1px solid #1fa086;width:20%;border-bottom-color:#ddd;'>Workspace Owner</td> <td style='border:1px solid #ddd; padding-left: 20px;'>" + foundry._current_owner.email + "</td> </tr> <tr> <td style='background: #1fa086;color: #fff;padding: 10px;border: 1px solid #1fa086;width:20%;border-bottom-color:#ddd;'>Support Subject</td> <td style='border:1px solid #ddd; padding-left: 20px;'>" + msg + "</td> </tr> </table>";
          ccEmails = emails.slice(1).reduce(function(a, b) {
            var s;
            s = '';
            if (a) {
              s = "" + a + ", '" + (b.split('@')[0]) + "' <" + b + ">";
            } else {
              s = "" + (b.split('@')[0]) + "' <" + b + ">";
            }
            return s;
          }, '');
          $foundry.gmail('Forum Support', emails[0], template, ccEmails);
          $('#notification').slideDown().delay(3000).slideUp();
        };
      }
    ]);
  };

}).call(this);
