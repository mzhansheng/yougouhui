define(function(){var b=null;var a={runMode:"mobile"};require.config({paths:{jquery:"libs/jquery",jquerymobile:"libs/jquery.mobile-1.4.0",underscore:"libs/lodash",backbone:"libs/backbone"},shim:{backbone:{deps:["underscore","jquery"],exports:"Backbone"}}});return{getBaseUrl:function(){if(!b){b="http://223.203.193.239:7072/demo"}return b},getAppTitle:function(){return"优购汇"},getSession:function(){return{svUserId:"1",svGEO:"1"}},getProperty:function(c){return a[c]}}});