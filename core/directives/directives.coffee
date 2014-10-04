###
    angular directives
###
angular.module('foundry-ui', ['ngDialog'])
.directive 'enEditor', ['$parse', '$timeout', ($parse, $timeout) ->
    # Runs during compile
    return (scope, elm, attrs) ->
        # retrive value
        value = $parse(attrs.ngModel)(scope)
        update = ()->
            getter = $parse(elm.attr('ng-model'))
            setter = getter.assign
            setter(angular.element(elm).scope(),$(elm).val())
            ###
                compare the value if is the same, we should not update.
            ###
            $timeout(()->
                angular.element(elm).scope().$apply()
            ,0)
        # add watch for model

        editor = $(elm).wysihtml5($.extend(foundry.wysiwygOptions, 
            stylesheets:[]
            events : 
                'change' : update
                'blur' : update
            )
        )

        scope.$watch(attrs.ngModel, (value)->
            value= '' if !value
            if value isnt $(elm).data("wysihtml5").editor.composer.getValue()
                $(elm).data("wysihtml5").editor.composer.setValue(value)
            return
        , true)
        
        iframe = $(elm).data("wysihtml5").editor.currentView.iframe
        composer = $(elm).data("wysihtml5").editor.composer
        $(iframe).on('load', ()->
            $(iframe.contentDocument.body).on('keydown', (evt)->
                if evt.keyCode is 13
                    composer.selectedNodeBeforeReturn = composer.selection.getSelectedNode()
                    composer.commands.exec("insertHTML", '<br>')
            )

            $(iframe.contentDocument.body).on('paste', (evt)->
                console.log 'pasted'
                evt.stopPropagation()
            )
        )
        
        value= '' if !value
        $(elm).data("wysihtml5").editor.composer.setValue(value)
        
        return
    ]

.directive 'modelForm', ['$compile', '$parse', ($compile, $parse)->
    restrict : 'E'
    compile : (tElement, tAttr)->
        (scope, element, attrs)->
            random = Math.floor(Math.random() * 1000000000)
            instance = attrs['instanceName']
            model = attrs['modelName']
            create_method = scope[model].create
            update_method = scope[model].update
            html = '<form>'
            mode = attrs['formMode']
            for key,value of scope[model].fields
                html += '<div class="nimb_form' +" #{ value.type }"+ '"'
                if value.show
                    html += 'ng-show="'+value.show+'"'
                if value.hide
                    html += 'ng-hide="'+value.hide+'"'
                html+='>'

                html += '<label for="'+instance+'.'+key+random+'">'+value.label+'</label>'
                switch value.type
                    # normal input   
                    when 'input'
                        html += '<input type="text" id="'+instance+'.'+key+random+'" ng-model="'+instance+'.'+key+'">'
                    # select
                    when 'select'
                        html += '<select ng-model="'+instance+'.'+key+'">'
                        for k,v of value.options
                            html += '<option ng-selected="'+model+'.'+key+'.value == '+v+'" value="'+v+'">'+k+'</option>'
                        html += '</select>'
                    #check box
                    when 'checkbox'
                        html += '<div class="checker"><span><input style="margin-top:0px;margin-right:10px;" type="checkbox" ng-model="'+instance+'.'+key+'" >'+value.text+'</span></div><br>'
                    # textarea
                    when 'text'
                        html += '<textarea id="'+instance+'.'+key+random+'" ng-model="'+instance+'.'+key+'"></textarea>'
    
                    # editor
                    when 'editor'
                        html += '<textarea style="" en-editor ng-model="'+instance+'.'+key+'">{{'+instance+'[key]}}</textarea>'

                    # tag list
                    when 'list'
                        # html += '<select en-list class="chzn-select" ng-options="c for c in '+model+'.'+key+'.options'+'" ng-model="'+instance+'.'+key+'"></select>'
                        html += '<span ng-init="'+instance+'.'+key+'=[]||'+instance+'.'+key+'"></span>'

                        html += '<tags-input custom-class="bootstrap" type="text" ng-model="'+instance+'.'+key+'"></tags-input>'
                    #radio
                    when 'radio'
                        html += '<div><label ng-repeat="(k,v) in '+model+'.'+key+'.options">'
                        html += '<input name="'+instance+'.'+key+'" style="margin-top: -4px;margin-right: 5px;" type="radio" value="{{v}}" ng-model="'+instance+'.'+key+'"> {{k}}<br />'
                        html += '</label></div>'
 
                    when 'file' 
                        html += '<span class="btn outline btn-file"><input type="file" form-file en-model="' + instance + '.' + key + '" class="fileupload">Choose File</span>';
                        html += '<span class="btn btn-danger" ng-show="' + instance + '.' + key + '" ng-click="' + instance + '.' + key + '=null">Clear</span>'
                        html += '<p class="file_attach">{{'+instance+'.'+key+'.name}}</p>'
                    when 'date_time' 
                        html += '<input class="datetimepicker" en-date type="text" ng-model="'+instance+'.'+key+'">'
 
                html+='</div>'

            html += '<button ng-show="'+mode+'=='+"'"+'edit'+"'"+'" class="btn btn-success update_button" ng-click="'+update_method+'">Update</button>'
            html += '<button ng-show="'+mode+'=='+"'"+'create'+"'"+'" class="btn btn-primary create_button" ng-click="'+create_method+'">Create</button>'
            
            html += '</form>'
            content = $compile(html)(scope)
            element.replaceWith(content)    
            return

    ]

