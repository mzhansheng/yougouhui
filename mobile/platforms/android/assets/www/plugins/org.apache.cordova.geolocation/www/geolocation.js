cordova.define("org.apache.cordova.geolocation.geolocation",function(c,h,a){var l=c("cordova/argscheck"),k=c("cordova/utils"),e=c("cordova/exec"),g=c("./PositionError"),b=c("./Position");var d={};function f(m){var n={maximumAge:0,enableHighAccuracy:false,timeout:Infinity};if(m){if(m.maximumAge!==undefined&&!isNaN(m.maximumAge)&&m.maximumAge>0){n.maximumAge=m.maximumAge}if(m.enableHighAccuracy!==undefined){n.enableHighAccuracy=m.enableHighAccuracy}if(m.timeout!==undefined&&!isNaN(m.timeout)){if(m.timeout<0){n.timeout=0}else{n.timeout=m.timeout}}}return n}function i(m,o){var n=setTimeout(function(){clearTimeout(n);n=null;m({code:g.TIMEOUT,message:"Position retrieval timed out."})},o);return n}var j={lastPosition:null,getCurrentPosition:function(m,o,p){l.checkArgs("fFO","geolocation.getCurrentPosition",arguments);p=f(p);var q={timer:null};var r=function(s){clearTimeout(q.timer);if(!(q.timer)){return}var t=new b({latitude:s.latitude,longitude:s.longitude,altitude:s.altitude,accuracy:s.accuracy,heading:s.heading,velocity:s.velocity,altitudeAccuracy:s.altitudeAccuracy},(s.timestamp===undefined?new Date():((s.timestamp instanceof Date)?s.timestamp:new Date(s.timestamp))));j.lastPosition=t;m(t)};var n=function(t){clearTimeout(q.timer);q.timer=null;var s=new g(t.code,t.message);if(o){o(s)}};if(j.lastPosition&&p.maximumAge&&(((new Date()).getTime()-j.lastPosition.timestamp.getTime())<=p.maximumAge)){m(j.lastPosition)}else{if(p.timeout===0){n({code:g.TIMEOUT,message:"timeout value in PositionOptions set to 0 and no cached Position object available, or cached Position object's age exceeds provided PositionOptions' maximumAge parameter."})}else{if(p.timeout!==Infinity){q.timer=i(n,p.timeout)}else{q.timer=true}e(r,n,"Geolocation","getLocation",[p.enableHighAccuracy,p.maximumAge])}}return q},watchPosition:function(m,o,p){l.checkArgs("fFO","geolocation.getCurrentPosition",arguments);p=f(p);var r=k.createUUID();d[r]=j.getCurrentPosition(m,o,p);var n=function(t){clearTimeout(d[r].timer);var s=new g(t.code,t.message);if(o){o(s)}};var q=function(s){clearTimeout(d[r].timer);if(p.timeout!==Infinity){d[r].timer=i(n,p.timeout)}var t=new b({latitude:s.latitude,longitude:s.longitude,altitude:s.altitude,accuracy:s.accuracy,heading:s.heading,velocity:s.velocity,altitudeAccuracy:s.altitudeAccuracy},(s.timestamp===undefined?new Date():((s.timestamp instanceof Date)?s.timestamp:new Date(s.timestamp))));j.lastPosition=t;m(t)};e(q,n,"Geolocation","addWatch",[r,p.enableHighAccuracy]);return r},clearWatch:function(m){if(m&&d[m]!==undefined){clearTimeout(d[m].timer);d[m].timer=false;e(null,null,"Geolocation","clearWatch",[m])}}};a.exports=j});