// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree.

// 入力文字数をカウント
$(document).on('turbolinks:load', function(){
 $("#input-text").on("keyup", function() {
   let count_num = $(this).val().length;
   let now_count = 350 - count_num;

   if (count_num > 350) {
      $("#counter").css("color","red");
    } else {
      $("#counter").css("color","black");
    }

   $("#counter").text("残り"+now_count+"文字");
 });
});

// 入力文字数をカウント
$(document).on('turbolinks:load', function(){
 $("#input-text-comment").on("keyup", function() {
   let count_num = $(this).val().length;
   let now_count = 120 - count_num;
   
   if (count_num > 120) {
      $("#counter-comment").css("color","red");
    } else {
      $("#counter-comment").css("color","black");
    }
    
   $("#counter-comment").text("残り"+now_count+"文字");
 });
});