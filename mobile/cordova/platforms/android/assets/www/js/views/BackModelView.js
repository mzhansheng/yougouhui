define(["jquery","backbone"],function(a,c){var b=c.View.extend({initialize:function(){this.model.on("added",this.render,this)},render:function(){var d=this.model.get("title");if(!d){d=this.model.title}a("#main-back-link").attr("href",this.model.backHref);a("#main-back-link").css("display","block");a("#main-head-title").html(d);return this}});return b});