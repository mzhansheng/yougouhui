define(["jquery","backbone","models/BackSupportModel","config"],function(c,e,b,a){var d=b.extend({defaults:{},constructor:function(f){d.__super__.constructor.call(this,f)},initialize:function(f){f.backHref="#module?discover";d.__super__.initialize.call(this,f)},url:function(){return a.getBaseUrl()+"/getRadarData/"}});return d});