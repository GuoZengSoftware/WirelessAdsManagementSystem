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
    <title>版本列表-青岛宝瑞无线广告管理系统</title>
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
                if (checkFile("file", 0, '.jpg,.bmp,.png', 10)) {
                    $('#addForm').ajaxSubmit({
                        url:'<%=path %>/version/add',
                        type:'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.result == "success") {
                                $("#addWin").window("close");
                                dataGridReload("list");
                                $("#addForm").form("clear");
                            } else {
                                $.messager.alert("提示", data.message, "info");
                            }
                        }
                    });
                }
            }
        }

        function showEdit() {
            var row = selectedRow("list");
            if (row) {
                $("#editForm").form("load", row);
                openWin("editWin");
            } else {
                $.messager.alert("提示", "请选择需要修改的版本信息", "info");
            }
        }

        function edit() {
            toValidate("editForm");
            if (validateForm("editForm")) {
                if (checkFile("file", 1, '.jpg,.bmp,.png', 10)) {
                    $('#editForm').ajaxSubmit({
                        url: '<%=path %>/version/update',
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.result == "success") {
                                closeWin("editWin");
                                dataGridReload("list");
                                $("#editForm").form("clear");
                            } else {
                                $.messager.alert("提示", data.message, "info");
                            }
                        }
                    });
                }
            }
        }

        function inactive() {
            var row = selectedRow("list");
            if (row) {
                if (row.status == 'N') {
                    $.messager.alert("提示", "版本信息不可用,无需冻结", "info");
                } else {
                    $.get("<%=path %>/version/inactive?id=" + row.id,
                            function (data) {
                                if (data.result == "success") {
                                    $.messager.alert("提示", data.message, "info");
                                    dataGridReload("list");
                                }
                            });
                }
            } else {
                $.messager.alert("提示", "请选择需要冻结的版本信息", "info");
            }
        }

        function active() {
            var row = selectedRow("list");
            if (row) {
                if (row.status == 'Y') {
                    $.messager.alert("提示", "版本信息可用,无需激活", "info");
                } else {
                    $.get("<%=path %>/version/active?id=" + row.id,
                            function (data) {
                                if (data.result == "success") {
                                    $.messager.alert("提示", data.message, "info");
                                    dataGridReload("list");
                                }
                            });
                }
            } else {
                $.messager.alert("提示", "请选择需要激活的版本信息", "info");
            }
        }

        function viewImg() {
            var row = selectedRow("list");
            if (row) {
                $("#verImg").attr("src", "<%=path %>/" + row.path);
               openWin("viewWin");
            } else {
                $.messager.alert("提示", "请选择需要查看的版本信息", "info");
            }
        }

        function doSearch() {
            $("#list").datagrid({
                url:'<%=path %>/version/search_pager',
                pageSize:20,
                queryParams:getQueryParams("list", "searchForm")
            });
            setPagination("#list");
        }

        function searchAll() {
            $("#searchForm").form("clear");
            $("#list").datagrid({
                url:'<%=path %>/version/search_pager',
                pageSize:20,
                queryParams:getQueryParams("list", "searchForm")
            });
            setPagination("#list");
        }

        function refreshAll() {
            $("#list").datagrid("reload");
        }

    </script>
</head>
<body>
<table id="list" class="easyui-datagrid" toolbar="#tb" style="height:100%;"
       data-options="
        url:'<%=path %>/version/search_pager',
        method:'get',
				rownumbers:true,
				singleSelect:true,
				autoRowHeight:false,
				pagination:true,
				border:false,
				pageSize:20,
				rowStyler: function(index,row){
					if (row.status == 'N') {
					    return 'color:red;';
					}
				}">
    <thead>
    <tr>
        <th field="id" checkbox="true" width="50">用户ID</th>
        <th field="name" width="60">名称</th>
        <th field="areaCount" width="80">区域个数</th>
        <th field="fileName" width="150">文件名</th>
        <th field="path" width="200" formatter="formatterLong">路径</th>
        <th field="des" width="100">描述</th>
        <th field="createTime" width="120" formatter="formatterDate">创建时间</th>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-tip" plain="true"
       onclick="viewImg()">查看图片</a>
    <div class="input_small">
        <form id="searchForm" modalAttribute="resource">
            名称:<input type="text" name="name" class="easyui-textbox"/>
            状态:<select name="status" class="easyui-combobox" data-options="valueField: 'id',textField: 'text',panelHeight:'auto',
                    data: [{
                        id: 'Y',
                        text: '可用'
                    },{
                        id: 'N',
                        text: '不可用'
                    }]">
        </select>
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
               onclick="doSearch();">搜索</a>
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
               onclick="searchAll();">查询所有</a>
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-reload'"
               onclick="refreshAll();">刷新</a>
        </form>
    </div>
</div>

<div class="easyui-window site_win_normal input_big" id="addWin" data-options="title:'添加版本',resizable:false,mode:true,closed:true">
    <form:form id="addForm" modelAttribute="resource" enctype="multipart/form-data">
        <table>
            <tr>
                <td>名称:</td>
                <td><input type="text" name="name" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>区域个数:</td>
                <td><input type="text" name="areaCount" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>选择文件:</td>
                <td><input name="file" class="easyui-validatebox easyui-filebox" data-options="prompt:'请选择文件',buttonText:'选择文件'"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>描述:</td>
                <td><input name="des" class="easyui-textbox" data-options="multiline:true" style="height:100px;"/></td>
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

<div class="easyui-window site_win_normal input_big" id="editWin" data-options="title:'修改版本',resizable:false,mode:true,closed:true">
    <div id="errMsg"></div>
    <form id="editForm" method="post" modelAttribute="resource" enctype="multipart/form-data">
        <input type="hidden" name="id" />
        <table>
            <tr>
                <td>名称:</td>
                <td><input type="text" name="name" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>区域个数:</td>
                <td><input type="text" name="areaCount" class="easyui-validatebox easyui-textbox"
                           data-options="required:true,novalidate:true"/></td>
            </tr>
            <tr>
                <td>选择文件:</td>
                <td><input name="file" class="easyui-filebox" data-options="prompt:'请选择文件',buttonText:'选择文件'" /></td>
            </tr>
            <tr>
                <td>描述:</td>
                <td><input name="des" class="easyui-textbox" data-options="multiline:true" style="height:100px;"/></td>
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

<div class="easyui-window site_win_normal" id="viewWin" data-options="title:'版本图片',resizable:false,mode:true,closed:true">
    <div style="text-align: center;">
        <img id="verImg" src="" />
    </div>
</div>

</body>
</html>
