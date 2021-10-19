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

// 投稿本文、ユーザーの自己紹介画面で使用
$(document).on('turbolinks:load', function(){
 $("#input-text").on("keyup", function() {
  // 入力文字数を受け取る
   let count_num = $(this).val().length;
  // 最大入力文字数ー入力文字数
   let now_count = 350 - count_num;
  //入力文字数によって色を変えている 
   if (count_num > 350) {
      $("#counter").css("color","red");
    } else {
      $("#counter").css("color","black");
    }
  // 残り何文字入力できるか表示
   $("#counter").text("残り"+now_count+"文字");
 });
});

// コメント投稿ページで使用
$(document).on('turbolinks:load', function(){
 $("#input-text-comment").on("keyup", function() {
  // 入力文字数を受け取る
   let count_num = $(this).val().length;
  // 最大入力文字数ー入力文字数
   let nowCount = 120 - count_num;
  //入力文字数によって色を変えている 
   if (count_num > 120) {
      $("#counter-comment").css("color","red");
    } else {
      $("#counter-comment").css("color","black");
    }
  // 残り何文字入力できるか表示
   $("#counter-comment").text("残り"+now_count+"文字");
 });
});