define(["jquery","backbone"],function(a,c){var b=c.View.extend({initialize:function(){this.collection.on("added",this.render,this)},render:function(){a("#main-back-link").attr("href",this.collection.backHref);a("#main-back-link").css("display","block");a("#main-head-title").html(this.collection.title);return this}});return b});