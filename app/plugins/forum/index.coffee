define('forum', ['forum/components/components_loader'], (loader)->

  doc_plugin=
    type : 'plugin'
    title : 'Forum'
    anchor : '#/forum'
    _models : {}
    name : 'forum'
    version : 1.0
    forumModels : {}
    icon : 'icon-comment'
    ###
       These model fields are used for listing and ordering
       models. You don't need to add them to 'some_component/index.coffee'
       and they will be auto appended to component models
    ###
    default_model_fields : ["userid", "created_at", "timestamp"]
    init : ()->
      self = @

      models = [
        {name : "Topic", attrs : ["name", "link", "rss", 'file_id', "pinned", "comments", "text", "userid", 'attachment', "created_at", "timestamp"]},
        {name : "Link", attrs : ["name", "link", "rss", "comments", "pinned", "text", "userid", "created_at", "timestamp"]},
        {name : "Comment", attrs : ["name", "post_id", "content", "userid", "replies", 'attachment', "created_at", "timestamp"]}
        {name : 'Bookmark', attrs : ['post_id', 'user_id', 'create_date']}
      ]

      primaryChain = models.reduce (chain, currentModel)->
        init_model  = (config)->
          dtd = $.Deferred()
          foundry.model(config.name, config.attrs, (model)->
            self.forumModels[config.name] = model
            dtd.resolve()
          )
        chain.pipe(init_model(currentModel))
      , $.Deferred().resolve()

      primaryChain
      .pipe () -> 
        ###
          use JQuery deferred chain to load all models of 
          all components asynchronously
        ###
        chain = loader.components.reduce (deferredChain, currentComponent) ->
          deferredChain.pipe(loadComponentModel(currentComponent))
        , $.Deferred().resolve()
        # When all models are ready, tell foundry it is ok
        chain
        .pipe () -> foundry.initialized(self.name)
        .fail (error) -> console.err(error)
      .fail (error)-> console.log error

      return
    add_post : (data)->
      console.log 'adding post for other plugin'
      model = foundry._models.Topic
      model.create(data)
    my_posts : ()->
      console.log 'get all my own posts'

    # callback function after all plugin is inited
    inited: ()->
      # load post setting for current user - pinned posts

      # check for post to open 
      defineController(loader.components)

      # check if current user has rated this app or not?
      for user in foundry._models.User.all()
        if user.pid is foundry._current_user.id
          if !user.rated and foundry._models.Topic.all().length > 20
            # prompt for rating
            foundry._plugins.forum.prompt_rating()
            user.rated = true
            user.save()

          break

    # input : none
    # output : none
    # function : add two initial post to Forum 
    add_intial_post : ()->
      post_model = foundry._models.Topic
      data_welcome = 
        name : 'Welcome to Forum'
        text : '<b>Forum is a collaborative workspace where your team can:<br><br></b><ul><li>Share interesting links or news</li><li><b></b>Post discussion topics or ideas</li><li>Comment and reply to posts, creating an ongoing conversation</li><li>Upload and share files or documents to read and work on</li></ul><b>Forum<br><br></b>Forum is where all the action happens. This is where you can see all the posts and their relevant facts: who posted it, when it was posted and how many comments it has.<br><br><img src="http://i.imgur.com/CA1Bs1M.png" title="Image: http://i.imgur.com/CA1Bs1M.png"><br><br><b>With Forum, you can compose three types of posts:<br></b><br><ul><li>Links with titles</li><li>Posts with texts and pictures</li><li>Files uploaded from desktop or cloud</li></ul><b>Document<br><br></b>In the Document section, you and your team can upload files for the group to view or edit. The document section also lists any documents uploaded on the Forum.<br><br><b>Users<br><br></b><b></b>Here you can see all the members of the team who have access to the posts and documents in the current workspace. If you are an admin of the workspace, you can:<br><br><ul><li>Grant other users "admin" status</li><li>Add users simply by adding their emails</li><li>Delete users who are no longer part of the group with one simple click</li></ul><b>Workspace<br><br></b>Managing and community with different groups is painful. With Forum, it'+"'"+'s never been easier. Workspace allows users to divide their work into projects or teams, each one its own separate Workspace. Within each workspace, you can make posts on the forum, add users and upload documents. And if you want to go from one workspace to another, just click "Switch" and choose the next workspace.<br><br><b>Feedback and Questions<br><br></b>If you have any questions or want to leave feedback, you can email us at admin@nimbusbase.com. Thanks!<br><br>'
        rss: false
        userid: 10000
        created_at : Date().toString()
        timestamp : new Date().getTime()
      data_use = 
        name : 'Add Your Team to Forum!'
        text : '<div><b>Forum makes collaboration within a group or an organization easy. So let'+"'"+'s get the rest of the team on board!</b><br><br><b>1.&nbsp;First, you go to the "User" tab, where all the current users are displayed,&nbsp;and click "Add User":</b><img alt="" src="http://i.imgur.com/flnP6ES.png" title="Image: http://i.imgur.com/flnP6ES.png"><br><br><b>2. Next, you fill out the user form by adding the team member'+"'"+'s email and assigning the user as&nbsp;either an "Admin" or "Viewer". Admins can add or delete other users and edit other users'+"'"+' posts:</b><br><img alt="" src="http://i.imgur.com/YTVYmIC.png" title="Image: http://i.imgur.com/YTVYmIC.png"><br><br><b>3. Once you have added the user, the user gets a notification in his inbox that he has been added to the team and can view the workspace&nbsp;(in this case, the name of the workspace is "For Tutorial"):</b><br><img alt="" src="http://i.imgur.com/XI1dzeP.png" title="Image: http://i.imgur.com/XI1dzeP.png"><br><br><b>4. The user can access the workspace simply by clicking on the link and "Open with app":</b><br><img alt="" src="http://i.imgur.com/6oMiufU.png" title="Image: http://i.imgur.com/6oMiufU.png"><br><br><b>5. ..and voila! The user is added to the team and can start contributing posts and comments!:&nbsp;</b><br><img alt="" src="http://i.imgur.com/eQQbuB6.png" title="Image: http://i.imgur.com/eQQbuB6.png"><br></div>'
        rss: false
        userid: 10000
        created_at : Date().toString()
        timestamp : new Date().getTime()

      if !post_model.findByAttribute('name', data_welcome.name)
        @add_post(data_welcome)

      if !post_model.findByAttribute('name', data_use.name)
        @add_post(data_use)
    # prompt user for rating 
    # at chrome web store

    prompt_rating : ()->
      # save this for current user

      msg = "<div style='padding:20px 10px;'>Thanks for using Forum this far, hope you can rate us at Chrome Web Store, helps us make it better.</div>";
      bootbox.dialog(
        message : msg
        title : 'Rating please'
        className : 'nimbus_confirm_modal'
        buttons: 
          success : 
            label: "Rate it Now"
            className : 'btn-success'
            callback : (evt)->
              window.open('https://chrome.google.com/webstore/detail/forum/knpdbggaikbgjbgihfgefcjdabkhfgbp?utm_source=chrome-ntp-icon')
              bootbox.hideAll()
          cancel : 
            className : 'btn-danger'
            callback : (evt)->
              console.log 'go away'
              bootbox.hideAll()

      )
  ###
    input: component
    output: deferred object that can be added more asynchronous operations
    function: given a component, load all models related to it
  ###
  loadComponentModel = (component) ->
    component.models.reduce (deferredChain, currentModel) ->
      deferredChain.pipe () -> 
        dtd = $.Deferred()
        foundry.model(currentModel.name, currentModel.fields.concat(doc_plugin['default_model_fields']), () -> dtd.resolve())
    , $.Deferred().resolve()
      
  return doc_plugin
)
###
  input: components
  output: angular Forum controller
  function: define Forum Controller
    this function will be called in the 'inited' callback,
    replace
      "ForumController = (...) -> " 
    with
      "foundryModule.controller('ForumController',[..., ()->])"
    this will be good for future js minification

