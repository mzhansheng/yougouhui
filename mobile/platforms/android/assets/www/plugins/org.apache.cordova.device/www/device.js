cordova.define("org.apache.cordova.device.device",function(c,e,b){var i=c("cordova/argscheck"),f=c("cordova/channel"),h=c("cordova/utils"),d=c("cordova/exec"),g=c("cordova");f.createSticky("onCordovaInfoReady");f.waitForInitialization("onCordovaInfoReady");function a(){this.available=false;this.platform=null;this.version=null;this.uuid=null;this.cordova=null;this.model=null;var j=this;f.onCordovaReady.subscribe(function(){j.getInfo(function(l){var k=g.version;j.available=true;j.platform=l.platform;j.version=l.version;j.uuid=l.uuid;j.cordova=k;j.model=l.model;f.onCordovaInfoReady.fire()},function(k){j.available=false;h.alert("[ERROR] Error initializing Cordova: "+k)})})}a.prototype.getInfo=function(j,k){i.checkArgs("fF","Device.getInfo",arguments);d(j,k,"Device","getDeviceInfo",[])};b.exports=new a()});