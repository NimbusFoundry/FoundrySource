(function(){define([],function(){return{showName:"Todo",icon:"icon-list",models:[{name:"Todolist",fields:["name","text","pinned"]},{name:"Todo",fields:["content","status","listid","images","completed_at"]}],topicModel:"Todolist",onViewLoaded:function(e){e.todoList=e.getTodoList()},onForumLoaded:function(e,t,o){var d,n;e.show_completed_todo=1,e.todoOrder="timestamp",e.reverseOrder=!1,d=foundry._models.Todo,n=foundry._models.User,d.onUpdate(function(t,o,d){return e.todoList=e.getTodoList(),d?void 0:e.$apply()}),e.users=foundry._models.User.all().filter(function(e){return e.name}),e.addTodo=function(t){var o;return t?(d.create({content:t,status:!1,listid:e.displayed_topic.id,created_at:Date().toString(),timestamp:(new Date).getTime()}),e.todoContent="",e.todoList=e.getTodoList(),o=""+foundry._current_user.name+" added a new todo: <b>"+t+"</b>",void e.$parent.log_comment(o)):void alert("You must type something todo :)")},e.change_todo_display=function(t){return e.show_completed_todo=t,1===t?(e.todoOrder="timestamp",e.reverseOrder=!1):2===t?(e.reverseOrder=!0,e.todoOrder="completed_at"):void 0},e.will_show_todo=function(t){return 1===e.show_completed_todo?t.status?!1:!0:2===e.show_completed_todo?t.status?!0:!1:void 0},e.delTodo=function(t){var o;return d.delete_from_cloud(t.id),e.todoList=e.getTodoList(),o=""+foundry._current_user.name+" deleted todo: <b>"+t.content+"</b>",e.$parent.log_comment(o),e.$parent.load()},e.changeStatus=function(e){var t;return t=d.update(e.id,{status:e.status}),e.status=t.status},e.toggle=function(t){var o,d;return t.status=!t.status,t.status&&(t.completed_at=(new Date).getTime()),t.save(),d=t.status?"completeted":"uncompleted",o=""+foundry._current_user.name+" marked <b>'"+t.content+"'</b> "+d,e.$parent.log_comment(o)},e.showStatus=function(e){return e.status?"done":""},e.assign=function(t,o){var n,i,r;if(t.userid!==o.pid)return r=d.update(t.id,{userid:o.pid}),t.userid=r.userid,i=foundry._user_list[t.userid].email,n={subject:"Forum Todo ",content:"Todo '"+t.content+"' has been assigned to you"},e.$parent.send_email_to(i,n)},e.cancelAssign=function(e){var t;return t=d.update(e.id,{userid:void 0}),e.userid=t.userid},e.getTodoList=function(){var t;return t=d.findAllByAttribute("listid",e.displayed_topic.id),o("orderBy")(t,e.todoOrder,e.reverseOrder)},e.get_image_path=function(e){return foundry._plugins.document._documents[e].webContentLink},e.remove_image_at=function(e,t){return t.images.splice(e,1),t.save()},e.editing_todo=-1,e.$watch("todoList",function(t){var o,d;return-1!==e.editing_todo?(d=t[e.editing_todo],d.new_image&&"string"!=typeof d.new_image?(o=e.$parent.show_spinner("Uploading"),Nimbus.Binary.upload_file(d.new_image,function(t){var n;return foundry._plugins.document.set(t._file.id,t._file),n={id:t._file.id},d.images?n.order=d.images.length+1:(d.images=[],n.order=1),d.images.push(n),delete d.new_image,d.save(),o.hide(),e.$apply()})):d.save()):void 0},!0)},email_for_creation:function(e,t){var o;return o={subject:"Forum Todo: "+t.name,content:t.text},e.send_email_to_all(o)},formConfig:{fields:{name:{type:"input",label:"Name"},text:{type:"editor",label:"Description"}}},view:{createModal:{title:"Add Todolist",cssClass:"todolist_post"},updateModal:{title:"Edit Todolist",cssClass:"update_todolist"}}}})}).call(this);