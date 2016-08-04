package com.gs.controller;

import com.gs.bean.*;
import com.gs.common.Constants;
import com.gs.common.bean.ComboBox4EasyUI;
import com.gs.common.bean.ControllerResult;
import com.gs.common.bean.Pager;
import com.gs.common.bean.Pager4EasyUI;
import com.gs.common.util.DateFormatUtil;
import com.gs.common.util.DateParseUtil;
import com.gs.common.util.PagerUtil;
import com.gs.common.web.ADSServerUtil;
import com.gs.common.web.ServletContextUtil;
import com.gs.common.web.SessionUtil;
import com.gs.net.parser.Common;
import com.gs.net.parser.FileDownloadServer;
import com.gs.service.DeviceGroupService;
import com.gs.service.DeviceResourceService;
import com.gs.service.DeviceService;
import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by WangGenshen on 5/16/16.
 */
@Controller
@RequestMapping("/devres")
public class DeviceResourceController {

    private static final Logger logger = LoggerFactory.getLogger(DeviceResourceController.class);

    @Resource
    private DeviceResourceService deviceResourceService;
    @Resource
    private DeviceGroupService deviceGroupService;
    @Resource
    private DeviceService deviceService;

    @ResponseBody
    @RequestMapping(value = "add", method = RequestMethod.POST)
    public ControllerResult add(DeviceResource deviceResource, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            Customer customer = (Customer) session.getAttribute(Constants.SESSION_CUSTOMER);
            deviceResource.setCustomerId(customer.getId());
            deviceResource.setPublishLog(PublishLog.NOT_SUBMIT_TO_CHECK);
            deviceResourceService.insert(deviceResource);
            return ControllerResult.getSuccessResult("成功添加消息发布");
        }
        return null;
    }

    @RequestMapping(value = "list_page", method = RequestMethod.GET)
    public String toListPage(HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            return "publish/publishes";
        } else {
            return "redirect:/index";
        }
    }

    @RequestMapping(value = "list_page_checking", method = RequestMethod.GET)
    public String toListPageChecking(HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            return "publish/publishes_check";
        } else {
            return "redirect:/index";
        }
    }

    @RequestMapping(value = "list_page_checked", method = RequestMethod.GET)
    public String toListPageChecked(HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            return "publish/publishes_checked";
        } else {
            return "redirect:/index";
        }
    }

    @RequestMapping(value = "list_page_finish", method = RequestMethod.GET)
    public String toListPageFinish(HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            return "publish/publishes_finish";
        } else {
            return "redirect:/index";
        }
    }

    @RequestMapping(value = "list_page_admin/{customerId}", method = RequestMethod.GET)
    public ModelAndView toListPageAdmin(@PathVariable("customerId") String customerId, HttpSession session) {
        if (SessionUtil.isAdmin(session)) {
            ModelAndView mav = new ModelAndView("publish/publishes_admin");
            mav.addObject("customerId", customerId);
            return mav;
        } else {
            return null;
        }
    }

    @ResponseBody
    @RequestMapping(value = "list", method = RequestMethod.GET)
    public List<DeviceResource> list(HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            logger.info("显示所有消息发布");
            return deviceResourceService.queryAll();
        } else {
            return null;
        }
    }

    @ResponseBody
    @RequestMapping(value = "list_pager", method = RequestMethod.GET)
    public Pager4EasyUI<DeviceResource> listPager(@Param("page")String page, @Param("rows")String rows, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            logger.info("分页显示消息发布");
            Customer customer = (Customer) session.getAttribute(Constants.SESSION_CUSTOMER);
            int total = deviceResourceService.count();
            Pager pager = PagerUtil.getPager(page, rows, total);
            List<DeviceResource> deviceResources = deviceResourceService.queryByPagerAndCustomerId(pager, customer.getId());
            for (DeviceResource dr : deviceResources) {
                dr.setStartTimeStr(DateFormatUtil.format(dr.getStartTime(), Constants.DATETIME_PATTERN));
                dr.setEndTimeStr(DateFormatUtil.format(dr.getEndTime(), Constants.DATETIME_PATTERN));
            }
            return new Pager4EasyUI<DeviceResource>(pager.getTotalRecords(), deviceResources);
        } else {
            logger.info("客户未登录，不能分页显示消息发布");
            return null;
        }
    }

    @ResponseBody
    @RequestMapping(value = "search_pager", method = RequestMethod.GET)
    public Pager4EasyUI<DeviceResource> searchPager(@Param("page")String page, @Param("rows")String rows, DeviceResource deviceResource, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            logger.info("分页显示消息发布");
            Customer customer = (Customer) session.getAttribute(Constants.SESSION_CUSTOMER);
            int total = deviceResourceService.countByCriteria(deviceResource, customer.getId());
            Pager pager = PagerUtil.getPager(page, rows, total);
            List<DeviceResource> deviceResources = deviceResourceService.queryByPagerAndCriteria(pager, deviceResource, customer.getId());
            for (DeviceResource dr : deviceResources) {
                if (dr.getStartTime() != null) {
                    dr.setStartTimeStr(DateFormatUtil.format(dr.getStartTime(), Constants.DATETIME_PATTERN));
                }
                if (dr.getEndTime() != null) {
                    dr.setEndTimeStr(DateFormatUtil.format(dr.getEndTime(), Constants.DATETIME_PATTERN));
                }
            }
            return new Pager4EasyUI<DeviceResource>(pager.getTotalRecords(), deviceResources);
        } else {
            logger.info("客户未登录，不能分页显示消息发布");
            return null;
        }
    }

    @ResponseBody
    @RequestMapping(value = "search_pager_admin/{customerId}", method = RequestMethod.GET)
    public Pager4EasyUI<DeviceResource> searchPagerAdmin(@PathVariable("customerId") String customerId, @Param("page")String page, @Param("rows")String rows, DeviceResource deviceResource, HttpSession session) {
        if (SessionUtil.isAdmin(session)) {
            logger.info("分页显示消息发布");
            int total = deviceResourceService.countByCriteria(deviceResource, customerId);
            Pager pager = PagerUtil.getPager(page, rows, total);
            List<DeviceResource> deviceResources = deviceResourceService.queryByPagerAndCriteria(pager, deviceResource, customerId);
            for (DeviceResource dr : deviceResources) {
                if (dr.getStartTime() != null) {
                    dr.setStartTimeStr(DateFormatUtil.format(dr.getStartTime(), Constants.DATETIME_PATTERN));
                }
                if (dr.getEndTime() != null) {
                    dr.setEndTimeStr(DateFormatUtil.format(dr.getEndTime(), Constants.DATETIME_PATTERN));
                }
            }
            return new Pager4EasyUI<DeviceResource>(pager.getTotalRecords(), deviceResources);
        } else {
            logger.info("管理员未登录，不能分页显示消息发布");
            return null;
        }
    }

    @RequestMapping(value = "query/{id}", method = RequestMethod.GET)
    public ModelAndView queryById(@PathVariable("id") String id, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            logger.info("根据消息发布id: " + id + "查询消息发布");
            ModelAndView mav = new ModelAndView("device/device_info");
            DeviceResource deviceResource = deviceResourceService.queryById(id);
            mav.addObject("deviceResource", deviceResource);
            return mav;
        }
        return null;
    }

    @ResponseBody
    @RequestMapping(value = "update", method = RequestMethod.POST)
    public ControllerResult update(DeviceResource deviceResource, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            logger.info("更新消息发布");
            deviceResource.setStartTime(DateParseUtil.parseDate(deviceResource.getStartTimeStr(), Constants.DATETIME_PATTERN));
            deviceResource.setEndTime(DateParseUtil.parseDate(deviceResource.getEndTimeStr(), Constants.DATETIME_PATTERN));
            deviceResourceService.update(deviceResource);
            return ControllerResult.getSuccessResult("成功更新消息发布");
        } else {
            return ControllerResult.getFailResult("更新消息发布失败");
        }
    }

    @ResponseBody
    @RequestMapping(value = "inactive", method = RequestMethod.GET)
    public ControllerResult inactive(@Param("id")String id, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            deviceResourceService.inactive(id);
            return ControllerResult.getSuccessResult("冻结消息发布成功");
        } else {
            return ControllerResult.getFailResult("没有权限冻结消息发布");
        }
    }

    @ResponseBody
    @RequestMapping(value = "active", method = RequestMethod.GET)
    public ControllerResult active(@Param("id")String id, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            deviceResourceService.active(id);
            return ControllerResult.getSuccessResult("已解除消息发布冻结");
        } else {
            return ControllerResult.getFailResult("没有权限激活消息发布");
        }
    }

    @ResponseBody
    @RequestMapping(value = "check", method = RequestMethod.GET)
    public ControllerResult check(@Param("id")String id, @Param("checkStatus") String checkStatus, HttpSession session) {
        if (SessionUtil.isCustomer(session)) {
            if (checkStatus != null && checkStatus.equals("checking")) { // 提交审核
                deviceResourceService.check(id, checkStatus);
                deviceResourceService.updatePublishLog(id, PublishLog.SUBMIT_TO_CHECK);
                return ControllerResult.getSuccessResult("消息发布已提交审核");
            } else if (checkStatus != null && checkStatus.equals("checked")){ // 审核
                deviceResourceService.check(id, checkStatus);
                // 一旦审核,则需要通知客户端下载文件,并完成发布操作，只有完成发布操作后，整个审核才算完毕
                DeviceResource deviceResource = deviceResourceService.queryWithDeviceResourceById(id);
                String result = ADSServerUtil.getADSServerFromServletContext().writeFileDownload(deviceResource);
                if (result.equals(Common.DEVICE_NOT_CONNECT)) {
                    return ControllerResult.getFailResult("消息发布: 终端未连接上服务器,当终端连接上服务器后,此消息会自动完成发布");
                } else if (result.equals(Common.DEVICE_IS_HANDLING)) {
                    return ControllerResult.getFailResult("消息发布: 终端尚在处理之前的消息发布，处理完后服务端会自动发送消息发布到终端");
                } else if (result.equals(Common.DEVICE_WRITE_OUT)) {
                    deviceResourceService.updatePublishLog(id, PublishLog.FILE_DOWNLOADING);
                    return ControllerResult.getSuccessResult("消息发布开始处理,请关注发布日志");
                }
            }
            return ControllerResult.getFailResult("您进行了不支持的操作......");
        } else {
            return ControllerResult.getFailResult("没有权限提交消息发布审核");
        }
    }

    @ResponseBody
    @RequestMapping(value = "list_combo/{id}", method = RequestMethod.GET)
    public List<ComboBox4EasyUI> listCombo(@PathVariable("id") String id, HttpSession session) {
        List<ComboBox4EasyUI> comboBox4EasyUIs = null;
        if (SessionUtil.isCustomer(session)) {
            String deviceGroupId = deviceResourceService.queryByDeviceId(id);
            comboBox4EasyUIs = new ArrayList<ComboBox4EasyUI>();
            List<DeviceGroup> deviceGroups = deviceGroupService.queryAll();
            for (DeviceGroup dg : deviceGroups) {
                ComboBox4EasyUI comboBox4EasyUI = new ComboBox4EasyUI();
                comboBox4EasyUI.setId(dg.getId());
                comboBox4EasyUI.setText(dg.getName());
                if (dg.getId().equals(deviceGroupId)) {
                    comboBox4EasyUI.setSelected(true);
                }
                comboBox4EasyUIs.add(comboBox4EasyUI);
            }
        }
        return comboBox4EasyUIs;
    }


    @InitBinder
    public void initBinder(WebDataBinder binder) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }

}
