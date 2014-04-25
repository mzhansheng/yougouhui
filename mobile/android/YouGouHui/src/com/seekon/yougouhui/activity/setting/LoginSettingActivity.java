package com.seekon.yougouhui.activity.setting;

import android.app.ActionBar;
import android.app.Activity;
import android.content.ContentValues;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Switch;

import com.seekon.yougouhui.R;
import com.seekon.yougouhui.func.RunEnv;
import com.seekon.yougouhui.func.login.EnvHelper;
import com.seekon.yougouhui.func.login.LoginConst;
import com.seekon.yougouhui.sercurity.AuthorizationManager;
import com.seekon.yougouhui.util.ViewUtils;

public class LoginSettingActivity extends Activity {

	private Switch autoLoginView;
	private Switch rememberPwdView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		this.setContentView(R.layout.setting_login);
		initViews();
	}

	private void initViews() {
		ActionBar actionBar = this.getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);

		ContentValues loginSetting = RunEnv.getInstance().getLoginSetting();
		autoLoginView = (Switch) findViewById(R.id.auto_login);
		autoLoginView.setChecked(loginSetting
				.getAsBoolean(LoginConst.LOGIN_SETTING_AUTO_LOGIN));

		rememberPwdView = (Switch) findViewById(R.id.remember_pwd);
		rememberPwdView.setChecked(loginSetting
				.getAsBoolean(LoginConst.LOGIN_SETTING_REMEMBER_PWD));
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.common_save, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int itemId = item.getItemId();
		switch (itemId) {
		case android.R.id.home:
			this.finish();
			break;
		case R.id.menu_common_save:
			saveLoginSetting();
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}
	
	private void saveLoginSetting() {
		showProgress(true);

		AsyncTask<Void, Void, Boolean> task = new AsyncTask<Void, Void, Boolean>() {
			@Override
			protected Boolean doInBackground(Void... params) {
				ContentValues loginSetting = RunEnv.getInstance().getLoginSetting();
				loginSetting.put(LoginConst.LOGIN_SETTING_AUTO_LOGIN,
						autoLoginView.isChecked());
				loginSetting.put(LoginConst.LOGIN_SETTING_REMEMBER_PWD,
						rememberPwdView.isChecked());
				EnvHelper envHelper = AuthorizationManager.getInstance(
						LoginSettingActivity.this).getEnvHelper();
				envHelper.updateLoginSetting(loginSetting);
				return true;
			}

			@Override
			protected void onPostExecute(Boolean result) {
				if (result) {
					ViewUtils.showToast("修改成功.");
				}
				showProgress(false);
			}

			@Override
			protected void onCancelled() {
				showProgress(false);
				super.onCancelled();
			}
		};

		task.execute((Void) null);
	}

	private void showProgress(boolean show) {
		ViewUtils.showProgress(this, this.findViewById(R.id.view_login_setting),
				show);
	}
}