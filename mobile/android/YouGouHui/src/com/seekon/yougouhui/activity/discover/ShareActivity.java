package com.seekon.yougouhui.activity.discover;

import static com.seekon.yougouhui.func.DataConst.COL_NAME_CONTENT;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;

import com.seekon.yougouhui.R;
import com.seekon.yougouhui.activity.ImagePreviewActivity;
import com.seekon.yougouhui.activity.MainActivity;
import com.seekon.yougouhui.barcode.MipcaActivityCapture;
import com.seekon.yougouhui.file.FileHelper;
import com.seekon.yougouhui.file.ImageLoader;
import com.seekon.yougouhui.func.discover.share.ShareConst;
import com.seekon.yougouhui.func.discover.share.ShareProcessor;
import com.seekon.yougouhui.layout.FixGridLayout;
import com.seekon.yougouhui.rest.RestMethodResult;
import com.seekon.yougouhui.rest.resource.TextResource;
import com.seekon.yougouhui.util.ImageCompressUtils;
import com.seekon.yougouhui.util.Logger;
import com.seekon.yougouhui.util.ViewUtils;

public class ShareActivity extends Activity {

	private final String TAG = ShareActivity.class.getSimpleName();

	private static final int CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE = 100;

	private static final int LOAD_IMAGE_ACTIVITY_REQUEST_CODE = 200;

	private static final int PREVIEW_IMAGE_ACTIVITY_REQUEST_CODE = 300;

	private final static int SCANNIN_GREQUEST_CODE = 400;
	
	private static final int IMAGE_VIEW_WIDTH = 120;

	private static final int IMAGE_VIEW_HEIGHT = 120;

	private FixGridLayout picContainer = null;

	private String title[] = { "拍照", "从文件获取" };

	private PopupWindow popupWindow;

