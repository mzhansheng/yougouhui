package com.seekon.yougouhui.func;

import java.io.Serializable;

import com.seekon.yougouhui.util.PinyinUtils;

public class PinyinEntity implements Serializable{

	private static final long serialVersionUID = 2288876020358229018L;

	private String name;
	
	private String pinyinName;

	public PinyinEntity() {
		super();
	}

	public PinyinEntity(String name) {
		super();
		this.name = name;
		
		pinyinName = PinyinUtils.getPinYin(name);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
		
		pinyinName = PinyinUtils.getPinYin(name);
	}

	public String getPinyinName() {
		return pinyinName;
	}
	
	public String getFirstLetter() {
		return pinyinName == null ? null : new String(new char[] { pinyinName.charAt(0) });
	}
}
