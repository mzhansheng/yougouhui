define(["jquery","backbone","collections/DiscoverCollection","config"],function(i,h,f,g){var j=f.extend({constructor:function(a,b){j.__super__.constructor.call(this,a,b)},initialize:function(a,b){j.__super__.initialize.call(this,a,b)},url:function(){var a=g.getSession();return g.getBaseUrl()+"/getNearbyShops/"+a.svGEO}});return j});