function ui_elements() {
    $(".dial").knob();
    $(".dial2").knob();
    $("#slider-horizontal-1").slider({
        animate: true,
        value: 12,
        min: 0,
        max: 100,
        orientation: "vertical"
    });
    $("#slider-horizontal-2").slider({
        animate: true,
        value: 22,
        min: 0,
        max: 100,
        range: "min",
        orientation: "vertical"
    });
    $("#slider-horizontal-3").slider({
        animate: true,
        value: 82,
        min: 0,
        max: 100,
        range: "max",
        orientation: "vertical"
    });
    $("#slider-horizontal-4").slider({
        animate: true,
        value: 32,
        min: 0,
        max: 100,
        range: "min",
        orientation: "vertical"
    });
    $("#slider-horizontal-5").slider({
        animate: true,
        value: 42,
        min: 0,
        max: 100,
        range: "max",
        orientation: "vertical"
    });
    $("#slider-horizontal-6").slider({
        animate: true,
        value: 62,
        min: 0,
        max: 100,
        range: "min",
        orientation: "vertical"
    });
    $("#slider-red").slider({
        animate: true,
        value: 23,
        min: 0,
        max: 100,
        range: "min"
    });
    $("#slider-green").slider({
        animate: true,
        value: 42,
        min: 0,
        max: 100,
        range: "min"
    });
    $("#slider-yellow").slider({
        animate: true,
        value: 82,
        min: 0,
        max: 100,
        range: "min"
    });
    $("#slider-blue").slider({
        animate: true,
        value: 34,
        min: 0,
        max: 100,
        range: "min"
    });
    $("#slider-purple").slider({
        animate: true,
        value: 6,
        min: 0,
        max: 100,
        range: "min"
    });
    $("#slider").slider({
        animate: true,
        range: "min",
        value: 22,
        min: 0,
        max: 100,

        //this gets a live reading of the value and prints it on the page
        slide: function (event, ui) {
            $(".slider-result").html(ui.value);
        }
    });
    $("#slider2").slider({
        animate: true,
        range: "min",
        value: 170,
        min: 0,
        max: 500,

        //this gets a live reading of the value and prints it on the page
        slide: function (event, ui) {
            $(".slider-result-2").html(ui.value);
        }
    });
    $("#slider3").slider({
        animate: true,
        range: "max",
        value: 332,
        min: 0,
        max: 500,

        //this gets a live reading of the value and prints it on the page
        slide: function (event, ui) {
            $(".slider-result-3").html(ui.value);
        }
    });
    $("#slider4").slider({
        animate: true,
        range: "min",
        value: 20,
        min: 0,
        max: 100,
        step: 10,

        //this gets a live reading of the value and prints it on the page
        slide: function (event, ui) {
            $(".slider-result-4").html(ui.value);
        }
    });
    $("#slider5").slider({
        animate: true,
        range: true,
        min: 0,
        max: 500,
        values: [163, 354],
        slide: function (event, ui) {
            $(".slider-result-5").html("$" + ui.values[0] + " - $" + ui.values[1]);
        }
    });

    $("#progress-bar-1").progressbar({
        value: 1,
        create: function () {
            $("#progress-bar-1 > .ui-progressbar-value").animate({
                width: "79%"
            }, {
                duration: 49000,
                step: function (now) {
                    $(".progress-bar-result-1").html(parseInt(now));
                }
            })
        }
    });
    $("#progress-bar-2").progressbar({
        value: 1,
        create: function () {
            $("#progress-bar-2 > .ui-progressbar-value").animate({
                width: "100%"
            }, {
                duration: 70000,
                step: function (now) {
                    $(".progress-bar-result-2").html(parseInt(now));
                }
            })
        }
    });
    $("#progress-bar-3").progressbar({
        value: 1,
        create: function () {
            $("#progress-bar-3 > .ui-progressbar-value").animate({
                width: "100%"
            }, {
                duration: 19000,
                step: function (now) {
                    $(".progress-bar-result-3").html(parseInt(now * .78));
                }
            })
        }
    });
    $("#dialog").dialog({
        autoOpen: false,
        show: {
            effect: "blind",
            duration: 1000
        },
        hide: {
            effect: "blind",
            duration: 1000
        }
    });
    /* PNOTIFY NOTIFICATION */

    function dyn_notice() {
        var percent = 0;
        var notice = $.pnotify({
            title: "Please Wait",
            type: 'info',
            icon: 'picon picon-throbber',
            hide: false,
            closer: false,
            sticker: false,
            opacity: .75,
            shadow: false,
            width: "150px"
        });

        setTimeout(function () {
            notice.pnotify({
                title: false
            });
            var interval = setInterval(function () {
                percent += 2;
                var options = {
                    text: percent + "% complete."
                };
                if (percent == 80) options.title = "Almost There";
                if (percent >= 100) {
                    window.clearInterval(interval);
                    options.title = "Done!";
                    options.type = "success";
                    options.hide = true;
                    options.closer = true;
                    options.sticker = true;
                    options.icon = 'picon picon-task-complete';
                    options.opacity = 1;
                    options.shadow = true;
                    options.width = $.pnotify.defaults.width;
                    //options.min_height = "300px";
                }
                notice.pnotify(options);
            }, 120);
        }, 2000);
    }

    /* PNOTIFY NOTIFICATION */

    function show_stack_info() {
        var modal_overlay;
        if (typeof info_box != "undefined") {
            info_box.pnotify_display();
            return;
        }
        info_box = $.pnotify({
            title: "Pines Notify Stacks",
            text: "Stacks are used to position notices and determine where new notices will go when they're created. Each notice that's placed into a stack will be positioned related to the other notices in that stack. There is no limit to the number of stacks, and no limit to the number of notices in each stack.",
            type: "info",
            icon: "picon picon-object-order-raise",
            delay: 20000,
            history: false,
            stack: false,
            before_open: function (pnotify) {
                // Position this notice in the center of the screen.
                pnotify.css({
                    "top": ($(window).height() / 2) - (pnotify.height() / 2),
                    "left": ($(window).width() / 2) - (pnotify.width() / 2)
                });
                // Make a modal screen overlay.
                if (modal_overlay) modal_overlay.fadeIn("fast");
                else modal_overlay = $("<div />", {
                    "class": "ui-widget-overlay",
                    "css": {
                        "display": "none",
                        "position": "fixed",
                        "top": "0",
                        "bottom": "0",
                        "right": "0",
                        "left": "0"
                    }
                }).appendTo("body").fadeIn("fast");
            },
            before_close: function () {
                modal_overlay.fadeOut("fast");
            }
        });
    }
    $('#add-sticky').click(function () {

        var unique_id = $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a sticky notice!',
            // (string | mandatory) the text inside the notification
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eget tincidunt velit. Cum sociis natoque penatibus et <a href="#" style="color:#ccc">magnis dis parturient</a> montes, nascetur ridiculus mus.',
            // (string | optional) the image to display on the left
            image: 'http://s3.amazonaws.com/twitter_production/profile_images/132499022/myface_bigger.jpg',
            // (bool | optional) if you want it to fade out on its own or just sit there
            sticky: true,
            // (int | optional) the time you want it to be alive for before fading out
            time: '',
            // (string | optional) the class name you want to apply to that specific message
            class_name: 'my-sticky-class'
        });

        // You can have it return a unique id, this can be used to manually remove it later using
        /*
            setTimeout(function(){
            
            $.gritter.remove(unique_id, {
            fade: true,
            speed: 'slow'
            });
            
            }, 6000)
            */

        return false;

    });

    $('#add-regular').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a regular notice!',
            // (string | mandatory) the text inside the notification
            text: 'This will fade out after a certain amount of time. Vivamus eget tincidunt velit. Cum sociis natoque penatibus et <a href="#" style="color:#ccc">magnis dis parturient</a> montes, nascetur ridiculus mus.',
            // (string | optional) the image to display on the left
            image: 'http://a0.twimg.com/profile_images/59268975/jquery_avatar_bigger.png',
            // (bool | optional) if you want it to fade out on its own or just sit there
            sticky: false,
            // (int | optional) the time you want it to be alive for before fading out
            time: ''
        });

        return false;

    });

    $('#add-max').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a notice with a max of 3 on screen at one time!',
            // (string | mandatory) the text inside the notification
            text: 'This will fade out after a certain amount of time. Vivamus eget tincidunt velit. Cum sociis natoque penatibus et <a href="#" style="color:#ccc">magnis dis parturient</a> montes, nascetur ridiculus mus.',
            // (string | optional) the image to display on the left
            image: 'http://a0.twimg.com/profile_images/59268975/jquery_avatar_bigger.png',
            // (bool | optional) if you want it to fade out on its own or just sit there
            sticky: false,
            // (function) before the gritter notice is opened
            before_open: function () {
                if ($('.gritter-item-wrapper').length == 3) {
                    // Returning false prevents a new gritter from opening
                    return false;
                }
            }
        });

        return false;

    });

    $('#add-without-image').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a notice without an image!',
            // (string | mandatory) the text inside the notification
            text: 'This will fade out after a certain amount of time. Vivamus eget tincidunt velit. Cum sociis natoque penatibus et <a href="#" style="color:#ccc">magnis dis parturient</a> montes, nascetur ridiculus mus.'
        });

        return false;
    });

    $('#add-gritter-light').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a light notification',
            // (string | mandatory) the text inside the notification
            text: 'Just add a "gritter-light" class_name to your $.gritter.add or globally to $.gritter.options.class_name',
            class_name: 'gritter-light'
        });

        return false;
    });

    $('#add-with-callbacks').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a notice with callbacks!',
            // (string | mandatory) the text inside the notification
            text: 'The callback is...',
            // (function | optional) function called before it opens
            before_open: function () {
                alert('I am called before it opens');
            },
            // (function | optional) function called after it opens
            after_open: function (e) {
                alert("I am called after it opens: \nI am passed the jQuery object for the created Gritter element...\n" + e);
            },
            // (function | optional) function called before it closes
            before_close: function (e, manual_close) {
                var manually = (manual_close) ? 'The "X" was clicked to close me!' : '';
                alert("I am called before it closes: I am passed the jQuery object for the Gritter element... \n" + manually);
            },
            // (function | optional) function called after it closes
            after_close: function (e, manual_close) {
                var manually = (manual_close) ? 'The "X" was clicked to close me!' : '';
                alert('I am called after it closes. ' + manually);
            }
        });

        return false;
    });

    $('#add-sticky-with-callbacks').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'This is a sticky notice with callbacks!',
            // (string | mandatory) the text inside the notification
            text: 'Sticky sticky notice.. sticky sticky notice...',
            // Stickeh!
            sticky: true,
            // (function | optional) function called before it opens
            before_open: function () {
                alert('I am a sticky called before it opens');
            },
            // (function | optional) function called after it opens
            after_open: function (e) {
                alert("I am a sticky called after it opens: \nI am passed the jQuery object for the created Gritter element...\n" + e);
            },
            // (function | optional) function called before it closes
            before_close: function (e) {
                alert("I am a sticky called before it closes: I am passed the jQuery object for the Gritter element... \n" + e);
            },
            // (function | optional) function called after it closes
            after_close: function () {
                alert('I am a sticky called after it closes');
            }
        });

        return false;

    });

    $("#remove-all").click(function () {

        $.gritter.removeAll();
        return false;

    });

    $("#remove-all-with-callbacks").click(function () {

        $.gritter.removeAll({
            before_close: function (e) {
                alert("I am called before all notifications are closed.  I am passed the jQuery object containing all  of Gritter notifications.\n" + e);
            },
            after_close: function () {
                alert('I am called after everything has been closed.');
            }
        });
        return false;

    });
}