###
defineController = (components) -> 
  foundryModule = angular.module('foundry');
  foundryModule.controller('ForumController',['$scope', '$rootScope', '$foundry', '$filter' , ($scope, $rootScope, $foundry, $filter)->
    $rootScope.breadcum = 'Forums'
    $scope.topic_model = foundry._models.Topic
    $scope.link_model = foundry._models.Link
    $scope.comment_model = foundry._models.Comment

    $scope.searchPlaceHolder = "Search"
    ###
      add update handler for this
    ###
    for name,model of foundry._plugins['forum'].forumModels
      model.onUpdate((mode, obj, isLocal)->
        $scope.load()
        if !isLocal
          $scope.$apply()
      ) 

    ###
      init components in $scope
    ###
    $scope.components = components
    componentsMap = {}
    componentsMap[component.name] = component for component in components
    $scope.componentsMap = componentsMap
    
    ###
      input: component
      output: 
      function: init component scope

      under the Forum $scope, create private component scope for
      each component, and also add form config for each component
      to the Forum $scope, these form configs are used by the 
      'model-form' directive
    ###
    $scope.componentScope = {}
    initComponentScope = (component) -> 
      $scope.componentScope[component.name] = $scope.$new()
      component.formConfig.create = "componentCreator(componentsMap['#{component.name}'])()"
      component.formConfig.update = 'update()'
      component.formConfig.disabled = false
      $scope["#{component.name}_config"] = component.formConfig
      return

    initComponentScope component for component in components

    $scope.showing = false
    $scope.new_comment = ''
    $scope.comments = []

    $scope.current_user = current_user = foundry._current_user
    $scope.user_permission = foundry._models.User.findByAttribute('pid',current_user.id).role

    forum_module = foundry._plugins.forum
    ###
      input: none
      output: none
      function: check for owner if has initialized this
    ###
    check_for_forum_init = ()->
      owner_id = Nimbus.realtime.c_file.owners[0].permissionId
      user = foundry._models.User.findByAttribute('pid', owner_id)
      if !user.initied
        forum_module.add_intial_post()
        user.initied = 1
        user.save()

    check_for_forum_init()
    ###
    for upload post
    ###

    $scope.upload_post = null

    $scope.$watch('upload_post',(n, o)->
      if n
        # add spinner
        spinner = $foundry.spinner(
          type : 'loading'
          text : 'Uploading '
        )
        $scope.uplading_file = true

        #upload this to the cloud with document api
        Nimbus.Binary.upload_file(n,(f)->
          # update document plugin
          foundry._plugins.document.set(f._file.id, f._file)
          # end

          file = f._file
          html = '<div class="user_listing"><i class="file_thumb" style="background-image:url('+(file.thumbnailLink || file.iconLink)+');"></i><a href="'+file.webContentLink+'"><span class="name ng-binding">'+file.title+'</span></a></div>' 
          data =
            name : file.title
            rss : false
            file_id : file.id
            userid : foundry._current_user.id
            created_at : Date().toString()
            timestamp : new Date().getTime()
            text : html

          topic_model.create(data)
          $scope.uplading_file = false

          # hide spinner
          spinner.hide()
          $scope.load()
          $scope.$apply()
          return
        )
      return
    )


    ###
    comment with picture
    ###
    $scope.upload_comment = null
    $scope.uplading_file = false

    $scope.clear_input = ()->
      $scope.upload_comment = null

    ###
     pagination for post
    ###
    $scope.total_post    = 0
    $scope.current_page  = 1
    $scope.post_per_page = 15

    $scope.load_next_page = ()->
      if $scope.current_page * $scope.post_per_page < $scope.total_post
        $scope.current_page++
        $scope.load()

    $scope.load_next_search_page = () ->
      if $scope.currentSearchPage * $scope.post_per_page < $scope.total_search_post
        $scope.currentSearchPage++
        $scope.searchLoad()

    $scope.is_there_more_posts = ()->
      if $scope.inSearchMode is true
        return false
      $scope.current_page * $scope.post_per_page < $scope.total_post

    $scope.is_there_more_search_posts = () ->
      if $scope.inSearchMode is false
        return false
      else
        $scope.currentSearchPage * $scope.post_per_page < $scope.total_search_post
    #current model is the one displayed
    $scope.displayed_topic = {}

    $scope.change_display = (item, index) ->
      if $scope.topics.length is 0
        $scope.showing = false
        return 
      
      $scope.showing = true
      $scope.displayed_topic = $scope.topics[index]
      $scope.displayed_attachment = $scope.get_attachment($scope.displayed_topic.attachment)
      $scope.reply_mode = false
      
      $scope.current_index = index
      $scope.new_comment = ''
      $scope.get_topic_comment($scope.displayed_topic)

      # remove the attachment input
      $scope.upload_comment = null
      $('input.comment-image-input').replaceWith($('input.comment-image-input').val('').clone(true))

      ###
        if display changes to any component defined
        under the components structure, then call the component's 
        'onViewLoaded' callback and inject the 'displayed_topic' object
        to it's component scope
      ###
      component = findComponentByTopicModelInstanceInComponents($scope.displayed_topic)
      if component
        $scope.componentScope[component.name].displayed_topic = $scope.displayed_topic
        component.onViewLoaded.apply({},[$scope.componentScope[component.name]])        
      return
    $scope.navigateToTopic = (topic) ->
      target = 0
      for t, idx in $scope.topics
        target = idx if topic.id is t.id
      $scope.change_display(null, target)
    ###
      function : pin a post to make it displayed at the very top of the list
      input    : the post to be pinned
    ###
    $scope.pin_post = (post)->
      # check if the bookmark is there or not
      post.pinned = 1
      post.save()
      $scope.load()

    ###
      this is the opposite to pin a post
    ###
    $scope.unpin_post = (post)->
      post.pinned = undefined
      post.save()
      $scope.load()

    $scope.get_topic_comment = (topic)->
      # get comments from inside topic first
      # comments = topic.comments
      if topic
        comments = comment_model.findAllByAttribute('post_id',topic.id)
        # order
        $scope.comments = $filter('orderBy')(comments,'timestamp', true)

    $scope.get_topic_comment_count = (topic)->
      comments = comment_model.findAllByAttribute('post_id',topic.id)
      comments.length

    $scope.delete_comment = (index, comment)->
      comment.destroy()
      
      # reload comments
      $scope.get_topic_comment($scope.displayed_topic)

    $scope.comment_editable = (index)->
      # check is current user is the owner or admin
      console.log 'check permission'


    ###
      reply comment
    ###
    $scope.reply_mode = false
    $scope.reply_comment = (comment, index)->
      $scope.reply_mode = true
      $scope.current_comment = comment
      console.log 'reply this comment'
      # focus the comment box and add @ data
      if index>=0
        $scope.new_comment = '@'+comment.replies[index].name+': '
      else
        $scope.new_comment = '@'+comment.name+': '
      $('#comment_box').focus()
      return

    $scope.remove_reply = (index, comment)->
      comment.replies.splice(index,1)
      comment.save()

    ###
     load method for general
    ###
    topic_model = $scope.topic_model
    link_model = $scope.link_model
    comment_model = $scope.comment_model

    ###
      input: topic model instance
      output: component related to it
      function: one component only have one topic model
        find the component by topic model instance in components array,
        if it find nothing, then returns undefined
    ###
    findComponentByTopicModelInstanceInComponents = (instance) ->
      result = components.filter (component) ->
        return component.topicModel is instance.type
      result[0]

    $scope.normalLoad = ()->
      posts = topic_model.all()
      links = link_model.all()
      pins = foundry._models.Bookmark.all()

      # get topic model instances of all components
      topicModelInstances = components.reduce (instances, component) ->
        instances.concat(foundry._models[component.topicModel].all())
      , []

      $scope.total_post = posts.length + links.length + topicModelInstances.length
      # order all posts
      topics = $filter('orderBy')(posts.concat(links).concat(topicModelInstances),['pinned','-timestamp'])

      if Object.keys($scope.displayed_topic).length
        id = $scope.displayed_topic.id
        if $scope.displayed_topic.rss
          $scope.displayed_topic = link_model.findByAttribute('id', id)
        else if $scope.displayed_topic.file_id
          $scope.displayed_topic = topic_model.findByAttribute('id', id)
        else
          # reload topic model instance of current component
          component = findComponentByTopicModelInstanceInComponents($scope.displayed_topic)
          if component
            $scope.displayed_topic = foundry._models[component.topicModel].findByAttribute('id',id)
          else
            $scope.displayed_topic = topic_model.findByAttribute('id', id)
        # get topic comments
        $scope.get_topic_comment($scope.displayed_topic)

      to_show_post = null

      # pagination
      $scope.topics = topics.slice(0, $scope.current_page*$scope.post_per_page)
      # # change index
      # angular.forEach topics, (value, key) -> 
      #   mark = foundry._models.Bookmark.findByAttribute('post_id', value.id)
      #   if mark # and mark.user_id is foundry._current_user.id
      #     value.pinned = 1
      #     if $scope.displayed_topic.id is value.id
      #       $scope.displayed_topic.pinned = 1
          
      # topics = $filter('orderBy')(topics, ['pinned','-timestamp'])

      angular.forEach topics, (value, key) -> 
        # open topic defined in url
        if localStorage.to_open_topic and value.id is localStorage.to_open_topic
          to_show_post = value
          $scope.change_display(value, key)
          delete localStorage.to_open_topic

        if $scope.displayed_topic
          if value.id is $scope.displayed_topic.id
            $scope.current_index = key

      return
    
    $scope.searchLoad = ()->
      lastSearch = $scope.lastSearch
      $scope.lastSearch = $scope.keyword
      $scope.inSearchMode = true
      if lastSearch is ""
        if $scope.keyword is ""
          # first search, but search nothing
          $scope.inSearchMode = false
          return
      else if $scope.keyword is ""
        # return to the state before searching
        $scope.inSearchMode = false
        $scope.currentSearchPage = 1;
        $scope.normalLoad()        
        return
      unless lastSearch is $scope.keyword
        # performe a new keyword search not load more search results
        $scope.currentSearchPage = 1;
      posts = topic_model.all()
      links = link_model.all()
      pins = foundry._models.Bookmark.all()

      # get topic model instances of all components
      topicModelInstances = components.reduce (instances, component) ->
        instances.concat(foundry._models[component.topicModel].all())
      , []

      $scope.total_post = posts.length + links.length + topicModelInstances.length
      # order all posts
      orderedTopics = $filter('orderBy')(posts.concat(links).concat(topicModelInstances),['pinned','-timestamp'])
      topics = $filter('filter')(orderedTopics, (value) ->
        if value.name and value.name.toLowerCase().indexOf($scope.keyword.toLowerCase()) isnt -1
          return true
        else if value.text and $("<div/>").html(value.text).text().toLowerCase().indexOf($scope.keyword.toLowerCase()) isnt -1
          return true
        else 
          return false
      )
      $scope.total_search_post = topics.length
      if Object.keys($scope.displayed_topic).length
        id = $scope.displayed_topic.id
        if $scope.displayed_topic.rss
          $scope.displayed_topic = link_model.findByAttribute('id', id)
        else if $scope.displayed_topic.file_id
          $scope.displayed_topic = topic_model.findByAttribute('id', id)
        else
          # reload topic model instance of current component
          component = findComponentByTopicModelInstanceInComponents($scope.displayed_topic)
          if component
            $scope.displayed_topic = foundry._models[component.topicModel].findByAttribute('id',id)
          else
            $scope.displayed_topic = topic_model.findByAttribute('id', id)
        # get topic comments
        $scope.get_topic_comment($scope.displayed_topic)

      to_show_post = null

      # pagination
      $scope.topics = topics.slice(0, $scope.currentSearchPage*$scope.post_per_page)
      # # change index
      # angular.forEach topics, (value, key) -> 
      #   mark = foundry._models.Bookmark.findByAttribute('post_id', value.id)
      #   if mark # and mark.user_id is foundry._current_user.id
      #     value.pinned = 1
      #     if $scope.displayed_topic.id is value.id
      #       $scope.displayed_topic.pinned = 1
          
      # topics = $filter('orderBy')(topics, ['pinned','-timestamp'])

      angular.forEach topics, (value, key) -> 
        # open topic defined in url
        if localStorage.to_open_topic and value.id is localStorage.to_open_topic
          to_show_post = value
          $scope.change_display(value, key)
          delete localStorage.to_open_topic

        if $scope.displayed_topic
          if value.id is $scope.displayed_topic.id
            $scope.current_index = key

      return
    
    $scope.$watch('keyword', (newValue, oldValue) ->
      if newValue is "" and typeof oldValue is 'string' and oldValue.length>0
        $scope.searchLoad()
    )
    $scope.load = () ->
      if $scope.inSearchMode 
        $scope.searchLoad()
      else
        $scope.normalLoad()
    $scope.topic_data = {}
    
    $scope.inSearchMode = false;
    # watch search input
    $scope.currentSearchPage = 1
    $scope.lastSearch = ""
    
    $scope.topic_config = 
      fields: 
        name : 
          type : 'input'
          label : 'Name'
        text : 
          hide : 'topic_data.rss'
          label : 'Content'
          type : 'editor'
      create : 'submit()'
      update : 'update()'
      disabled : false
    # config for edit object
    $scope.topic_edit_config = {}
    angular.copy($scope.topic_config, $scope.topic_edit_config)

    ###
      for file type post    
    ###

    # config for file upload
    $scope.file_config = {}
    $scope.file_edit_config = {}
    
    angular.copy($scope.topic_config, $scope.file_config)
    delete $scope.file_config.fields['text']
    $scope.file_config.create = 'create_file()'
    $scope.file_config.update = 'update_file()'
    angular.copy($scope.file_config, $scope.file_edit_config)
    $scope.file_config.fields.attachment = 
      label : 'File'
      type : 'file'
      choosed : 'files_choosed()'


    $scope.files_choosed = (file)->
      # disable update button
      console.log file

    $scope.add_file_shortcut = (file)->
      # show file form
      $scope.topic_data = {}
      $scope.form_mode = 'create'
      $('.file_modal').modal()
      return

    $scope.create_file = ()->
      console.log 'creating..'
      spinner = $foundry.spinner(
        type : 'loading'
        text : 'Uploading... '
      )
      upload_attachment($scope.topic_data.attachment, (file)->
        $scope.topic_data.attachment = file.file_id
        $scope.submit()
        spinner.hide()
        $scope.$apply()
      )
      return
    $scope.update_file = ()->
      $scope.displayed_topic.save()
      $('.modal').modal('hide')
      return
    ###
      for link type post    
    ###

    # config for link type 
    $scope.link_config = 
      fields: 
        link : 
          label : 'Link'
          type : 'input'
        name : 
          type : 'input'
          label : 'Name'
      create : 'create_link()'
      update : 'update_link()'
      disabled : false

    $scope.add_shortcut = ()->
      $scope.topic_data = {}
      $scope.form_config = $scope.topic_config
      $scope.form_mode = 'create'
      $('.form').modal()
      postEditor = $(".form").find("textarea").data("wysihtml5").editor
      postEditor.composer.setHistory([postEditor.composer.getValue()])
      return  

    $scope.add_link_shortcut = ()->
      $scope.topic_data = {}
      $scope.form_config = $scope.link_config
      $scope.form_mode = 'create'
      $('.link_post').modal()
      return

    # watch for link input
    $scope.edit_shortcut = (displayed_topic)->
      $scope.form_mode = 'edit'
      if displayed_topic.rss
        $('.update_link').modal()
      else
        if displayed_topic.attachment
          # only show name no more
          $('.update_file').modal()
        else if component = findComponentByTopicModelInstanceInComponents(displayed_topic)
          # if editing topic model instance of any component
          # then show the modal according to the css class defined
          # in the 'some_component/index.coffee'
          $(".#{component.view.updateModal.cssClass}").modal()
          textarea = $(".#{component.view.updateModal.cssClass}").find("textarea")
          if textarea.length > 0 and typeof textarea.data("wysihtml5") isnt 'undefined'
            postEditor = textarea.data("wysihtml5").editor
            postEditor.composer.setHistory([postEditor.composer.getValue()])
        else
          $('.update').modal()
          postEditor = $(".update").find("textarea").data("wysihtml5").editor
          postEditor.composer.setHistory([postEditor.composer.getValue()])

          console.log 
      return      

    $scope.clear = ()->
      $('.modal').modal('hide')
      $scope.topic_data = {}
      $scope.load()

      # hide spinner or something

      return

    ###
      input: none
      ouput: none
      function: add post or file
    ###
    $scope.submit = ()->
      console.log("SUBMIT CALLED")
      x = $scope.topic_data
      x.rss = false
      x.userid = foundry._current_user.id
      x.created_at = Date().toString()
      x.timestamp = new Date().getTime()
      created_item = topic_model.create(x)
      x.id = created_item.id
      $scope.topic_data = {}

      if x.attachment
        x.attachment_link = foundry._plugins.document.get(x.attachment).webContentLink
        notify_other_user(3, x)
      else
        notify_other_user(1, x)
      
      $scope.load()
      $scope.navigateToTopic(created_item)
      $('.modal').modal('hide')

      # show rating for this user and also others
      user_model = foundry._models.User
      me = user_model.findByAttribute('pid', foundry._current_user.id)
      if topic_model.all().length>10 and !me.rated
        me.rated = true
        me.save()
        foundry._plugins.forum.prompt_rating()

      return

    ###
      input: none
      ouput: none
      function: add link
    ###
    $scope.create_link = ()->
      created_item = {'id':null}
      console.log("SUBMIT CALLED")
      x = $scope.topic_data
      x.rss = true
      x.userid = foundry._current_user.id
      x.created_at = Date().toString()
      x.timestamp = new Date().getTime()
      if x.link.indexOf('http') is -1
        x.link = 'http://'+x.link

      reset_content = ()->
        $scope.load()
        $scope.topic_data = {}
        $scope.navigateToTopic(created_item)
        $('.modal').modal('hide')

      # check if the name is typed or not
      if x.name
        x.id = link_model.create(x).id
        notify_other_user(2, x)
        reset_content()
      else
        # try retrieve link first and show spinner
        spinner = $foundry.spinner(
          type : 'loading'
          text : 'Fetching '
        )

        # listen for close event
        $('.close').on('click', (evt)->
          spinner.hide()
        )

        $foundry.rss(x.link, (data, error)->
          # fill in data
          if !error
            if $(data).find('encoded').text()
              x.text = $(data).find('encoded').text()
            else if $(data).find('content').length and $(data).find('content').eq(0).prop('tagName') isnt "media:content"
              x.text = $(data).find('content').text()
            else
              x.text = $(data).find('description').text()

            if !x.name 
              x.name = $(data).find('title:first').text()
          else
            # check the title for result
            # at least save the title
            x.name = data.title if data
          
          # save the data
          created_item = link_model.create(x)
          x.id = created_item.id
          notify_other_user(2, x)
          
          # hide the spinner
          spinner.hide()

          reset_content()
          $scope.$apply()
          return
        )
 
      return

    $scope.update_link = ()->
      # check the url is changed or not
      data = Object.getPrototypeOf($scope.displayed_topic)
      if $scope.displayed_topic.link isnt data.link
        # try retrieve link first and show spinner
        spinner = $foundry.spinner(
          type : 'loading'
          text : 'Fetching '
        )

        # listen for close event
        $('.close').on('click', (evt)->
          spinner.hide()
        )

        $foundry.rss($scope.displayed_topic.link, (data, err)->
          if !err
            if $(data).find('encoded').text()
              $scope.displayed_topic.text = $(data).find('encoded').text()
            else if $(data).find('content').length and $(data).find('content').eq(0).prop('tagName') isnt "media:content"
              $scope.displayed_topic.text = $(data).find('content').text()
            else
              $scope.displayed_topic.text = $(data).find('description').text()

            # change the title
            $scope.displayed_topic.name = $(data).find('title:first').text()
          else
            # dismiss and show error?
            # or just set the
            $scope.displayed_topic.name = data.name if data

            # what about the text field
            $scope.displayed_topic.text = ''

          # save the others
          $scope.displayed_topic.save()
          $scope.clear()

          spinner.hide()
          $scope.$apply()
        )
      else
        $scope.displayed_topic.save()
        $scope.clear()

    $scope.delete_topic =()->
      $scope.displayed_topic.destroy()
      $scope.topic_data = {}
      $scope.load()
      $scope.change_display(null, $scope.current_index)
      $('.modal').modal('hide')
      return


    ###
      input: type - the type of content, post or file or link
             data - the data object
      ouput: email notification to all other user
      function: send email to all other user 
    ###
    notify_other_user = (type, data)->
      email_data = 
        subject : 'Forum: '+data.name

      switch type
        when 1
          email_data.content = generate_post_template(data)
        when 2
          email_data.content = generate_link_template(data)
        when 3
          email_data.content = generate_file_template(data)

      $foundry.gmail(email_data.subject, 
                        foundry._current_user.email, 
                        email_data.content,
                        foundry._plugins.user.mail_list())

    ###
      input: data - the data object
      ouput: email notification to author
      function: send email to author
    ###
    notify_author = (data, email)->
      email_data = 
        subject : 'Forum Comment'
        content : generate_comment_template(data)

      $foundry.gmail(email_data.subject, 
                        email, 
                        email_data.content)

    ###
      input: data object with use email and comment content
      output: html strings
      function: generate html template for comment
    ###
    generate_comment_template = (data)->
      link = location.protocol+'//'+location.host+location.pathname+'?space='+Nimbus.realtime.c_file.id+'&topic='+$scope.displayed_topic.id
      style = 'padding:10px;margin:10px;background-color:#1fa086;color:#fff;border-radius:2px;display:inline-block;'
      style += 'text-decoration:none;'

      html = '<div style="padding:20px;border:1px solid #ddd;max-width:100%"><h3>'+$scope.displayed_topic.name+'</h3>'
      html += '<p style="color: #999;padding: 5px 2px;border-bottom: 1px solid #ddd;">Sent From: <span>' + foundry._current_user.name + ' in '+Nimbus.realtime.c_file.title+'</span><span style="float: right;">' + moment().format("YYYY-M-D") + '</span></p>';
      html += '<div style="max-width=100%">'+data.content+'</div>'
      html += '</div><center style="margin-top=20px"><a href="'+link+'" style="'+style+'">Open in Forum</a></center></div>'

    ###
      input: data object
      ouput: string
      function: generate template for post
    ###

    generate_post_template =(data)->
      link = location.protocol+'//'+location.host+location.pathname+'?space='+Nimbus.realtime.c_file.id+'&topic='+data.id
      style = 'padding:10px;margin:10px;background-color:#1fa086;color:#fff;border-radius:2px;display:inline-block;'
      style += 'text-decoration:none;'

      html = '<div style="max-width:100%"><div><h3>'+data.name+'</h3>'
       # additional javascript code to chnage the img url
      html += '<p style="color: #999;padding: 5px 2px;border-bottom: 1px solid #ddd;">Posted By: <span>' + foundry._current_user.name + ' in '+Nimbus.realtime.c_file.title+'</span><span style="float: right;">' + moment().format("YYYY-M-D") + '</span></p>';
      html += '<div class="nimbusbase-email-html" style="max-width=100%">'+data.text+'</div>'
      html += '</div><center style="margin-top=20px"><a href="'+link+'" style="'+style+'">Open in Forum</a></center></div>'
     
    ###
      input: none
      ouput: string
      function: generate template for link
    ###

    generate_link_template = (data)->
      html = '<div style="padding:30px 20px;border:1px solid #ddd;max-width:100%"><h3><a href="'+data.link+'">'+data.name+'</a></h3>'
      html += '<p style="color: #999;padding: 5px 2px;border-bottom: 1px solid #ddd;">Posted By: <span>' + foundry._current_user.name + ' in '+Nimbus.realtime.c_file.title+'</span><span style="float: right;">' + moment().format("YYYY-M-D") + '</span></p>';
      html += '<span class="source"><img src="'+$scope.get_link_favicon(data.link)+'" class="favicon" width="16" height="16" style="vertical-align: middle;"> from <strong>'+$scope.get_link_domain(data.link)+' ›</strong> </span>'
      html += "<div>#{data.text||''}</div>"
      html += '</div>'

    ###
      input: none
      ouput: string
      function: generate template for file
    ###

    generate_file_template = (data)->
      style = 'padding:10px;margin:10px;background-color:#1fa086;color:#fff;border-radius:2px;display:inline-block;'
      style += 'text-decoration:none;margin-left:0px;'

      html = '<div style="padding:30px 20px;border:1px solid #ddd;max-width:100%"><h3>'+data.name+'</h3>'
      html += '<p style="color: #999;padding: 5px 2px;border-bottom: 1px solid #ddd;">Posted By: <span>' + foundry._current_user.name + ' in '+Nimbus.realtime.c_file.title+'</span><span style="float: right;">' + moment().format("YYYY-M-D") + '</span></p>';
      html += '<span><a href="'+data.attachment_link+'" style="'+style+'">Click to Download</a></span>'
      html += '</div>'

    ###·
    
    methods for comments and reply
    1. upload_attachment to deal with picture uploading in comment

    2. comment action to add the real comment data to model

    3. add_comment is the ng-click hanlder
    ###

    upload_attachment = (file, callback)->
      Nimbus.Binary.upload_file(file, (f)->
        # sync it to document plugin
        foundry._plugins.document.set(f.file_id, f._file)

        if callback
          callback(f)
        # apply scope
      )
      return

    comment_action = (data)->
      obj = data
      if $scope.reply_mode
        $scope.reply_mode = false
        # get reply comment
        if !$scope.current_comment.replies
          $scope.current_comment.replies = []

        $scope.current_comment.replies.push(data)
        $scope.current_comment.save()
        email = foundry._user_list[$scope.current_comment.userid].email
      else
        comment_model.create(data)
        email = foundry._user_list[$scope.displayed_topic.userid].email
      #email notification for author
      notify_author(obj, email)

      $scope.new_comment = ''
      $scope.load()

    $scope.add_comment = (rss)->
      id = $scope.displayed_topic.id
      c = 
        userid : foundry._current_user.id
        name : $scope.get_user_name(foundry._current_user.id)
        content : $scope.new_comment
        post_id : id
        created_at : Date().toString()
        timestamp : new Date().getTime()

      #to determine whether to upload or not#
      if $scope.upload_comment
        spinner = $foundry.spinner(
          type : 'loading'
          text : 'Uploading... '
        )
        $scope.uplading_file = true
        console.log 'upload'  
        upload_attachment($scope.upload_comment, (file)->
          c.attachment = file.file_id
          comment_action(c)
          spinner.hide()
          $scope.uplading_file = false
          $scope.upload_comment = null
          $scope.$apply()
        )

      else
        console.log 'create directly'
        comment_action(c)
        
      return

    ###
      get attachment url with id
    ###
    $scope.get_attachment_url = (id)->
      file = foundry._plugins.document.get(id)
      if file
        return file.webContentLink

    $scope.get_attachment = (id)->
      foundry._plugins.document.get(id) if id
    
    ###
    
      methods for update post and links

    ###

    $scope.update = ()->
      console.log("UPDATE displayed topic")
      # update data
      $scope.displayed_topic.save()
      $scope.clear()

      return

    # retrive content for rss link
    $scope.get_content_by_url = (url)->
      console.log 'URL: '+url
    
    $scope.get_user_pic = (id)->
      if id is 10000
        return 'forum_avatar.jpg'
      
      user_model = foundry._models.User
      user = user_model.findByAttribute('pid', id)
      if user
        user.pic or 'photo.jpg'
      else
        "empty.png"
    
    $scope.get_user_name = (id) ->
      if id is 10000
        return 'Forum'
      user_model = foundry._models.User
      user = user_model.findByAttribute('pid', id)
      if user
        user.name
      else
        ""

    $scope.get_current_user_pic = ()->
      if foundry._current_user
        $scope.get_user_pic(foundry._current_user.id) or 'photo.jpg'
      else 
        ''
        
    $scope.get_time_from_now = (date, long) ->
      if long
        return moment(date).fromNow()
      else
        return moment(date).fromNow().replace("ago", "")
      
      
    foundry.share_user_retrieved = () =>
      $scope.$apply()
    
    $scope.get_link_domain = (link)->
      window.url('domain', link)
    
    $scope.get_link_favicon = (link) ->
      w = window.url('domain', link)
      return "http://www.google.com/s2/favicons?domain="+w

    $scope.load()

    ###
    below is helper method for things like show spinner and add comment with Forum identity
    ###

    ###

    ###
    $scope.show_spinner = (msg)->
      spinner = $foundry.spinner(
        type : 'loading'
        text :  msg
      )
      spinner
    ###

    ###
    $scope.log_comment = (msg)->
      comment = 
        userid : foundry._current_user.id
        name : foundry._current_user.name
        content : msg
        post_id : $scope.displayed_topic.id
        created_at : Date().toString()
        timestamp : new Date().getTime()
      comment_model.create(comment)
      $scope.load()

    ###
      send_email_to_all is a simple wrapper for sending email to all other user
      or just one user
    ###
    $scope.send_email_to_all = (data)->
      content = generate_post_template({
        name : data.subject
        text : data.content
        id : $scope.displayed_topic.id
      })
      $foundry.gmail(data.subject, foundry._current_user.email, content, foundry._plugins.user.mail_list())

    $scope.send_email_to = (email, data)->
      content = generate_post_template({
        name : data.subject
        text : data.content
        id : $scope.displayed_topic.id
      })
      $foundry.gmail(data.subject, email, content)

    ###
      input: component
      output: function used to show the add_shortcut
        of given component
      function: create such function
    ###

    $scope.shortcut = (component) ->
      return () ->         
        $scope.form_mode = 'create'
        $scope.form_config = component.formConfig
        $(".#{component.view.createModal.cssClass}").modal()
        textarea = $(".#{component.view.createModal.cssClass}").find("textarea")
        if textarea.length > 0 and typeof textarea.data("wysihtml5") isnt 'undefined'
          postEditor = textarea.data("wysihtml5").editor
          postEditor.composer.setHistory([postEditor.composer.getValue()])
        return
    ###
      input: component
      output: fucntion used to create a topic model instance
        of the component
      function: create such function
    ###
    $scope.componentCreator = (component) ->
      return (topic_data) ->
        if topic_data
          x = topic_data
        else
          x = $scope.topic_data
        ###
          these fields are defined in 
          doc_plugin.default_model_fields
        ###
        unless x.userid
          x.userid = foundry._current_user.id
        unless x.created_at
          x.created_at = Date().toString()
        unless x.timestamp
          x.timestamp = new Date().getTime()
        created_item = foundry._models[component.topicModel].create(x)
        x.id = created_item.id
        $scope.topic_data = {}
        $scope.load()
        $('.modal').modal('hide')

        # show new created item
        #pins = foundry._models.Bookmark.all()
        #$scope.change_display(null, pins.length)
        $scope.navigateToTopic(created_item)


        # send message to notify the suer
        component.email_for_creation($scope, x) if component.email_for_creation
        x
        return
    # invoke component's onForumLoaded callback
    component.onForumLoaded.apply({},[$scope.componentScope[component.name], $foundry, $filter]) for component in components

    return
    ])
