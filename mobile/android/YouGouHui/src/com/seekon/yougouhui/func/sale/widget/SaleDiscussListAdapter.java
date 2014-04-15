package com.seekon.yougouhui.func.sale.widget;

import static com.seekon.yougouhui.func.DataConst.COL_NAME_UUID;

import java.util.List;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.seekon.yougouhui.R;
import com.seekon.yougouhui.func.RunEnv;
import com.seekon.yougouhui.func.discover.share.widget.UserClickListener;
import com.seekon.yougouhui.func.sale.SaleDiscussConst;
import com.seekon.yougouhui.func.sale.SaleDiscussEntity;
import com.seekon.yougouhui.func.sale.SaleDiscussProcessor;
import com.seekon.yougouhui.func.user.UserEntity;
import com.seekon.yougouhui.rest.RestMethodResult;
import com.seekon.yougouhui.rest.resource.JSONObjResource;
import com.seekon.yougouhui.util.ViewUtils;

public class SaleDiscussListAdapter extends BaseAdapter {

	private Context context;
	
	private List<SaleDiscussEntity> discussList;

	public SaleDiscussListAdapter(Context context,
			List<SaleDiscussEntity> discussList) {
		super();
		this.context = context;
		this.discussList = discussList;
	}

	@Override
	public int getCount() {
		return discussList.size();
	}

	@Override
	public Object getItem(int position) {
		return discussList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public void addSaleDiscuss(SaleDiscussEntity discuss){
		this.discussList.add(discuss);
		this.notifyDataSetChanged();
	}
	
	public void updateData(List<SaleDiscussEntity> discussList){
		this.discussList = discussList;
		this.notifyDataSetChanged();
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(
					R.layout.base_comment_item, null, false);
			holder.view = convertView;
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		final SaleDiscussEntity discuss = (SaleDiscussEntity) getItem(position);
		UserEntity publisher = discuss.getPublisher();
		final String discussId = discuss.getUuid();

		TextView contentView = (TextView) convertView
				.findViewById(R.id.share_comment_content);
		contentView.setText(discuss.getContent());

		// 设置朋友的点击监听
		TextView publisherView = (TextView) convertView
				.findViewById(R.id.share_comment_publisher);
		publisherView.getPaint().setFakeBoldText(true);// TODO:使用样式表来处理
		publisherView.setText(publisher.getName());
		publisherView.setOnClickListener(new UserClickListener(publisher, (Activity)context,
				-1));

		// 设置评论的删除监听
		ImageView commentDelete = (ImageView) convertView
				.findViewById(R.id.b_comment_delete);
		if (publisher.equals(RunEnv.getInstance().getUser())) {
			commentDelete.setVisibility(View.VISIBLE);
			commentDelete.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					AsyncTask<Void, Void, RestMethodResult<JSONObjResource>> task = new AsyncTask<Void, Void, RestMethodResult<JSONObjResource>>() {

						@Override
						protected RestMethodResult<JSONObjResource> doInBackground(
								Void... params) {
							
							return SaleDiscussProcessor.getInstance(context).deleteDiscuss(discussId);
						}

						@Override
						protected void onPostExecute(
								RestMethodResult<JSONObjResource> result) {
							int status = result.getStatusCode();
							if (status == 200) {
								ContentResolver resolver = context.getContentResolver();
								String where = COL_NAME_UUID + "=?";
								String[] selectionArgs = new String[] { discussId };
								resolver.delete(SaleDiscussConst.CONTENT_URI, where, selectionArgs);

								discussList.remove(discuss);
								SaleDiscussListAdapter.this.notifyDataSetChanged();
							} else {
								ViewUtils.showToast("删除失败.");
							}
						}
					};

					task.execute((Void) null);
				}
			});
		} else {
			commentDelete.setVisibility(View.GONE);
		}

		return convertView;
	}

	class ViewHolder {
		View view;
	}
}