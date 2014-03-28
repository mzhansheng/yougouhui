package com.seekon.yougouhui.func.discover.share;

import android.net.Uri;

import com.seekon.yougouhui.func.DataConst;

public interface ShareConst extends DataConst {

	public static final String TABLE_NAME = "e_share";

	public static final String AUTHORITY = "com.seekon.yougouhui.shares";

	public static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY
			+ "/" + TABLE_NAME);

	public static final String COL_NAME_PUBLISHER = "publisher";
	public static final String COL_NAME_PUBLISH_TIME = "publish_time";
	public static final String COL_NAME_ACTIVITY_ID = "activity_id";
	public static final String COL_NAME_SHARE_ID = "share_id";
	
	public final String DATA_IMAGE_KEY = "images";
	public final String DATA_COMMENT_KEY = "comments";

}
