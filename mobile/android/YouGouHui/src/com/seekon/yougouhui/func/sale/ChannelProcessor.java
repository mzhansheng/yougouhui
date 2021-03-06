package com.seekon.yougouhui.func.sale;

import android.content.Context;

import com.seekon.yougouhui.func.spi.IChannelProcessor;
import com.seekon.yougouhui.rest.RestMethodResult;
import com.seekon.yougouhui.rest.resource.JSONArrayResource;
import com.seekon.yougouhui.service.ContentProcessor;
import com.seekon.yougouhui.service.ProcessorCallback;
import com.seekon.yougouhui.service.ProcessorProxy;

public class ChannelProcessor extends ContentProcessor implements
		IChannelProcessor {

	private static IChannelProcessor instance = null;
	private static Object lock = new Object();

	public static IChannelProcessor getInstance(Context mContext) {
		synchronized (lock) {
			if (instance == null) {
				ProcessorProxy proxy = new ProcessorProxy();
				instance = (IChannelProcessor) proxy
						.bind(new ChannelProcessor(mContext));
			}
		}
		return instance;
	}

	private ChannelProcessor(Context mContext) {
		super(mContext, ChannelData.COL_NAMES, ChannelConst.CONTENT_URI);
	}

	public void getChannels(ProcessorCallback callback, String parentId) {
		GetChannelsMethod method = new GetChannelsMethod(mContext, parentId);
		this.execMethodWithCallback(method, callback);
	}

	public RestMethodResult<JSONArrayResource> getChannels(String parentId) {
		return (RestMethodResult) this.execMethod(new GetChannelsMethod(mContext,
				parentId));
	}
}