function ui_components() {
    $('label.tree-toggler').click(function () {
        $(this).parent().children('ul.tree').toggle(300);
    });
    $("[rel=tooltip]").tooltip();
    $("#popover-top").popover();
    $("#popover-right").popover();
    $("#popover-left").popover();
    $("#popover-bottom").popover();
}

function ui_icons() {
    $("[rel=tooltip]").tooltip({
        placement: 'top'
    });
}

function form_components() {
    $('#tooltip').tooltip();
    $('#colorpicker').colorpicker();
    $(".chzn-select").chosen();
    $(".chzn-select-deselect").chosen({
        allow_single_deselect: true
    });
}

function form_editors() {
    $('#WYSIHTML5').wysihtml5();
    var converter1 = Markdown.getSanitizingConverter();
    var editor1 = new Markdown.Editor(converter1);
    editor1.run();
}

function form_wizard() {
    $('#rootwizard').bootstrapWizard({
        onNext: function (tab, navigation, index) {
            if (index == 2) {
                // Make sure we entered the name
                if (!$('#name').val()) {
                    alert('You must enter your name');
                    $('#name').focus();
                    return false;
                }
            }

            if (index == 1) {
                // Make sure we entered the name
                if (!$('#word').val()) {
                    alert('You must enter your fav word');
                    $('#word').focus();
                    return false;
                }
            }

            if (index == 1) {
                // Make sure we entered the name
                if (!$('#email').val()) {
                    alert('You must enter your email');
                    $('#email').focus();
                    return false;
                }
            }

            // Set the name for the next tab
            $('#tab3').html('Hello, ' + $('#name').val());

        },
        onTabShow: function (tab, navigation, index) {
            var $total = navigation.find('li').length;
            var $current = index + 1;
            var $percent = ($current / $total) * 100;
            $('#rootwizard').find('.bar').css({
                width: $percent + '%'
            });
        }
    });
    $("input,select,textarea").not("[type=submit]").jqBootstrapValidation();
}

