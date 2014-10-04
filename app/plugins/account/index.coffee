define('account',(require)->
  doc_plugin=
    type : 'plugin'
    title : 'Account'
    anchor : '#/account'
    _models : {}
    name : 'account'
    version : 1.0
    order : -14
    icon : 'icon-cog'
    init : ()->
      foundry.initialized(@name)
      # define controller 
      define_controller()
      return
)

define_controller = ()->
  angular.module('foundry').controller('AccountController', ['$scope', '$rootScope', '$foundry', '$filter', ($scope,$rootScope, $foundry, $filter)->
    $rootScope.breadcum = 'Account'
    $scope.current_user_role = foundry._user_list[foundry._current_user.id].role

    plan_to_usernumber = {
      0: "10",
      1: "25",
      2: "50",
      3: "infinite"
    }

    # set plan type
    $scope.get_plan = ()->
      foundry._owner_plan

    $scope.usernumber = plan_to_usernumber[foundry._owner_plan]
    $scope.users = Nimbus.keys(foundry._user_list).length

    #input: a number from 0-3 representing the plans
    #output: if the current plan is above or below this, this is for css classes to display the correct button
    $scope.is_current_plan = (plan)->
      if plan is $scope.get_plan()
        'current'
      else if plan > $scope.get_plan()
        'up'
      else
        'down'
    
    #email setting related stuff
    if not foundry.get_setting("email")?
      $scope.setting_email = true
    else
      $scope.setting_email = foundry.get_setting("email")

    #input: a true or false
    #output: The setting for the email to be sent or not is set to the status of true of false
    $scope.setting_email_change = (status)->
      console.log("called")
      foundry.set_setting("email", status)

    window.a_scope = $scope
  ])
