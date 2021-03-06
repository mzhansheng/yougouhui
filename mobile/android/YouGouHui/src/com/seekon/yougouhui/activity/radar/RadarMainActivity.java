package com.seekon.yougouhui.activity.radar;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import com.seekon.yougouhui.R;
import com.seekon.yougouhui.activity.setting.RadarSettingActivity;

public class RadarMainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.discover_radar);

		ActionBar actionBar = this.getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);

		Button scanButton = (Button) findViewById(R.id.radar_scan);
		scanButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(RadarMainActivity.this,
						RadarScanActivity.class);
				startActivity(intent);
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.discover_radar, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int itemId = item.getItemId();
		switch (itemId) {
		case android.R.id.home:
			this.finish();
			break;
		case R.id.menu_radar_setting:
			radarSetting();
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}

	private void radarSetting() {
		Intent intent = new Intent(this, RadarSettingActivity.class);
		startActivity(intent);
	}
}
