package com.seekon.yougouhui.activity.profile;

import java.util.Map;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;

import com.seekon.yougouhui.R;
import com.seekon.yougouhui.func.discover.share.CommentData;
import com.seekon.yougouhui.func.discover.share.ShareConst;
import com.seekon.yougouhui.func.discover.share.ShareData;
import com.seekon.yougouhui.func.discover.widget.ShareUtils;

/**
 * 分享详情
 * @author undyliu
 *
 */
public class ShareDetailActivity extends Activity{
	
	private Map share = null;
	
	private ShareData shareData = null;
	
	private CommentData commentData = null;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.discover_friends_item);
		
		ActionBar actionBar = this.getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);

		Intent intent = this.getIntent();
		String shareId = intent.getStringExtra(ShareConst.COL_NAME_SHARE_ID);
		
		shareData = new ShareData(this);
		commentData = new CommentData(this);
		
		loadShare(shareId);
		updateView();
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int itemId = item.getItemId();
		switch (itemId) {
		case android.R.id.home:
			this.finish();
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}
	
	private void loadShare(String shareId){
		share = shareData.getShareDataById(shareId);
		share.put(ShareConst.DATA_IMAGE_KEY, ShareUtils.getShareImagesFromLocal(this, shareId));
		share.put(ShareConst.DATA_COMMENT_KEY, commentData.getCommentData(shareId));
	}
	
	/**
	 * TODO:此方法从FriendShareActivity类中拷贝过来的，需进行重构
	 * @param shareId
	 * @return
	 */

	
	private void updateView(){
		ShareUtils.updateShareDetailView(share, this, findViewById(R.id.share_detail));
	}
}
