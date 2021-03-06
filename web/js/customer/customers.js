var contextPath = '';

$(function() {
    setPagination("#list");
    $("#statusSearch").combobox({
        onChange:function(n, o){
            if (n != o) {
                doSearch();
            }
        }
    });
});

function add() {
    toValidate("addForm");
    if (validateForm("addForm")) {
        $.post(contextPath + "/customer/add",
            $("#addForm").serialize(),
            function (data) {
                if (data.result == "success") {
                    $("#addWin").window("close");
                    dataGridReload("list");
                    $("#addForm").form("clear");
                } else if (data.result == 'notLogin') {
                    $.messager.alert("提示", data.message, "info", function() {
                        toAdminLoginPage();
                    });
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
        $.post(contextPath + "/customer/update",
            $("#editForm").serialize(),
            function (data) {
                if (data.result == "success") {
                    closeWin("editWin");
                    $.messager.alert("提示", data.message, "info", function () {
                        dataGridReload("list");
                    });
                } else if (data.result == 'notLogin') {
                    $.messager.alert("提示", data.message, "info", function() {
                        toAdminLoginPage();
                    });
                } else {
                    $("#errMsg").html(data.message);
                }
            }
        );
    }
}

function showUpdatePwd() {
    var row = selectedRow("list");
    if (row) {
        $("#editPwdForm").form("load", row);
        $("#update_password").textbox("setValue", "");
        openWin("editPwdWin");
    } else {
        $.messager.alert("提示", "请选择需要修改密码的客户", "info");
    }
}

function updatePwd() {
    toValidate("editPwdForm");
    if (validateForm("editPwdForm")) {
        $.messager.confirm("提示", "更新该客户密码，是否继续?", function(r) {
            if (r) {
                $.post(contextPath + "/customer/update_other_pwd",
                    $("#editPwdForm").serialize(),
                    function (data) {
                        if (data.result == "success") {
                            closeWin("editPwdWin");
                            $.messager.alert("提示", data.message, "info", function () {
                                // dataGridReload("list");
                            });
                        } else if (data.result == 'notLogin') {
                            $.messager.alert("提示", data.message, "info", function() {
                                toAdminLoginPage();
                            });
                        } else {
                            $("#errMsg").html(data.message);
                        }
                    }
                );
            }
        });
    }
}

function showUpdateCheckPwd() {
    var row = selectedRow("list");
    if (row) {
        $("#editCheckPwdWin").form("load", row);
        $("#update_checkPwd").textbox("setValue", "");
        openWin("editCheckPwdWin");
    } else {
        $.messager.alert("提示", "请选择需要修改审核密码的客户", "info");
    }
}

function updateCheckPwd() {
    toValidate("editCheckPwdForm");
    if (validateForm("editCheckPwdForm")) {
        $.messager.confirm("提示", "更新该客户审核密码，是否继续?", function(r) {
            if (r) {
                $.post(contextPath + "/customer/update_other_chkpwd",
                    $("#editCheckPwdForm").serialize(),
                    function (data) {
                        if (data.result == "success") {
                            closeWin("editCheckPwdWin");
                            $.messager.alert("提示", data.message, "info", function () {
                                // dataGridReload("list");
                            });
                        } else if (data.result == 'notLogin') {
                            $.messager.alert("提示", data.message, "info", function() {
                                toAdminLoginPage();
                            });
                        } else {
                            $("#errMsg").html(data.message);
                        }
                    }
                );
            }
        });
    }
}

function inactive() {
    var row = selectedRow("list");
    if (row) {
        if (row.status == 'N') {
            $.messager.alert("提示", "客户账号不可用,无需冻结", "info");
        } else {
            $.get(contextPath + "/customer/inactive?id=" + row.id,
                function (data) {
                    if (data.result == "success") {
                        $.messager.alert("提示", data.message, "info");
                        dataGridReload("list");
                    } else if (data.result == 'notLogin') {
                        $.messager.alert("提示", data.message, "info", function() {
                            toAdminLoginPage();
                        });
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
            $.get(contextPath + "/customer/active?id=" + row.id,
                function (data) {
                    if (data.result == "success") {
                        $.messager.alert("提示", data.message, "info");
                        dataGridReload("list");
                    } else if (data.result == 'notLogin') {
                        $.messager.alert("提示", data.message, "info", function() {
                            toAdminLoginPage();
                        });
                    }
                });
        }
    } else {
        $.messager.alert("提示", "请选择需要激活的客户账号", "info");
    }
}

function doSearch() {
    $("#list").datagrid({
        url:contextPath + '/customer/search_pager',
        pageSize:defaultPageSize,
        queryParams:getQueryParams("list", "searchForm")
    });
    setPagination("#list");
}

function searchAll() {
    $("#searchForm").form("clear");
    $("#list").datagrid({
        url:contextPath + '/customer/search_pager',
        pageSize:defaultPageSize,
        queryParams:getQueryParams("list", "searchForm")
    });
    setPagination("#list");
}

function refreshAll() {
    $("#list").datagrid("reload");
}