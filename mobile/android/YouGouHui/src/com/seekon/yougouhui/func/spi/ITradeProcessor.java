package com.seekon.yougouhui.func.spi;

import com.seekon.yougouhui.rest.RestMethodResult;
import com.seekon.yougouhui.rest.resource.JSONArrayResource;

public interface ITradeProcessor {

	public RestMethodResult<JSONArrayResource> getTrades();
}
