package com.seekon.yougouhui.func.widget;

import java.util.Date;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.seekon.yougouhui.R;
import com.seekon.yougouhui.util.DateUtils;

public abstract class DateIndexedListAdapter extends
		EntityListAdapter<DateIndexedEntity> {

	public DateIndexedListAdapter(Context context,
			List<DateIndexedEntity> dataList) {
		super(context, dataList);
	}

	@Override
	public View getView(int position, View view, ViewGroup parent) {

		ViewHolder holder = null;
		if (view == null) {
			holder = new ViewHolder();
			view = LayoutInflater.from(context).inflate(
					R.layout.date_indexed_list_item, null, false);
			holder.view = view;
			view.setTag(holder);
		} else {
			holder = (ViewHolder) view.getTag();
		}

		DateIndexedEntity dateIndexedEntity = (DateIndexedEntity) getItem(position);

		Date date = dateIndexedEntity.getDate();
		TextView dateView = (TextView) view.findViewById(R.id.item_day_field);
		dateView.setText(DateUtils.getDayOfMoth(date) + "日");
		dateView.getPaint().setFakeBoldText(true);// TODO:使用样式表来处理

		TextView monthView = (TextView) view.findViewById(R.id.item_month_field);
		monthView.setText(DateUtils.getMonth(date) + "月");
		monthView.getPaint().setFakeBoldText(true);

		int itemCount = dateIndexedEntity.getItemCount();
		((TextView) view.findViewById(R.id.item_count_field)).setText(itemCount
				+ "笔");

		ListView subItemListView = (ListView) view.findViewById(R.id.sub_item_list);
		initSubItemListView(subItemListView, dateIndexedEntity.getSubItemList());

		return view;
	}

	public abstract void initSubItemListView(ListView subItemListView,
			List subItemDataList);

	class ViewHolder {
		View view;
	}
}
