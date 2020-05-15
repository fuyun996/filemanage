<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>外协计划表</title>
<t:base type="bootstrap,bootstrap-table,layer"></t:base>
<link rel="stylesheet" href="${webRoot}/plug-in/themes/naturebt/css/search-form.css">
<link rel="stylesheet" href="${webRoot}/plug-in/themes/bootstrap-ext/js/bootstrap-lhgdialog-curdtools.js">
</head>
<body>
	<div class="panel-body" style="padding-bottom: 0px;">
		<!-- 搜索 -->
		<div class="accordion-group">
			<div id="collapse_search" class="accordion-body collapse">
				<div class="accordion-inner">
					<div class="panel panel-default" style="margin-bottom: 0px;">
						<div class="panel-body">
							<form id="searchForm" onkeydown="if(event.keyCode==13){doSearch();return false;}">
											<div class="col-xs-12 col-sm-6 col-md-4">
									    		<label for="sysOrgCode">所属部门：</label>
									    		<div class="input-group" style="width:100%">
										    		<t:dictSelect id="sysOrgCode" field="sysOrgCode" type="select" hasLabel="false" title="申请部门" extendJson="{class:'form-control input-sm'}"   dictTable="t_s_depart"  dictField="id" dictText="departname" ></t:dictSelect>
									    		</div>
								    		</div>
											<div class="col-xs-12 col-sm-6 col-md-4">
												<label for="dlxh">电路型号：</label>
												<div class="input-group" style="width: 100%">
													<input type="text" class="form-control input-sm" id="dlxh" name="dlxh"/>
												</div>
											</div>
											<div class="col-xs-12 col-sm-6 col-md-4">
									    		<label for="supplier">加工厂商：</label>
									    		<div class="input-group" style="width:100%">
										    		<t:dictSelect id="supplier" field="supplier" type="select" hasLabel="false" title="加工厂商" extendJson="{class:'form-control input-sm'}"   dictTable="subcontract_supplier"  dictField="dwmc" dictText="dwmc" ></t:dictSelect>
									    		</div>
								    		</div>
								
								<div class="col-xs-12 col-sm-6 col-md-4">
									<div class="input-group col-md-12" style="margin-top: 20px">
										<a type="button" onclick="searchList();" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询</a> 
										<a type="button" onclick="searchRest();" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>重置</a>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="panel-body" style="padding-top: 0px; padding-bottom: 0px;">
		<!-- toolbar -->
		<div id="toolbar">
			<button onclick="add('录入','subcontractPlanController.do?goAdd','subcontractPlanList','100%','100%')" id="btn_add" class="btn btn-primary btn-sm">
				<span class="glyphicon glyphicon-plus" aria-hidden="true"></span> 录入
			</button>
			<button onclick="update('编辑','subcontractPlanController.do?goUpdate','subcontractPlanList','100%','100%')" id="btn_edit" class="btn btn-success btn-sm">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> 编辑
			</button>
			<button onclick="deleteALLSelect('批量删除','subcontractPlanController.do?doBatchDel','subcontractPlanList',600,400)" id="btn_delete" class="btn btn-danger btn-sm">
				<span class="glyphicon glyphicon-remove" aria-hidden="true"></span> 批量删除
			</button>
			<button onclick="detail('查看','subcontractPlanController.do?goUpdate','subcontractPlanList','100%','100%')" class="btn btn-info btn-sm">
				<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 查看
			</button>
			<button onclick="ImportXls('导入','','subcontractPlanList',600,400)" id="btn_download" class="btn btn-info btn-sm">
				<span class="glyphicon glyphicon-cloud-download" aria-hidden="true"></span> 导入
			</button>
			<button onclick="ExportXls('导出','','subcontractPlanList',600,400)" id="btn_upload" class="btn btn-info btn-sm">
				<span class="glyphicon glyphicon-cloud-upload" aria-hidden="true"></span> 导出
			</button>
			<button onclick="ExportXlsByT('模板下载','','subcontractPlanList',600,400)" id="btn_upload" class="btn btn-info btn-sm">
				<span class="glyphicon glyphicon-cloud-upload" aria-hidden="true"></span> 模板下载
			</button>
			<a class="btn btn-default btn-sm" data-toggle="collapse" href="#collapse_search" id="btn_collapse_search"> <span class="glyphicon glyphicon-search" aria-hidden="true"></span> 检索 </a>
		</div>
		<!-- data table -->
		<div class="table-responsive">
			<!-- class="text-nowrap" 强制不换行 -->
			<table id="subcontractPlanList"></table>
		</div>
	</div>
	<script type="text/javascript">
		$(".laydate-datetime").each(function(){
			var _this = this;
			laydate.render({
			  elem: this,
			  format: 'yyyy-MM-dd HH:mm:ss',
			  type: 'datetime'
			});
		});
		$(".laydate-date").each(function(){
			var _this = this;
			laydate.render({
			  elem: this
			});
		});
		var subcontractPlanListdictsData = {};
		$(function() {
			var promiseArr = [];
			promiseArr.push(new Promise(function(resolve, reject) {
				initDictByCode(subcontractPlanListdictsData,"id",promiseArr,"t_s_depart","departname");
			}));
			promiseArr.push(new Promise(function(resolve, reject) {
				initDictByCode(subcontractPlanListdictsData,"dwmc",promiseArr,"subcontract_supplier","dwmc");
			}));
			promiseArr.push(new Promise(function(resolve, reject) {
				initDictByCode(subcontractPlanListdictsData,"bpm_status",promiseArr,"","typename");
			}));
			Promise.all(promiseArr).then(function(results) {
				loadSearchFormDicts($("#searchForm").find("select[name='sysOrgCode']"),"t_s_depart","id","select","所属部门");
				loadSearchFormDicts($("#searchForm").find("select[name='supplier']"),"subcontract_supplier","dwmc","select","加工厂商");
			}).catch(function(err) {
			 	console.log('Catch: ', err);
			});
			
			//1.初始化Table
			var oTable = new TableInit();
			oTable.Init();

			//判断是否选中表格中的数据，选中后可编辑或删除
			$('#subcontractPlanList').on(
					'check.bs.table uncheck.bs.table load-success.bs.table '
							+ 'check-all.bs.table uncheck-all.bs.table',
					function() {
						$('#btn_delete').prop('disabled',!$('#subcontractPlanList').bootstrapTable('getSelections').length);
						$('#btn_edit').prop('disabled',$('#subcontractPlanList').bootstrapTable('getSelections').length != 1);
					});

		});
		
		var TableInit = function() {
			var oTableInit = new Object();
			//初始化Table
			oTableInit.Init = function() {
				$('#subcontractPlanList').bootstrapTable({
									url : 'subcontractPlanController.do?datagrid', //请求后台的URL（*）
									method : 'get', //请求方式（*）
									toolbar : '#toolbar', //工具按钮用哪个容器
									striped : true, //是否显示行间隔色
									cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
									pagination : true, //是否显示分页（*）
									queryParams : oTableInit.queryParams,//传递参数（*）
									sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
									pageNumber : 1, //初始化加载第一页，默认第一页
									pageSize : 10, //每页的记录行数（*）
									pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
									strictSearch : true,
									showColumns : true, //是否显示所有的列
									showRefresh : true, //是否显示刷新按钮
									minimumCountColumns : 2, //最少允许的列数
									clickToSelect : true, //是否启用点击选中行
									height : $(window).height() - 35, //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
									uniqueId : "id", //每一行的唯一标识，一般为主键列
									showToggle : true, //是否显示详细视图和列表视图的切换按钮
									cardView : false, //是否显示详细视图
									detailView : false, //是否显示父子表
									showExport : true, //显示到处按钮
									sortName:'createDate',
									sortOrder:'desc',
									columns : [
											// 复选框
											{
												checkbox : true,
												align : 'center'
											},
											{
												title : '序号',
												width : 5,
												align : 'center',
												switchable : false,
												formatter : function(value,row, index) {
													//return index+1; //序号正序排序从1开始
													var pageSize = $('#subcontractPlanList')
															.bootstrapTable('getOptions').pageSize;
													var pageNumber = $('#subcontractPlanList').bootstrapTable('getOptions').pageNumber;
													return pageSize* (pageNumber - 1) + index + 1;
												}
											},
											{
												field : 'id',
												title : '主键',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
											},
											{
												field : 'createName',
												title : '创建人名称',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
											},
											{
												field : 'createBy',
												title : '创建人登录名称',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
											},
											{
												field : 'createDate',
												title : '创建日期',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
												formatter : function(value, rec, index) {
													return new Date().format('yyyy-MM-dd', value);
												}
											},
											{
												field : 'updateName',
												title : '更新人名称',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
											},
											{
												field : 'updateBy',
												title : '更新人登录名称',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
											},
											{
												field : 'updateDate',
												title : '更新日期',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
												formatter : function(value, rec, index) {
													return new Date().format('yyyy-MM-dd', value);
												}
											},
											{
												field : 'planNo',
												title : '计划编号',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
											},
											{
												field : 'sysOrgCode',
												title : '所属部门',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
												formatter : function(value, rec, index) {
													return listDictFormat(value,"id","t_s_depart");
												}
											},
											{
												field : 'sysCompanyCode',
												title : '所属公司',
												valign : 'middle',
												width : 120,
												visible:false,
												align : 'center',
												switchable : true,
											},
											{
												field : 'bpmStatus',
												title : '流程状态',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
												formatter : function(value, rec, index) {
													return listDictFormat(value,"bpm_status","");
												}
											},
											{
												field : 'planDate',
												title : '计划投板时间',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
												formatter : function(value, rec, index) {
													return new Date().format('yyyy-MM-dd', value);
												}
											},
											{
												field : 'dlxh',
												title : '电路型号',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
											},
											{
												field : 'planNum',
												title : '计划投板数量',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
											},
											{
												field : 'pliesNum',
												title : '层数',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
											},
											{
												field : 'size',
												title : '尺寸',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
											},
											{
												field : 'supplier',
												title : '加工厂商',
												valign : 'middle',
												width : 120,
												align : 'center',
												switchable : true,
												formatter : function(value, rec, index) {
													return listDictFormat(value,"dwmc","subcontract_supplier");
												}
											},
											{
												title : "操作",
												align : 'center',
												valign : 'middle',
												width : 100,
												formatter : function(value,row, index) {
													if (!row.id) {
														return '';
													}
													var href = '';
													if(row.confirmState==1){
														href += "<a href='javascript:void(0);'  class='ace_button'  onclick=confirmtask('审核','subcontractPlanController.do?goConfirm&id="
															+ row.id	
														+ "','subcontractPlanList','100%','100%')> <i class='fa fa-trash-o' aria-hidden='true'></i> ";
														href += "审核</a>&nbsp;";
													}
													if(row.status!="1"){
														href += "<a href='javascript:void(0);'  class='ace_button'  onclick=delObj('subcontractPlanController.do?doDel&id="
																+ row.id
																+ "','subcontractPlanList')>  <i class='fa fa-trash-o' aria-hidden='true'></i> ";
														href += "删除</a>&nbsp;";
													}
													if(row.status=="1" && row.controlState==1){
														href += "<a href='javascript:void(0);'  class='ace_button'  onclick=activeObj('subcontractPlanController.do?doActive&id="
																+ row.id
																+ "','subcontractPlanList')>  <i class='fa fa-trash-o' aria-hidden='true'></i> ";
														href += "启用</a>&nbsp;";
													}
													return href;
												}
											} ],
									onLoadSuccess : function() { //加载成功时执行
										console.info("加载成功");
									},
									onLoadError : function() { //加载失败时执行
										console.info("加载数据失败");
									}
								});
			};

			//得到查询的参数
			oTableInit.queryParams = function(params) {
				var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 每页要显示的数据条数
					offset : params.offset, // 每页显示数据的开始行号
					sort : params.sort, // 排序规则
					order : params.order,
					rows : params.limit, //页面大小
					page : (params.offset / params.limit) + 1, //页码
					pageIndex : params.pageNumber,//请求第几页
					field : 'id,createName,createBy,createDate,updateName,updateBy,updateDate,sysOrgCode,sysCompanyCode,bpmStatus,planNo,planDate,dlxh,planNum,pliesNum,size,supplier,planNo,status,'
				};

				var params = $("#searchForm").serializeArray();
				for (x in params) {
					temp[params[x].name] = params[x].value;
				}
				return temp;
			};
			return oTableInit;
		};
		
		function searchList() {
			reloadTable();
		}

		function reloadTable() {
			$('#subcontractPlanList').bootstrapTable('refresh');
		}

		function searchRest() {
			$('#searchForm').find(':input').each(function() {
		    	if("checkbox"== $(this).attr("type")){
		    		$("input:checkbox[name='" + $(this).attr('name') + "']").attr('checked',false);
				}else if("radio"== $(this).attr("type")){
					$("input:radio[name='" + $(this).attr('name') + "']").attr('checked',false);
				}else{
					$(this).val("");
				}
		    });
		    $('#searchForm').find("input[type='checkbox']").each(function() {
		        $(this).attr('checked', false);
		    });
		    $('#searchForm').find("input[type='radio']").each(function() {
		        $(this).attr('checked', false);
		    });
			reloadTable();
		}
		//高级查询模态框
		function bootstrapQueryBuilder() {
			$('#superQueryModal').modal({
				backdrop : false
			});
		}
	</script>

	<script type="text/javascript">
		$(document).ready(function() {
		});

		//导入
		function ImportXls() {
			openuploadwin('Excel导入', 'subcontractPlanController.do?upload',"subcontractPlanList");
		}

		//导出
		function ExportXls() {
			JeecgExcelExport("subcontractPlanController.do?exportXls","subcontractPlanList");
		}

		//模板下载
		function ExportXlsByT() {
			JeecgExcelExport("subcontractPlanController.do?exportXlsByT","subcontractPlanList");
		}

		//列表数据字典项格式化
		function listDictFormat(value,code,table){
			if (!value) return '';
			var dictKey = code;
			if(code=="id"){
				dictKey = table+code;
			}
			var dicts = subcontractPlanListdictsData[dictKey];
		    var valArray = value.split(',');
		    var showVal = '';
		    if (valArray.length > 1) {
		    	for (var k = 0; k < valArray.length; k++) {
		           if(dicts && dicts.length>0){
		        	   for(var a = 0;a < dicts.length;a++){
		                	if(dicts[a].typecode ==valArray[k]){
		                		showVal = showVal + dicts[a].typename + ',';
		                		 break;
		                	}
		                }
		           }
		        }
		        showVal=showVal.substring(0, showVal.length - 1);
		    }else{
		    	if(dicts && dicts.length>0){
		    	   for(var a = 0;a < dicts.length;a++){
		            	if(dicts[a].typecode == value){
		            		showVal =  dicts[a].typename;
		            		 break;
		            	}
		            }
		       }
		    }
		    if(showVal==''){
		    	showVal = value;
		    }
		    return showVal;
		}
		
		//加载字典数据
		function initDictByCode(dictObj,code,promiseArr,table,text){
			var dictKey = code;
			if(code=="id"){
				//如果当前dictcode为id那么，此处的字典对象对应的key为"表名+id"
				dictKey = table+code;
			}
			if(!dictObj[code]){
		        var url = "systemController.do?typeListJson&typeGroupName="+code;
		        if(table){
					url += "&dicTable="+table+"&dicText="+text;
				}
				var dictAjax = jQuery.ajax({
		            url:url,
		    		type:"GET",
		       		dataType:"JSON",
		            success: function (back) {
		               if(back.success){
		            	   dictObj[dictKey]= back.obj;
		               }
		             }
		         });
		         promiseArr.push(dictAjax);
			}
		}
		//加载form查询数据字典项
		function loadSearchFormDicts(obj,table,code,type,name){
			var html = "";
			var dictKey = code;
			if(code=="id"){
				dictKey = table+code;
			}
			var arr = subcontractPlanListdictsData[dictKey];
			for(var a = 0;a < arr.length;a++){
				if("select"== type){
					if(a==0){
						html+="<option value = '' style='display: none'> 请选择"+name+"</option>";
					}
					html+="<option value = '"+arr[a].typecode+"'>"+arr[a].typename+"</option>";
				}else{
					if(!arr[a].typecode){
					}else{
						html+="<input name = '"+name+"' type='"+type+"' value = '"+arr[a].typecode+"'>"+arr[a].typename +"&nbsp;&nbsp;";
					}
					
				}
		    }
			obj.html(html);
		}
	</script>
</body>
</html>