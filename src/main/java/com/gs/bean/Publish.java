package com.gs.bean;

import java.util.Date;

/**
 * Created by WangGenshen on 5/17/16.
 */
public class Publish {

    private String id;
    private String deviceId;
    private String deviceCode;
    private Device device;
    private String resourceName;
    private Resource resource;
    private int area;
    private String showType;
    private Date startTime;
    private Date endTime;
    private String stayTime;
    private Date publishTime;
    private String publishLog;

    private String publishPlanId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    public String getResourceName() {
        return resourceName;
    }

    public void setResourceName(String resourceName) {
        this.resourceName = resourceName;
    }

    public Resource getResource() {
        return resource;
    }

    public void setResource(Resource resource) {
        this.resource = resource;
    }

    public int getArea() {
        return area;
    }

    public void setArea(int area) {
        this.area = area;
    }

    public String getShowType() {
        return showType;
    }

    public void setShowType(String showType) {
        this.showType = showType;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getStayTime() {
        return stayTime;
    }

    public void setStayTime(String stayTime) {
        this.stayTime = stayTime;
    }

    public Date getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Date publishTime) {
        this.publishTime = publishTime;
    }

    public String getPublishLog() {
        return publishLog;
    }

    public void setPublishLog(String publishLog) {
        this.publishLog = publishLog;
    }

    public String getPublishPlanId() {
        return publishPlanId;
    }

    public void setPublishPlanId(String publishPlanId) {
        this.publishPlanId = publishPlanId;
    }
}
