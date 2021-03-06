define(["db", "jquery", "config"], function (DB, $, Conf) {
	var properties = {
		phone: '111111',
		pwd: '111111',
		autoLogin : false,
		rememberPwd: true
	};
	
	var createEnvSql = 'CREATE TABLE IF NOT EXISTS e_env (id integer primary key, data text)';
	DB.executeSql(createEnvSql);
	
	$(function () {
		DB.executeSql('select data from e_env', [], function (tx, res) {
			if(res && res.rows && res.rows.length === 1){
				properties = $.parseJSON(res.rows.item(0).data);
			}else{
				properties = {
					phone: '',
					pwd: '',
					autoLogin : false,
					rememberPwd: false
				};
			}
		}, function (e) {
			console.log("ERROR: " + e.message);
		});
	});
	
	return {
		getProperty: function (name) {
			return properties[name];
		},
		
		getBaseUrl: function () {
			return Conf.getBaseUrl();
		},
		
		getAppTitle: function () {
			return Conf.getAppTitle();
		}
	};
});