package com.seekon.yougouhui.func.sale;

import java.util.ArrayList;
import java.util.List;

import com.seekon.yougouhui.file.FileEntity;
import com.seekon.yougouhui.func.Entity;
import com.seekon.yougouhui.func.shop.ShopEntity;
import com.seekon.yougouhui.func.user.UserEntity;

public class SaleEntity extends Entity {

	private static final long serialVersionUID = 2136211534116509932L;

	private String title;
	private String content;
	private long startDate;
	private long endDate;
	private ShopEntity shop;
	private String tradeId;
	private int visitCount;
	private int discussCount;
	private UserEntity publisher;
	private long publishTime;
	private String status;
	private String img;
	private List<FileEntity> images = new ArrayList<FileEntity>();

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public ShopEntity getShop() {
		return shop;
	}

	public void setShop(ShopEntity shop) {
		this.shop = shop;
	}

	public String getTradeId() {
		return tradeId;
	}

	public void setTradeId(String tradeId) {
		this.tradeId = tradeId;
	}

	public int getVisitCount() {
		return visitCount;
	}

	public void setVisitCount(int visitCount) {
		this.visitCount = visitCount;
	}

	public int getDiscussCount() {
		return discussCount;
	}

	public void setDiscussCount(int discussCount) {
		this.discussCount = discussCount;
	}

	public long getStartDate() {
		return startDate;
	}

	public void setStartDate(long startDate) {
		this.startDate = startDate;
	}

	public long getEndDate() {
		return endDate;
	}

	public void setEndDate(long endDate) {
		this.endDate = endDate;
	}

	public UserEntity getPublisher() {
		return publisher;
	}

	public void setPublisher(UserEntity publisher) {
		this.publisher = publisher;
	}

	public long getPublishTime() {
		return publishTime;
	}

	public void setPublishTime(long publishTime) {
		this.publishTime = publishTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public List<FileEntity> getImages() {
		return images;
	}

	public void setImages(List<FileEntity> images) {
		this.images = images;
	}

}