	private List<String> imageFileNames = new ArrayList<String>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.discover_share);

		ActionBar actionBar = this.getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);

		picContainer = (FixGridLayout) findViewById(R.id.share_pic_container);
		picContainer.setmCellHeight(IMAGE_VIEW_HEIGHT);
		picContainer.setmCellWidth(IMAGE_VIEW_WIDTH);
		picContainer.setShowBorder(true);

		final LayoutInflater inflater = getLayoutInflater();
		ImageView fl = (ImageView) inflater.inflate(
				R.layout.discover_share_pic_item, null);

		fl.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				showPopupWindow(v);
			}
		});

		picContainer.addView(fl);
		picContainer.invalidate(); // 让UI重绘界面
		
		Button barcodeScan = (Button) findViewById(R.id.b_scan_shop_barcode);
		barcodeScan.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent();
				intent.setClass(ShareActivity.this, MipcaActivityCapture.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivityForResult(intent, SCANNIN_GREQUEST_CODE);
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.discover_share, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int itemId = item.getItemId();
		switch (itemId) {
		case android.R.id.home:
			goBackHome();
			break;
		case R.id.menu_discover_share:
			this.publishShare();
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	/**
	 * 返回到上一界面
	 */
	private void goBackHome() {
		// 清理临时的图片文件
		if (imageFileNames != null && !imageFileNames.isEmpty()) {
			for (String fileName : imageFileNames) {
				File file = FileHelper.getFile(fileName);
				if (file != null && file.exists()) {
					file.deleteOnExit();
				}
			}
		}
		this.finish();
	}

	private void showPopupWindow(View v) {
		LinearLayout layout = (LinearLayout) LayoutInflater.from(this).inflate(
				R.layout.discover_share_choose_pop, null);
		ListView listView = (ListView) layout.findViewById(R.id.share_choose_pop);
		listView.setAdapter(new ArrayAdapter<String>(this,
				R.layout.discover_share_choose_pop_item, R.id.share_choose_pop_item,
				title));

		popupWindow = new PopupWindow(this);
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow.setWidth(getWindowManager().getDefaultDisplay().getWidth() / 2);
		popupWindow.setHeight(140);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.setContentView(layout);
		popupWindow.showAsDropDown(v);

		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position,
					long arg3) {
				if (position == 0) {
					openCamera();
				} else if (position == 1) {
					openImageDir();
				}
				popupWindow.dismiss();
				popupWindow = null;
			}
		});
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE) {
			if (resultCode == RESULT_OK && data != null) {
				Bitmap image = (Bitmap) data.getExtras().get("data");
				if (image != null) {
					image = ImageCompressUtils.compress(image);
					addBitmapToImageView(image);
					image = null;
				}
			}
		} else if (requestCode == LOAD_IMAGE_ACTIVITY_REQUEST_CODE) {
			if (resultCode == RESULT_OK && null != data) {
				Uri selectedImage = data.getData();
				String[] filePathColumn = { MediaStore.Images.Media.DATA };
				Cursor cursor = getContentResolver().query(selectedImage,
						filePathColumn, null, null, null);
				cursor.moveToFirst();
				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				String picturePath = cursor.getString(columnIndex);
				cursor.close();

				addBitmapToImageView(ImageCompressUtils.compress(picturePath));
			}
		} else if (requestCode == PREVIEW_IMAGE_ACTIVITY_REQUEST_CODE) {
			if (data != null) {
				boolean imageDeleted = data.getExtras().getBoolean(
						ImagePreviewActivity.IMAGE_DELETE_FLAG);
				if (imageDeleted) {
					int imageIndex = data.getExtras().getInt(
							ImagePreviewActivity.IMAGE_INDEX_IN_CONTAINER);
					String fileName = data.getExtras().getString(
							ImagePreviewActivity.IMAGE_SRC_KEY);
					imageFileNames.remove(fileName);
					picContainer.removeViewAt(imageIndex);
					picContainer.postInvalidate();
				}
			}
		}else if(requestCode == SCANNIN_GREQUEST_CODE){
			if(resultCode == RESULT_OK){
				Bundle bundle = data.getExtras();
				EditText barcodeText = (EditText) findViewById(R.id.share_shop_barcode);
				barcodeText.setText(bundle.getString("result"));
				Logger.debug(TAG, "barcode:" + bundle.toString());
			}
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	private void addBitmapToImageView(Bitmap bitmap) {
		Bitmap image = ImageCompressUtils.compressByQuality(bitmap, 100);// 进一步压缩

		final String fileName = System.currentTimeMillis() + ".png";
		FileHelper.write(image, fileName);// 临时写入到手机中

		ImageView pic = (ImageView) ShareActivity.this.getLayoutInflater().inflate(
				R.layout.discover_share_pic_item, null);
		pic.setBackgroundResource(0);// 去掉background
		ImageLoader.getInstance().displayImage(fileName, pic, true);

		final int imageIndex = picContainer.getChildCount() - 1;

		pic.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View view) {
				Intent intent = new Intent(ShareActivity.this,
						ImagePreviewActivity.class);
				intent.putExtra(ImagePreviewActivity.IMAGE_SRC_KEY, fileName);
				intent.putExtra(ImagePreviewActivity.IMAGE_INDEX_IN_CONTAINER,
						imageIndex);
				ShareActivity.this.startActivityForResult(intent,
						PREVIEW_IMAGE_ACTIVITY_REQUEST_CODE);
			}
		});

		imageFileNames.add(fileName);

		picContainer.addView(pic, imageIndex);
		picContainer.postInvalidate();
	}

	private void openCamera() {
		Logger.debug(TAG, "openCamera");
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		intent.addCategory(Intent.CATEGORY_DEFAULT);
		startActivityForResult(intent, CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE);
	}

	private void openImageDir() {
		Logger.debug(TAG, "openImageDir");
		Intent intent = new Intent(Intent.ACTION_PICK,
				android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		startActivityForResult(intent, LOAD_IMAGE_ACTIVITY_REQUEST_CODE);
	}

	private void publishShare() {
		EditText view = (EditText) findViewById(R.id.share_content);
		final String shareContent = view.getText().toString();

		AsyncTask<Void, Void, RestMethodResult<TextResource>> task = new AsyncTask<Void, Void, RestMethodResult<TextResource>>() {

			@Override
			protected RestMethodResult<TextResource> doInBackground(Void... params) {
				Map share = new HashMap();
				share.put(COL_NAME_CONTENT, shareContent);

				share.put(ShareConst.DATA_IMAGE_KEY, imageFileNames);

				ShareProcessor processor = new ShareProcessor(ShareActivity.this);
				return processor.postShare(share);
			}

			@Override
			protected void onPostExecute(RestMethodResult<TextResource> result) {
				if (result == null) {
					ViewUtils.showToast("发布信息失败.");
					return;
				}
				if (result.getStatusCode() == 200) {
					Intent intent = new Intent();
					intent.putExtra(COL_NAME_CONTENT, shareContent);
					intent.putStringArrayListExtra(ShareConst.DATA_IMAGE_KEY,
							(ArrayList<String>) imageFileNames);

					setResult(RESULT_OK, intent);
					finish();
				} else {
					ViewUtils.showToast(result.getResource().getText());
					return;
				}
			}

		};

		task.execute((Void) null);
	}
}