.directive 'enList', ['$compile', '$timeout', '$parse', ($compile, $timeout, $parse) ->
    # Runs during compile
    return (scope, elm, attrs) ->
        # Runs during render
        $timeout(()->
            $(elm).simpleTagger();
        ,300)

        scope.$watch(attrs.ngModel,(oldValue,newValue)->
            console.log 'new value'
        )
        console.log 'list directive'
    ]
.directive 'userInfo', ['$compile', ($compile)->
    restrict : 'E'
    compile : (tElement, tAttr)->
        (scope, element, attrs)->
            console.log $compile
    ]
.directive("fileread", [()->
    link :  ($scope, element, attrs)->
        element.bind("change", (evt)->
            if attrs.enModel
                $scope[attrs.enModel] = evt.target.files[0]
                $scope.$apply()
        )
        element.on 'click', (evt)->
            evt.stopPropagation()
        return
])
.directive 'formFile', ['$parse', ($parse) ->
    # Runs during compile
    return (scope, elm, attrs) ->
        setter = 'test'
        changed = (evt)->
            if attrs.enModel
                getter = $parse(attrs.enModel)
                setter = getter.assign
                setter(scope, evt.target.files[0])
                scope.$apply()

        elm.bind("change", changed)
        # Runs during render
    ]
.factory('$foundry',['$http',($http)->
    service =
        email : ()->
            console.log 'email'
            mailgun = (type,value,content,bcc,cc)->
                # use ajax to send
                form_data = 
                    'from' : encodeURIComponent('NimbusBase <me@nimbusbase.com>')
                    'to' : encodeURIComponent(value)
                    'subject' : encodeURIComponent(type)
                    'html' : encodeURIComponent(content)
                if bcc
                    form_data['bcc'] = encodeURIComponent(bcc)
                if cc
                    form_data['cc'] = encodeURIComponent(cc)
                
                $.ajax 
                    url : 'http://192.241.167.76:3000/api.mailgun.net/v2/nimbusbase.com/messages'
                    method : 'post'
                    beforeSend: (request)->
                        request.setRequestHeader("Authorization", "Basic  YXBpOmtleS04c3RvbXM1eGwtaHRuZGFoMmZsNGNycG9vaTN0bnllMg==")
                    data : form_data
                    success : (data)->
                        console.log data
                # form.submit()
            mailgun.apply(this, arguments)

        gmail : (subject, to, content, cc='', bcc='') ->
            base64EncodedEmail = ""
            sendMessage = (email, callback) ->
                base64EncodedEmail = base64EncArr(strToUTF8Arr(email)).replace(/\//g,"_").replace(/\+/g,"-")
                request = gapi.client.gmail.users.messages.send({
                    'userId': 'me',
                    'raw': base64EncodedEmail
                });
                request.execute(callback)
            mailCallback = (error, email) ->
                if error 
                    console.log error
                    return
                currentUserEmail = foundry._current_user.email
                
                sendMessage(email, () ->
                    # console.log ("gmail sent to others")
                    console.log arguments
                    if arguments[0].code is 400 and arguments[0].message is "Invalid cc header" 
                      # gmail bug tmp fix, try to send email one by one
                      console.log("sent failure for multiple cc, try to send email one by one");
                      retry = true;
                      originalCc = data.cc
                      data.cc = null;
                      window.composeMail(data, mailCallback);
                      toList = originalCc.split(",");
                      for cto in toList
                          data.to = cto;
                          window.composeMail(data, mailCallback);
                       
                 
                    # comment code below because google has fix problems of sending email to self
                    ###if arguments[0].id
                        if to.indexOf(currentUserEmail)>=0 or bcc.indexOf(currentUserEmail)>=0 or cc.indexOf(currentUserEmail)>=0
                            gapi.client.request({
                                path:"gmail/v1/users/me/messages/#{arguments[0].id}/modify"
                                method: "POST"
                                body:"{\"addLabelIds\": [\"UNREAD\",\"INBOX\"]}"
                                callback: () ->
                                    console.log ("gmail sent to self")
                                    console.log(arguments)
                            })###
                )
            data = {
                'from': "'#{foundry._current_user.name}'<#{foundry._current_user.email}>"
                'to': to
                'cc': cc
                'bcc': bcc
                'subject': subject
                'html': content
            } 
            
            if window.composeMail
                window.composeMail(data, mailCallback)
            else
                window.mailTasks.push(data, mailCallback)

        validate : (emal,callback)->
            console.log 'validation'
            Nimbus.Share.add_share_user_real(email,(user)->
                is_valid = if user.name then true else false
                Nimbus.Share.remove_share_user_real(user.id,(res)->
                    callback(is_valid)
                )
                return
            )

        spinner : (config)->
            data = 
                text: config.text
            switch config.type
                when 'loading'
                    opts = 
                        lines: 13, # The number of lines to draw
                        length: 11, # The length of each line
                        width: 5, # The line thickness
                        radius: 17, # The radius of the inner circle
                        corners: 1, # Corner roundness (0..1)
                        rotate: 0, # The rotation offset
                        color: '#FFF', # #rgb or #rrggbb
                        speed: 1, # Rounds per second
                        trail: 60, # Afterglow percentage
                        shadow: false, # Whether to render a shadow
                        hwaccel: false, # Whether to use hardware acceleration
                        className: 'spinner', # The CSS class to assign to the spinner
                        zIndex: 2e9, # The z-index (defaults to 2000000000)
                        top: 'auto', # Top position relative to parent in px
                        left: 'auto' # Left position relative to parent in px
                    target = document.createElement("div");
                    document.body.appendChild(target);
                    spinner = new Spinner(opts).spin(target);
                    data.spinner = spinner
                when 'sucess'
                    data.icon = 'img/check.png'
                when 'error'
                    data.icon = 'img/cross.png'

            iosOverlay(data)

        rss : (url, callback)->
            # base url
            # proxyUrl = 'http://127.0.0.1:9292/'
            proxyUrl = httpsProxyUrl = 'http://192.241.167.76:9292/'
            callbackWhenMatch = null

            # build cors proxy url
            buildUrl = (str)->
                https = str.indexOf('https://')
                if https is -1
                    str = proxyUrl+str.replace('http://','')
                else
                    str = httpsProxyUrl+str.replace('https://','')

                str

            # match articl in the feed list
            matchArticle = (options)->
                article = options.rss
                listUrl = options.url
                callbackOrNot = options.callback
                title = options.title

                $.ajax(
                    url : buildUrl(listUrl)
                    dataType : 'xml'
                    success : (data)->
                        # match the article url
                        list = $(data).find('item') 
                        if list.length is 0
                            list = $(data).find('entry')
                        
                        # return object
                        obj = null
                        error = true

                        for item in list
                            if $(item).find('link').text().indexOf(article) isnt -1
                                obj = item
                                error = false
                                break

                            if title and title.indexOf($(item).find('title').text()) isnt -1
                                obj = item
                                error = false
                                break

                        if error
                            obj = 
                                'title' : title     
                        
                        callbackWhenMatch(obj, error) if callbackOrNot
                    error : (req, text)->
                        # deal with error
                        console.log req,text
                        data = null 
                        if text is 'parsererror'
                            data = $(req.responseText)

                        list = $(data).find('item') 
                        if list.length is 0
                            list = $(data).find('entry')
                        
                        # return object
                        obj = null
                        error = true

                        for item in list
                            if $(item).find('link').text().indexOf(article) isnt -1
                                obj = item
                                error = false
                                break

                            if title and title.indexOf($(item).find('title').text()) isnt -1
                                obj = item
                                error = false
                                break

                        if error
                            obj = 
                                'title' : title     
                        
                        callbackWhenMatch(obj, error) if callbackOrNot

                )

            retrieveArticle = (rss, callback)->
                # build url first
                str =  buildUrl(rss)
                callbackWhenMatch = callback
                # send ajax request
                $.ajax(
                    url : str
                    async : false
                    dataType : 'html'
                    success : (data)->
                        # build the response
                        # match feed list first, and title
                        titleMatch = /<title>([\s\S]*)<\/title>/.exec(data)
                        # application\/rss\+xml.*href=['"](.*)['"]
                        match = /application\/rss\+xml.*href=['"](.*)['"]/.exec(data)
                        
                        if match and match.length>=2
                            listUrl = match[1]
                            # if
                            if listUrl.indexOf('feedburner.com') isnt -1
                                listUrl = listUrl + '?format=xml'
                            options = 
                                'url' : listUrl
                                'rss' : rss
                                'title' : titleMatch[1] || ''
                                'callback' : true

                            matchArticle(options)
                        else
                            # callback with null content or feedburner url
                            console.log 'error when get this site'
                            data =  
                                title : titleMatch[1] || ''
                            callbackWhenMatch(data, true)

                    error : (data)->
                        # send the error
                        console.log data
                        callbackWhenMatch(null , true)
                )

            retrieveArticle(url, callback)
            return
    service
])
.directive 'enCalendar', ['$parse', ($parse) ->
    # Runs during compile
    link = (scope, elm, attrs) ->
        # Runs during render
        config = {}
        if attrs['enClick'] 
            config.action = (evt)->
                id = evt.target.id.replace('_day','')
                $(elm).find('.current_date').removeClass('current_date')
                $('#'+id).addClass('current_date')
                scope.show_date.call(scope, evt)
                scope.$apply()
        
        $(elm).zabuto_calendar(config)

        scope.$watch('selected_date',(n, o)->
            if !n or n is ''
                $(elm).find('.current_date').removeClass('current_date')
        )
        return
    
    link : link
    ]   
.directive('bindHtmlUnsafe', ['$compile', ($compile)->
    ($scope, $element, $attrs )->
        compile = ( newHTML )-> #// Create re-useable compile function
            # compiled = $compile(newHTML)($scope); #// Compile html
            # if compiled.length
            #   newHTML = compiled
            if newHTML
                newHTML = newHTML.replace(/\n/g,'<br>')
                
            $element.html('').append(newHTML); #// Clear and append it

        htmlName = $attrs.bindHtmlUnsafe; 
        #// Get the name of the variable 
        #// Where the HTML is stored
        $scope.$watch(htmlName, (newHTML, oldHTML)->
            # return if !newHTML
            compile(newHTML)   #// Compile it
        )
    ]
)
.directive('confirm', ['$compile',($compile)->
    link : ($scope, elm, attrs)->
        elm.bind 'click', (evt)->
            onConfirm = attrs['onConfirm']
            onCancel = if attrs['onCancel'] then attrs['onCancel'] else ''
            html = '<div class="wrapper dismiss_containter"><form>'
            html += '<div class="m-t-lg text-right"><button style="margin-right:5px" en-dismiss ng-click="'+onConfirm+'" class="btn btn-success">Yes</button>'
            html += '<button class="btn btn-danger bootbox-close-button" en-dismiss ng-click="'+onCancel+'">No</button></div>'
            html += '</form></div>'
            # template = angular.element(html)
            content = $compile(html)($scope)
            # show bootbox dialog
            bootbox.dialog(
                'title':'Are you sure you want to do this?'
                'className': "nimbus_confirm_modal"
                'message' : content
            )
            return
    ]
)
.directive 'enDismiss', () ->
    # Runs during compile
    return (scope, elm, attrs) ->
        elm.bind('click', (evt)->
            bootbox.hideAll()
        )
.directive('subexternal',()->
    link : (scope, elm ,attrs)->
        elm.delegate('a', 'click', (evt)->
            return if !this.href or this.href.indexOf('#') is 0
            # open new window only when the link is not null
            evt.preventDefault()
            targetURL = this.href
            window.open(targetURL, "_blank")
        )
    )
.directive 'enDate', () ->
    # Runs during compile
    return (scope, elm, attrs) ->
        $(elm).datetimepicker()
.directive 'enEditInPlace',['$parse', '$compile', ($parse, $compile) ->
    # Runs during compile
    restrict: 'A'
    require: '?ngModel'
    link : (scope, elm, attrs, ngModel) ->
        
        edit = $("<div contentEditable='true' class='temp tasks-list-desc editable-cell' style='top:0px;text-decoration:none'></div>")
        listener = (evt)->
            # retrive value
            value = $parse(attrs['ngModel'])(scope)
            editable = $parse(attrs['enableEdit'])(scope)

            evt.stopPropagation()

            # if the edit is not enabled
            return if editable
            # add edit content 
            elm.after(edit.html(value)).hide()
            edit.focus()

            edit.on 'blur', (evt)->
                #remove the editable div
                elm.show().next('.temp').remove()

            edit.on 'keydown', (evt)->
                # assign changes to model
                if evt.keyCode is 13
                    scope.$apply(()->
                        elm.controller('ngModel').$setViewValue(edit.text())
                    )
                    elm.show().next('.temp').remove()

        # Runs during render
        elm.on 'click', listener

        return
    ]   
.directive 'enZoom', [() ->
    # Runs during compile
    return (scope, elm, attrs) ->
        # Runs during render
        url = attrs['enZoom']

        elm.on('click', (evt)->
            # add new layer at top with the url
            html = '<div class="image-zoomed todo-image-zoomed">'
            html +=    "<img src='#{url}' />"
            html +=    '<div class="backdrop"></div>'
            html += '</div>'

            modal = $(html)
            # remove on click
            modal.on 'click', (evt)->
                $(this).fadeOut(()->
                    $(this).remove()
                )

            $('body').append(modal.fadeIn())
        )
    ]
.directive 'imgZoom', () ->
    # this is a universal moniter for image zoom operation
    #
    # Runs during compile
    link : (scope, elm, attrs)->

        # add for wrapper
        elm.delegate('img','mouseenter',(evt)->
            url = evt.target.src

            link = "<div class='mask'></div><a class='zoom-action-button' data-src='#{url}'><i class='icon icon-zoom-in'></i></a>"
            $(evt.target).wrap('<p class="image-zoom-container"></p>')
            $(evt.target).parent().append(link)
        )

        elm.delegate('img','mouseleave',(evt)->
            # upwrap and remove the link tag
            $(evt.target).children('a,div.mask').remove()
            $(evt.target).siblings('a,div.mask').remove()
            $(evt.target).unwrap()
        )

        elm.delegate('.zoom-action-button','click',(evt)->
            url = $(evt.target).data('src')
            show_pop_up(url)
        )

        # Runs during render
        show_pop_up = (url)->
            # add new layer at top with the url
            html = '<div class="image-zoomed todo-image-zoomed">'
            html +=    "<img src='#{url}' />"
            html +=    '<div class="backdrop"></div>'
            html += '</div>'

            modal = $(html)
            # remove on click
            modal.on 'click', (evt)->
                $(this).fadeOut(()->
                    $(this).remove()
                )

            $('body').append(modal.fadeIn())
        
        console.log 'in link stage'
.directive 'subZoom', () ->
    # Runs during compile
    return (scope, elm, attrs) ->
        elm.delegate('img', 'click', (evt)->
            url = evt.target.src
            show_pop_up(url)
        )
        # Runs during render
        show_pop_up = (url)->
            # add new layer at top with the url
            html = '<div class="image-zoomed todo-image-zoomed">'
            html +=    "<img src='#{url}' />"
            html +=    '<div class="backdrop"></div>'
            html += '</div>'

            modal = $(html)
            # remove on click
            modal.on 'click', (evt)->
                $(this).fadeOut(()->
                    $(this).remove()
                )

            $('body').append(modal.fadeIn())
# directive for rss retive
.directive 'rssFeed', () ->
    # Runs during compile
    return (scope, elm, attrs) ->
        # Runs during render
        # bind data there


# inject directive 
angular.module("foundry-ui").directive "enFile", ['$parse', ($parse)->
    restrict: 'A'
    link : (scope, element, attrs)->
        element.on "change", (evt)->
            if attrs.enModel
                # model = attrs.$$element.controller('ngModel')
                # model.$setViewValue(evt.target.files[0])
                setter = $parse(attrs.enModel).assign
                setter(scope, evt.target.files[0])
            scope.$apply()

        element.on 'click', (evt)->
            evt.stopPropagation()
        return

    ]

#