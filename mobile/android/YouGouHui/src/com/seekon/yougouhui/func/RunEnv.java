package com.seekon.yougouhui.func;

import android.content.ContentValues;

import com.seekon.yougouhui.func.user.UserEntity;

public class RunEnv {

	private static RunEnv instance = null;

	private static Object lock = new Object();

	private boolean isConnectedToInternet = false;

	private UserEntity user = null;

	private ContentValues loginSetting = null;

	private RunEnv() {
	}

	public static RunEnv getInstance() {
		synchronized (lock) {
			if (instance == null) {
				instance = new RunEnv();
			}
		}
		return instance;
	}

	public void setConnectedToInternet(boolean isConnectedToInternet) {
		this.isConnectedToInternet = isConnectedToInternet;
	}

	public boolean isConnectedToInternet() {
		return this.isConnectedToInternet;
	}

	public UserEntity getUser() {
		return user;
	}

	public void setUser(UserEntity user) {
		this.user = user;
	}

	public ContentValues getLoginSetting() {
		return loginSetting;
	}

	public void setLoginSetting(ContentValues loginSetting) {
		this.loginSetting = loginSetting;
	}

}
