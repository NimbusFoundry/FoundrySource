$(document).ready(function () {
    $('.menu li').click(function (ev) {
        $(this).find('>ul').slideToggle();
        ev.stopPropagation();
    });
    $(".menu, .menu > li").mouseleave(function () {
        $(".menu li ul").slideUp();
        $(".menu.menu-small li ul").slideUp();
    });
    if ($(window).width() < 979) {
        $(".menu").addClass("menu-small");
        $(".page-wrap").addClass("page-small");
    }
    $("#menu-icon").click(function () {
        $(".menu").toggleClass("menu-small");
        $(".page-wrap").toggleClass("page-small");
    });
    $(".navbar").resize(function () { // navbar because of flot issue
        if ($(document).width() <= 979) {
            $(".menu").addClass("menu-small");
            $(".page-wrap").addClass("page-small");
        }
        if ($(document).width() >= 979) {
            $(".menu").removeClass("menu-small");
            $(".page-wrap").removeClass("page-small");
        }
    });
});