<%--
  Created by IntelliJ IDEA.
  User: WangGenshen
  Date: 5/18/16
  Time: 19:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
    String path = request.getContextPath();
%>
<html>
<head>
    <title>客户列表-青岛宝瑞无线广告管理系统</title>
    <meta charset="UTF-8"/>
    <link rel="stylesheet" href="<%=path %>/js/jquery-easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" href="<%=path %>/js/jquery-easyui/themes/icon.css"/>
    <link rel="stylesheet" href="<%=path %>/css/site_main.css"/>

    <script src="<%=path %>/js/jquery.min.js"></script>
    <script src="<%=path %>/js/jquery.form.js"></script>
    <script src="<%=path %>/js/jquery-easyui/jquery.easyui.min.js"></script>
    <script src="<%=path %>/js/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
    <script src="<%=path %>/js/site_easyui.js"></script>

    <script>
        $(function() {
            setPagination("#list")
        });

        function add() {
            toValidate("addForm");
            if (validateForm("addForm")) {
                $.post("<%=path %>/customer/add",
                        $("#addForm").serialize(),
                        function (data) {
                            if (data.result == "success") {
                                $("#addWin").window("close");
                                dataGridReload("list");
                                $("#addForm").form("clear");
                            } else {
                                $.messager.alert("提示", data.message, "info");
                            }
                        }
                );
            }
        }

        function showEdit() {
            var row = selectedRow("list");
            if (row) {
                $("#editForm").form("load", row);
                openWin("editWin");
            } else {
                $.messager.alert("提示", "请选择需要修改的客户信息", "info");
            }
        }

        function edit() {
            toValidate("editForm");
            if (validateForm("editForm")) {
                $.post("<%=path %>/customer/update",
                        $("#editForm").serialize(),
                        function (data) {
                            if (data.result == "success") {
                                closeWin("editWin");
                                $.messager.alert("提示", data.message, "info", function () {
                                    dataGridReload("list");
                                });
                            } else {
                                $("#errMsg").html(data.message);
                            }
                        }
                );
            }
        }

        function inactive() {
            var row = selectedRow("list");
            if (row) {
                if (row.status == 'N') {
                    $.messager.alert("提示", "客户账号不可用,无需冻结", "info");
                } else {
                    $.get("<%=path %>/customer/inactive?id=" + row.id,
                            function (data) {
                                if (data.result == "success") {
                                    $.messager.alert("提示", data.message, "info");
                                    dataGridReload("list");
                                }
                            });
                }
            } else {
                $.messager.alert("提示", "请选择需要冻结的客户账号", "info");
            }
        }

        function active() {
            var row = selectedRow("list");
            if (row) {
                if (row.status == 'Y') {
                    $.messager.alert("提示", "客户账号可用,无需激活", "info");
                } else {
                    $.get("<%=path %>/customer/active?id=" + row.id,
                            function (data) {
                                if (data.result == "success") {
                                    $.messager.alert("提示", data.message, "info");
                                    dataGridReload("list");
                                }
                            });
                }
            } else {
                $.messager.alert("提示", "请选择需要激活的客户账号", "info");
            }
        }
    </script>
</head>
<body>
<table id="list" class="easyui-datagrid" toolbar="#tb" style="height:100%;"
       data-options="
        url:'<%=path %>/customer/list_pager',
        method:'get',
				rownumbers:true,
				singleSelect:true,
				autoRowHeight:false,
				pagination:true,
				border:false,
				pageSize:20,
				rowStyler: function(index,row){
					if (row.role == 'super'){
						return 'background-color:#ccc;';
					} else if (row.status == 'N') {
					    return 'color:red;';
					}
				}">
    <thead>
    <tr>
        <th field="id" checkbox="true" width="50">用户ID</th>
        <th field="email" width="150">邮箱</th>
        <th field="name" width="100">姓名</th>
        <th field="phone" width="80">手机号</th>
        <th field="address" width="200">地址</th>
        <th field="createTime" width="150" formatter="formatterDate">创建时间</th>
        <th field="loginTime" width="150" formatter="formatterDate">最近登录时间</th>
        <th field="status" width="50" formatter="formatterStatus">状态</th>
    </tr>
    </thead>
</table>
<div id="tb">
    <a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-add" plain="true"
       onclick="openWinFitPos('addWin');">添加</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-edit" plain="true"
       onclick="showEdit();">修改</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-remove" plain="true"
       onclick="inactive()">冻结</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-ok" plain="true"
       onclick="active()">激活</a>
</div>

<div class="easyui-window site_win_small input_big" id="addWin" data-options="title:'添加客户',resizable:false,mode:true,closed:true">
    <form:form id="addForm" modelAttribute="customer">
        <table>
            <tr>
                <td>邮箱:</td>
                <td><input type="text" name="email" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,validType:'email',novalidate:true"/></td>
            </tr>
            <tr>
                <td>密码:</td>
                <td><input type="password" name="password" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,validType:'length[6,20]',novalidate:true"/></td>
            </tr>
            <tr>
                <td>姓名:</td>
                <td><input type="text" name="name" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>手机:</td>
                <td><input type="text" name="phone" class="easyui-numberbox easyui-textbox"
                           data-options="required:true,validType:'length[11,11]',novalidate:true"/></td>
            </tr>
            <tr>
                <td>地址:</td>
                <td><input type="text" name="address" class="easyui-textbox"/></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <button type="button" onclick="add();">确认</button>
                </td>
            </tr>
        </table>
    </form:form>
</div>

<div class="easyui-window site_win_small input_big" id="editWin" data-options="title:'修改账号信息',resizable:false,mode:true,closed:true">
    <div id="errMsg"></div>
    <form id="editForm" method="post" modelAttribute="customer">
        <input type="hidden" name="id" />
        <table>
            <tr>
                <td>邮箱:</td>
                <td><input type="text" name="email" class="easyui-textbox" readonly="true"/></td>
            </tr>
            <tr>
                <td>姓名:</td>
                <td><input type="text" name="name" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>手机:</td>
                <td><input type="text" name="phone" class="easyui-numberbox easyui-textbox"
                           data-options="required:true,validType:'length[11,11]',novalidate:true"/></td>
            </tr>
            <tr>
                <td>地址:</td>
                <td><input type="text" name="address" class="easyui-textbox"/></td>
            </tr>
            <tr>
                <td><button type="button" onclick="closeWin('editWin');">取消</button></td>
                <td>
                    <button type="button" onclick="edit();">确认</button>
                </td>
            </tr>
        </table>
    </form>
</div>

</body>
</html>