function data_tables() {
    $('#managed-table').dataTable();
    $('#username').editable({
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });
    $('#username2').editable({
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });
    $('#username3').editable({
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });
    $('#username4').editable({
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });
    $('#username5').editable({
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });
    $('#username6').editable({
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });
    $('#group').editable({
        source: ["Admin", "Editor", "Staff", "User"]
    });
    $('#group2').editable({
        source: ["Admin", "Editor", "Staff", "User"]
    });
    $('#group3').editable({
        source: ["Admin", "Editor", "Staff", "User"]
    });
    $('#group4').editable({
        source: ["Admin", "Editor", "Staff", "User"]
    });
    $('#group5').editable({
        source: ["Admin", "Editor", "Staff", "User"]
    });

    $("table-dark").tablecloth({
        theme: "dark"
    });
    $("table-paper").tablecloth({
        theme: "paper"
    });
}

function google_maps() {
    new GMaps({
        div: '#map',
        lat: -12.043333,
        lng: -77.028333
    });

    url = GMaps.staticMapURL({
        size: [610, 300],
        lat: -12.043333,
        lng: -77.028333
    });

    $('<img/>').attr('src', url)
        .appendTo('#static');

    map = new GMaps({
        div: '#route',
        lat: -12.043333,
        lng: -77.028333
    });
    $('#start_travel').click(function (e) {
        e.preventDefault();
        map.travelRoute({
            origin: [-12.044012922866312, -77.02470665341184],
            destination: [-12.090814532191756, -77.02271108990476],
            travelMode: 'driving',
            step: function (e) {
                $('#instructions').append('<li>' + e.instructions + '</li>');
                $('#instructions li:eq(' + e.step_number + ')').delay(450 * e.step_number).fadeIn(200, function () {
                    map.setCenter(e.end_location.lat(), e.end_location.lng());
                    map.drawPolyline({
                        path: e.path,
                        strokeColor: '#131540',
                        strokeOpacity: 0.6,
                        strokeWeight: 6
                    });
                });
            }
        });
    });

    var addresspicker = $("#addresspicker").addresspicker();
    var addresspickerMap = $("#addresspicker_map").addresspicker({
        regionBias: "de",
        map: "#map_canvas",
        typeaheaddelay: 1000,
        mapOptions: {
            zoom: 16,
            center: new google.maps.LatLng(52.5122, 13.4194)
        }

    });

    addresspickerMap.on("addressChanged", function (evt, address) {
        console.dir(address);
    });
    addresspickerMap.on("positionChanged", function (evt, markerPosition) {
        markerPosition.getAddress(function (address) {
            if (address) {
                $("#addresspicker_map").val(address.formatted_address);
            }
        })
    });
}

