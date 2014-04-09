package com.seekon.yougouhui.func.profile.shop;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;

import com.seekon.yougouhui.func.DataConst;
import com.seekon.yougouhui.rest.RestMethodResult;
import com.seekon.yougouhui.rest.resource.JSONObjResource;
import com.seekon.yougouhui.service.ContentProcessor;
import com.seekon.yougouhui.util.JSONUtils;
import com.seekon.yougouhui.util.Logger;

public class ShopTradeProcessor extends ContentProcessor {

	private static ShopTradeProcessor instance = null;
	
	private static Object lock = new Object();
	
	public static ShopTradeProcessor getInstance(Context mContext){
		synchronized (lock) {
			if(instance == null){
				instance = new ShopTradeProcessor(mContext);
			}
		}
		return instance;
	}
	
	public ShopTradeProcessor(Context mContext) {
		super(mContext, ShopTradeData.COL_NAMES, ShopTradeConst.CONTENT_URI);
	}

	public RestMethodResult<JSONObjResource> saveShopTrades(ShopEntity shop, List<TradeEntity> trades){
		String shopId = shop.getUuid();
		RestMethodResult<JSONObjResource> result = new UpdateShopTradesMethod(mContext, shopId, trades).execute();
		if(result.getStatusCode() == 200){
			try {
				for(TradeEntity trade : shop.getTrades()){//删除原有的主营业务
					JSONObject jsonObj = new JSONObject();
					JSONUtils.putJSONValue(jsonObj, DataConst.COL_NAME_UUID, trade.getUuid());
					super.deleteContentProvider(jsonObj, ShopTradeConst.CONTENT_URI);
				}
				
				JSONArray tradeList = result.getResource()
						.getJSONArray(ShopConst.NAME_REQUEST_PARAMETER_TRADES);// 设置tradelist主营业务
				if (tradeList != null && tradeList.length() > 0) {
					for (int i = 0; i < tradeList.length(); i++) {
						JSONObject trade = tradeList.getJSONObject(i);
						JSONUtils.putJSONValue(trade, ShopTradeConst.COL_NAME_SHOP_ID,
								shopId);
						super.updateContentProvider(trade, ShopTradeData.COL_NAMES,
								ShopTradeConst.CONTENT_URI);
					}
				}
			} catch (JSONException e) {
				Logger.warn(TAG, e.getMessage());
			}
		}
		return result;
	}
}