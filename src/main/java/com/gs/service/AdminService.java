package com.gs.service;

import com.gs.bean.Admin;
import com.gs.bean.Customer;
import com.gs.bean.User;
import com.gs.common.bean.Pager;

import java.util.List;

/**
 * Created by WangGenshen on 5/16/16.
 */
public interface AdminService extends BaseService<Admin, String> {

    public int updateLoginTime(String id);
    public int updatePassword(Admin admin);

    public List<Admin> queryByPagerAndCriteria(Pager pager, Admin admin);

    public int countByCriteria(Admin admin);

}