function vector_maps() {
    jQuery('#vmap').vectorMap({
        map: 'world_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
    jQuery('#vmap-asia').vectorMap({
        map: 'asia_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
    jQuery('#vmap-europe').vectorMap({
        map: 'europe_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
    jQuery('#vmap-australia').vectorMap({
        map: 'australia_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
    jQuery('#vmap-africa').vectorMap({
        map: 'africa_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
    jQuery('#vmap-northamerica').vectorMap({
        map: 'north-america_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
    jQuery('#vmap-southamerica').vectorMap({
        map: 'south-america_en',
        backgroundColor: '#333333',
        color: '#ffffff',
        hoverOpacity: 0.7,
        selectedColor: '#666666',
        enableZoom: true,
        showTooltip: true,
        values: sample_data,
        scaleColors: ['#C8EEFF', '#006491'],
        normalizeFunction: 'polynomial'
    });
}

function charts() {
    //  jQuery Flot Chart
    var data1 = [
        [1, 43],
        [2, 35],
        [3, 49],
        [4, 31],
        [5, 45],
        [6, 54],
        [7, 52],
        [8, 62],
        [9, 59],
        [10, 66],
        [11, 48],
        [12, 42]
    ];
    var data2 = [
        [1, 18],
        [2, 23],
        [3, 15],
        [4, 26],
        [5, 19],
        [6, 35],
        [7, 41],
        [8, 46],
        [9, 32],
        [10, 34],
        [11, 31],
        [12, 25]
    ];

    var plot = $.plot($("#chart"), [{
        data: data1,
        label: "2012"
    }, {
        data: data2,
        label: "2013"
    }], {
        series: {
            lines: {
                show: true,
                lineWidth: 1,
                fill: true,
                fillColor: {
                    colors: [{
                        opacity: 0.05
                    }, {
                        opacity: 0.09
                    }]
                }
            },
            points: {
                show: true,
                lineWidth: 2,
                radius: 3
            },
            shadowSize: 0,
            stack: true
        },
        grid: {
            hoverable: true,
            clickable: true,
            tickColor: "#f9f9f9",
            borderWidth: 0
        },
        legend: {
            // show: false
            labelBoxBorderColor: "#fff"
        },
        colors: ["#94aec4", "#3473A9"],
        xaxis: {
            ticks: [
                [1, "JAN"],
                [2, "FEB"],
                [3, "MAR"],
                [4, "APR"],
                [5, "MAY"],
                [6, "JUN"],
                [7, "JUL"],
                [8, "AUG"],
                [9, "SEP"],
                [10, "OCT"],
                [11, "NOV"],
                [12, "DEC"]
            ],
            font: {
                size: 12,
                family: "Open Sans, Arial",
                variant: "small-caps",
                color: "#9da3a9"
            }
        },
        yaxis: {
            ticks: 3,
            tickDecimals: 0,
            font: {
                size: 12,
                color: "#9da3a9"
            }
        }
    });

    function showTooltip(x, y, contents) {
        $('<div id="tooltip">' + contents + '</div>').css({
            position: 'absolute',
            display: 'none',
            top: y - 30,
            left: x - 50,
            color: "#fff",
            padding: '2px 5px',
            'border-radius': '6px',
            'background-color': '#000',
            opacity: 0.80
        }).appendTo("body").fadeIn(200);
    }

    var previousPoint = null;
    $("#statsChart").bind("plothover", function (event, pos, item) {
        if (item) {
            if (previousPoint != item.dataIndex) {
                previousPoint = item.dataIndex;

                $("#tooltip").remove();
                var x = item.datapoint[0].toFixed(0),
                    y = item.datapoint[1].toFixed(0);

                var month = item.series.xaxis.ticks[item.dataIndex].label;

                showTooltip(item.pageX, item.pageY,
                    item.series.label + " of " + month + ": " + y);
            }
        } else {
            $("#tooltip").remove();
            previousPoint = null;
        }
    });

    var dataSet = [{
        label: "Asia",
        data: 4119630000,
        color: "#057D9F"
    }, {
        label: "Latin America",
        data: 590950000,
        color: "#216477"
    }, {
        label: "Africa",
        data: 1012960000,
        color: "#025167"
    }, {
        label: "Oceania",
        data: 35100000,
        color: "#39AECF"
    }, {
        label: "Europe",
        data: 727080000,
        color: "#25567B"
    }, {
        label: "North America",
        data: 344120000,
        color: "#0B61A4"
    }];
    var placeholder = $("#pie");
    $.plot(placeholder, dataSet, {
        series: {
            pie: {
                show: true,
                combine: {
                    color: '#999',
                    threshold: 0.1
                }
            }
        },
        legend: {
            show: false
        }
    });

    var data = [
        ["January", 10],
        ["February", 8],
        ["March", 4],
        ["April", 13],
        ["May", 17],
        ["June", 9]
    ];

    $.plot("#bar", [data], {
        series: {
            bars: {
                show: true,
                barWidth: 0.6,
                align: "center"
            }

        },
        colors: ["#94aec4", "#3473A9"],
        grid: {
            hoverable: true,
            clickable: true,
            tickColor: "#fff",
            borderWidth: 0
        },
        xaxis: {
            mode: "categories",
            tickLength: 0
        }
    });


    var males = {
        "15%": [
            [2, 88.0],
            [3, 93.3],
            [4, 102.0],
            [5, 108.5],
            [6, 115.7],
            [7, 115.6],
            [8, 124.6],
            [9, 130.3],
            [10, 134.3],
            [11, 141.4],
            [12, 146.5],
            [13, 151.7],
            [14, 159.9],
            [15, 165.4],
            [16, 167.8],
            [17, 168.7],
            [18, 169.5],
            [19, 168.0]
        ],
        "90%": [
            [2, 96.8],
            [3, 105.2],
            [4, 113.9],
            [5, 120.8],
            [6, 127.0],
            [7, 133.1],
            [8, 139.1],
            [9, 143.9],
            [10, 151.3],
            [11, 161.1],
            [12, 164.8],
            [13, 173.5],
            [14, 179.0],
            [15, 182.0],
            [16, 186.9],
            [17, 185.2],
            [18, 186.3],
            [19, 186.6]
        ],
        "25%": [
            [2, 89.2],
            [3, 94.9],
            [4, 104.4],
            [5, 111.4],
            [6, 117.5],
            [7, 120.2],
            [8, 127.1],
            [9, 132.9],
            [10, 136.8],
            [11, 144.4],
            [12, 149.5],
            [13, 154.1],
            [14, 163.1],
            [15, 169.2],
            [16, 170.4],
            [17, 171.2],
            [18, 172.4],
            [19, 170.8]
        ],
        "10%": [
            [2, 86.9],
            [3, 92.6],
            [4, 99.9],
            [5, 107.0],
            [6, 114.0],
            [7, 113.5],
            [8, 123.6],
            [9, 129.2],
            [10, 133.0],
            [11, 140.6],
            [12, 145.2],
            [13, 149.7],
            [14, 158.4],
            [15, 163.5],
            [16, 166.9],
            [17, 167.5],
            [18, 167.1],
            [19, 165.3]
        ],
        "mean": [
            [2, 91.9],
            [3, 98.5],
            [4, 107.1],
            [5, 114.4],
            [6, 120.6],
            [7, 124.7],
            [8, 131.1],
            [9, 136.8],
            [10, 142.3],
            [11, 150.0],
            [12, 154.7],
            [13, 161.9],
            [14, 168.7],
            [15, 173.6],
            [16, 175.9],
            [17, 176.6],
            [18, 176.8],
            [19, 176.7]
        ],
        "75%": [
            [2, 94.5],
            [3, 102.1],
            [4, 110.8],
            [5, 117.9],
            [6, 124.0],
            [7, 129.3],
            [8, 134.6],
            [9, 141.4],
            [10, 147.0],
            [11, 156.1],
            [12, 160.3],
            [13, 168.3],
            [14, 174.7],
            [15, 178.0],
            [16, 180.2],
            [17, 181.7],
            [18, 181.3],
            [19, 182.5]
        ],
        "85%": [
            [2, 96.2],
            [3, 103.8],
            [4, 111.8],
            [5, 119.6],
            [6, 125.6],
            [7, 131.5],
            [8, 138.0],
            [9, 143.3],
            [10, 149.3],
            [11, 159.8],
            [12, 162.5],
            [13, 171.3],
            [14, 177.5],
            [15, 180.2],
            [16, 183.8],
            [17, 183.4],
            [18, 183.5],
            [19, 185.5]
        ],
        "50%": [
            [2, 91.9],
            [3, 98.2],
            [4, 106.8],
            [5, 114.6],
            [6, 120.8],
            [7, 125.2],
            [8, 130.3],
            [9, 137.1],
            [10, 141.5],
            [11, 149.4],
            [12, 153.9],
            [13, 162.2],
            [14, 169.0],
            [15, 174.8],
            [16, 176.0],
            [17, 176.8],
            [18, 176.4],
            [19, 177.4]
        ]
    };

    var females = {
        "15%": [
            [2, 84.8],
            [3, 93.7],
            [4, 100.6],
            [5, 105.8],
            [6, 113.3],
            [7, 119.3],
            [8, 124.3],
            [9, 131.4],
            [10, 136.9],
            [11, 143.8],
            [12, 149.4],
            [13, 151.2],
            [14, 152.3],
            [15, 155.9],
            [16, 154.7],
            [17, 157.0],
            [18, 156.1],
            [19, 155.4]
        ],
        "90%": [
            [2, 95.6],
            [3, 104.1],
            [4, 111.9],
            [5, 119.6],
            [6, 127.6],
            [7, 133.1],
            [8, 138.7],
            [9, 147.1],
            [10, 152.8],
            [11, 161.3],
            [12, 166.6],
            [13, 167.9],
            [14, 169.3],
            [15, 170.1],
            [16, 172.4],
            [17, 169.2],
            [18, 171.1],
            [19, 172.4]
        ],
        "25%": [
            [2, 87.2],
            [3, 95.9],
            [4, 101.9],
            [5, 107.4],
            [6, 114.8],
            [7, 121.4],
            [8, 126.8],
            [9, 133.4],
            [10, 138.6],
            [11, 146.2],
            [12, 152.0],
            [13, 153.8],
            [14, 155.7],
            [15, 158.4],
            [16, 157.0],
            [17, 158.5],
            [18, 158.4],
            [19, 158.1]
        ],
        "10%": [
            [2, 84.0],
            [3, 91.9],
            [4, 99.2],
            [5, 105.2],
            [6, 112.7],
            [7, 118.0],
            [8, 123.3],
            [9, 130.2],
            [10, 135.0],
            [11, 141.1],
            [12, 148.3],
            [13, 150.0],
            [14, 150.7],
            [15, 154.3],
            [16, 153.6],
            [17, 155.6],
            [18, 154.7],
            [19, 153.1]
        ],
        "mean": [
            [2, 90.2],
            [3, 98.3],
            [4, 105.2],
            [5, 112.2],
            [6, 119.0],
            [7, 125.8],
            [8, 131.3],
            [9, 138.6],
            [10, 144.2],
            [11, 151.3],
            [12, 156.7],
            [13, 158.6],
            [14, 160.5],
            [15, 162.1],
            [16, 162.9],
            [17, 162.2],
            [18, 163.0],
            [19, 163.1]
        ],
        "75%": [
            [2, 93.2],
            [3, 101.5],
            [4, 107.9],
            [5, 116.6],
            [6, 122.8],
            [7, 129.3],
            [8, 135.2],
            [9, 143.7],
            [10, 148.7],
            [11, 156.9],
            [12, 160.8],
            [13, 163.0],
            [14, 165.0],
            [15, 165.8],
            [16, 168.7],
            [17, 166.2],
            [18, 167.6],
            [19, 168.0]
        ],
        "85%": [
            [2, 94.5],
            [3, 102.8],
            [4, 110.4],
            [5, 119.0],
            [6, 125.7],
            [7, 131.5],
            [8, 137.9],
            [9, 146.0],
            [10, 151.3],
            [11, 159.9],
            [12, 164.0],
            [13, 166.5],
            [14, 167.5],
            [15, 168.5],
            [16, 171.5],
            [17, 168.0],
            [18, 169.8],
            [19, 170.3]
        ],
        "50%": [
            [2, 90.2],
            [3, 98.1],
            [4, 105.2],
            [5, 111.7],
            [6, 118.2],
            [7, 125.6],
            [8, 130.5],
            [9, 138.3],
            [10, 143.7],
            [11, 151.4],
            [12, 156.7],
            [13, 157.7],
            [14, 161.0],
            [15, 162.0],
            [16, 162.8],
            [17, 162.2],
            [18, 162.8],
            [19, 163.3]
        ]
    };

    var dataset = [{
            label: "Female mean",
            data: females["mean"],
            lines: {
                show: true
            },
            color: "rgba(232,81,81,1)"
        }, {
            id: "f15%",
            data: females["15%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: false
            },
            color: "rgba(232,81,81,1)"
        }, {
            id: "f25%",
            data: females["25%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: 0.2
            },
            color: "rgba(232,81,81,1)",
            fillBetween: "f15%"
        }, {
            id: "f50%",
            data: females["50%"],
            lines: {
                show: true,
                lineWidth: 0.5,
                fill: 0.4,
                shadowSize: 0
            },
            color: "rgba(232,81,81,1)",
            fillBetween: "f25%"
        }, {
            id: "f75%",
            data: females["75%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: 0.4
            },
            color: "rgba(232,81,81,1)",
            fillBetween: "f50%"
        }, {
            id: "f85%",
            data: females["85%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: 0.2
            },
            color: "rgba(232,81,81,1)",
            fillBetween: "f75%"
        },

        {
            label: "Male mean",
            data: males["mean"],
            lines: {
                show: true
            },
            color: "rgba(92,139,181,1)"
        }, {
            id: "m15%",
            data: males["15%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: false
            },
            color: "rgba(92,139,181,1)"
        }, {
            id: "m25%",
            data: males["25%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: 0.2
            },
            color: "rgba(92,139,181,1)",
            fillBetween: "m15%"
        }, {
            id: "m50%",
            data: males["50%"],
            lines: {
                show: true,
                lineWidth: 0.5,
                fill: 0.4,
                shadowSize: 0
            },
            color: "rgba(92,139,181,1)",
            fillBetween: "m25%"
        }, {
            id: "m75%",
            data: males["75%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: 0.4
            },
            color: "rgba(92,139,181,1)",
            fillBetween: "m50%"
        }, {
            id: "m85%",
            data: males["85%"],
            lines: {
                show: true,
                lineWidth: 0,
                fill: 0.2
            },
            color: "rgba(92,139,181,1)",
            fillBetween: "m75%"
        }
    ];

    $.plot($("#graph"), dataset, {
        xaxis: {
            tickDecimals: 0
        },
        yaxis: {
            tickFormatter: function (v) {
                return v + " cm";
            }
        },
        grid: {
            tickColor: "#fff",
            borderWidth: 0
        },
        legend: {
            position: "se"
        }
    });


    // We use an inline data source in the example, usually data would
    // be fetched from a server

    var data = [],
        totalPoints = 300;

    function getRandomData() {

        if (data.length > 0)
            data = data.slice(1);

        // Do a random walk

        while (data.length < totalPoints) {

            var prev = data.length > 0 ? data[data.length - 1] : 50,
                y = prev + Math.random() * 10 - 5;

            if (y < 0) {
                y = 0;
            } else if (y > 100) {
                y = 100;
            }

            data.push(y);
        }

        // Zip the generated y values with the x values

        var res = [];
        for (var i = 0; i < data.length; ++i) {
            res.push([i, data[i]])
        }

        return res;
    }

    // Set up the control widget

    var updateInterval = 30;

    var plot = $.plot("#realtime", [getRandomData()], {
        series: {
            shadowSize: 0 // Drawing is faster without shadows
        },
        grid: {
            hoverable: true,
            tickColor: "#fff",
            borderWidth: 0
        },
        colors: ["#64A3D7"],
        yaxis: {
            min: 0,
            max: 100
        },
        xaxis: {
            show: false
        }
    });

    function update() {

        plot.setData([getRandomData()]);

        // Since the axes don't change, we don't need to call plot.setupGrid()

        plot.draw();
        setTimeout(update, updateInterval);
    }

    update();

}

function calendar() {
    /* initialize the external events
		-----------------------------------------------------------------*/

    $('#external-events div.external-event').each(function () {

        // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
        // it doesn't need to have a start or end
        var eventObject = {
            title: $.trim($(this).text()) // use the element's text as the event title
        };

        // store the Event Object in the DOM element so we can get to it later
        $(this).data('eventObject', eventObject);

        // make the event draggable using jQuery UI
        $(this).draggable({
            zIndex: 999,
            revert: true, // will cause the event to go back to its
            revertDuration: 0 //  original position after the drag
        });

    });


    /* initialize the calendar
		-----------------------------------------------------------------*/

    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        editable: true,
        droppable: true, // this allows things to be dropped onto the calendar !!!
        drop: function (date, allDay) { // this function is called when something is dropped

            // retrieve the dropped element's stored Event Object
            var originalEventObject = $(this).data('eventObject');

            // we need to copy it, so that multiple events don't have a reference to the same object
            var copiedEventObject = $.extend({}, originalEventObject);

            // assign it the date that was reported
            copiedEventObject.start = date;
            copiedEventObject.allDay = allDay;

            // render the event on the calendar
            // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
            $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);

            // is the "remove after drop" checkbox checked?
            if ($('#drop-remove').is(':checked')) {
                // if so, remove the element from the "Draggable Events" list
                $(this).remove();
            }

        }
    });
}

function gallery() {
    $('.photoset-grid-lightbox').photosetGrid({
        highresLinks: true,
        rel: 'withhearts-gallery',
        gutter: '20px',

        onComplete: function () {
            $('.photoset-grid-lightbox').attr('style', '');
            $('.photoset-grid-lightbox a').colorbox({
                photo: true,
                scalePhotos: true,
                maxHeight: '90%',
                maxWidth: '90%'
            });
        }
    });
}

function login() {
    $('.users').click(function () {
        $(".login").animate({
            opacity: 'toggle'
        }, 500);
    });
    $('#user').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'Hey Stan Smith',
            // (string | mandatory) the text inside the notification
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fringilla.',
            // (string | optional) the image to display on the left
            image: 'assets/img/person.png',
            // (bool | optional) if you want it to fade out on its own or just sit there
            sticky: false,
            // (int | optional) the time you want it to be alive for before fading out
            time: ''
        });

        return false;

    });
    $('#user2').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'Hey Stan Smith',
            // (string | mandatory) the text inside the notification
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fringilla, arcu ac mattis fermentum.',
            // (string | optional) the image to display on the left
            image: 'assets/img/person2.png',
            // (bool | optional) if you want it to fade out on its own or just sit there
            sticky: false,
            // (int | optional) the time you want it to be alive for before fading out
            time: ''
        });

        return false;

    });
    $('#user3').click(function () {

        $.gritter.add({
            // (string | mandatory) the heading of the notification
            title: 'Hey Stan Smith',
            // (string | mandatory) the text inside the notification
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fringilla, arcu ac mattis fermentum,.',
            // (string | optional) the image to display on the left
            image: 'assets/img/person3.png',
            // (bool | optional) if you want it to fade out on its own or just sit there
            sticky: false,
            // (int | optional) the time you want it to be alive for before fading out
            time: ''
        });

        return false;

    });
}

function index() {
    //  jQuery Flot Chart
    var data1 = [
        [1, 33],
        [2, 35],
        [3, 32],
        [4, 26],
        [5, 32],
        [6, 24],
        [7, 18]
    ];
    var data2 = [
        [1, 18],
        [2, 23],
        [3, 15],
        [4, 31],
        [5, 32],
        [6, 27],
        [7, 23]
    ];

    var plot = $.plot($("#chart"), [{
        data: data1,
        label: "Last Week"
    }, {
        data: data2,
        label: "This Week"
    }], {
        series: {
            lines: {
                show: true,
                lineWidth: 1,
                fill: true,
                fillColor: {
                    colors: [{
                        opacity: 0
                    }, {
                        opacity: 0.2
                    }]
                }
            },
            points: {
                show: true,
                lineWidth: 2,
                radius: 3
            },
            shadowSize: 0,
            stack: true
        },
        grid: {
            hoverable: true,
            clickable: true,
            tickColor: "transparent",
            borderWidth: 0
        },
        legend: {
            // show: false
            labelBoxBorderColor: "transparent",
            backgroundColor: "transparent"
        },
        colors: ["#94aec4", "#3473A9"],
        xaxis: {
            ticks: [
                [1, "Mon"],
                [2, "Tue"],
                [3, "Wed"],
                [4, "Thu"],
                [5, "Fri"],
                [6, "Sat"],
                [7, "Sun"]
            ],
            font: {
                size: 12,
                family: "Open Sans, Arial",
                variant: "lowercase",
                color: "#fff"
            }
        },
        yaxis: {
            ticks: 3,
            tickDecimals: 0,
            font: {
                size: 12,
                family: "Open Sans, Arial",
                variant: "lowercase",
                color: "#fff"
            }
        }
    });
    $("#sparkline1").sparkline([3, 4, 5, 5, 4, 5, 4, 5, 6, 5, 6, 7, 8, 7, 6, 7, 8, 9], {
        type: 'line',
        width: '100%',
        height: '50px',
        lineColor: '#5b8bb4',
        drawNormalOnTop: false
    });
    $("#sparkline2").sparkline([1.8, 1.3, 2.5], {
        type: 'pie',
        width: '100%',
        height: '50px',
        sliceColors: ['#E95151', '#64A3D7', '#5B8BB4'],
        borderWidth: 0
    });
    $("#sparkline3").sparkline([5, 6, 7, 2, 0, -4, -2, 4], {
        type: 'bar',
        height: '50px ',
        barColor: '#5b8bb4',
        negBarColor: '#e95151'
    });

    $('input').iCheck({
        checkboxClass: 'icheckbox_square',
        radioClass: 'iradio_square',
        increaseArea: '20%' // optional
    });
}