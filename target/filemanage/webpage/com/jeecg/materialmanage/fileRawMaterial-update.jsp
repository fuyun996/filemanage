<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
 <head>
  <title>原材料库</title>
  <t:base type="jquery,easyui,tools,DatePicker"></t:base>
  <t:base type="uploadify"></t:base>
  <script type="text/javascript">
  //编写自定义JS代码
  </script>
 </head>
 <body>
		<t:formvalid formid="formobj" dialog="true" usePlugin="password" layout="table" action="fileRawMaterialController.do?doUpdate" callback="jeecgFormFileCallBack@Override">
					<input id="id" name="id" type="hidden" value="${fileRawMaterialPage.id }"/>
		<table style="width: 600px;" cellpadding="0" cellspacing="1" class="formtable">
					<tr>
						<td align="right">
							<label class="Validform_label">
								检验批次:
							</label>
						</td>
						<td class="value">
						    <input id="inspectionLot" name="inspectionLot" type="text" maxlength="32" style="width: 150px" class="inputxt"  datatype="*"  ignore="checked"  value='${fileRawMaterialPage.inspectionLot}'/>
							<span class="Validform_checktip"></span>
							<label class="Validform_label" style="display: none;">检验批次</label>
						</td>
					</tr>
					<tr>
						<td align="right">
							<label class="Validform_label">
								原材料类型:
							</label>
						</td>
						<td class="value">
									<t:dictSelect field="materialType" type="list"  datatype="*"  typeGroupCode="ycllx"   defaultVal="${fileRawMaterialPage.materialType}" hasLabel="false"  title="原材料类型" ></t:dictSelect>     
							<span class="Validform_checktip"></span>
							<label class="Validform_label" style="display: none;">原材料类型</label>
						</td>
					</tr>
					<tr>
						<td align="right">
							<label class="Validform_label">
								型号:
							</label>
						</td>
						<td class="value">
						    <input id="model" name="model" type="text" maxlength="32" style="width: 150px" class="inputxt"  datatype="*"  ignore="checked"  value='${fileRawMaterialPage.model}'/>
							<span class="Validform_checktip"></span>
							<label class="Validform_label" style="display: none;">型号</label>
						</td>
					</tr>
					<tr>
						<td align="right">
							<label class="Validform_label">
								附件:
							</label>
						</td>
						<td class="value">
		<table id="fileattach_fileTable"></table>
		<div class="form jeecgDetail">
			<t:upload name="fileattach" id="fileattach" queueID="filediv_fileattach" outhtml="false" uploader="cgUploadController.do?saveFiles"  extend="office" buttonText='添加文件'  onUploadStart="fileattachOnUploadStart"> </t:upload>
			<div class="form" id="filediv_fileattach"></div>
			<script type="text/javascript">
				function fileattachOnUploadStart(file){
					var cgFormId=$("input[name='id']").val();
					$('#fileattach').uploadify("settings", "formData", {
						'cgFormId':cgFormId,
						'cgFormName':'file_raw_material',
						'cgFormField':'FILEATTACH'
					});
				}
			</script>
		</div>
							<span class="Validform_checktip"></span>
							<label class="Validform_label" style="display: none;">附件</label>
						</td>
					</tr>
				
			</table>
		</t:formvalid>
 </body>
	  	<script type="text/javascript">
		  	//加载 已存在的 文件
		  	$(function(){
	  			var cgFormId=$("input[name='id']").val();
		  		$.ajax({
		  		   type: "post",
		  		   url: "fileRawMaterialController.do?getFiles&id=" +  cgFormId,
		  		   success: function(data){
		  			 var arrayFileObj = jQuery.parseJSON(data).obj;
		  			 
		  			$.each(arrayFileObj,function(n,file){
		  				var fieldName = file.field.toLowerCase();
		  				var table = $("#"+fieldName+"_fileTable");
		  				var tr = $("<tr style=\"height:34px;\"></tr>");
		  				var title = file.title;
		  				if(title.length > 15){
		  					title = title.substring(0,12) + "...";
		  				}
		  				var td_title = $("<td>" + title + "</td>");
		  		  		var td_download = $("<td><a style=\"margin-left:10px;\" href=\"commonController.do?viewFile&fileid=" + file.fileKey + "&subclassname=org.jeecgframework.web.cgform.entity.upload.CgUploadEntity\" title=\"下载\">下载</a></td>")
		  		  		var td_view = $("<td><a style=\"margin-left:10px;\" href=\"javascript:void(0);\" onclick=\"openwindow('预览','commonController.do?openViewFile&fileid=" + file.fileKey + "&subclassname=org.jeecgframework.web.cgform.entity.upload.CgUploadEntity','fList',700,500)\">预览</a></td>");
		  		  		tr.appendTo(table);
		  		  		td_title.appendTo(tr);
		  		  		td_download.appendTo(tr);
		  		  		td_view.appendTo(tr);
		  		  		if(location.href.indexOf("load=detail")==-1){
			  		  		var td_del = $("<td><a style=\"margin-left:10px;\" href=\"javascript:void(0)\" class=\"jeecgDetail\" onclick=\"del('cgUploadController.do?delFile&id=" + file.fileKey + "',this)\">删除</a></td>");
			  		  		td_del.appendTo(tr);
		  		  		}
		  			 });
		  		   }
		  		});
		  	});
		  	
		  	/**
		 	 * 删除图片数据资源
		 	 */
		  	function del(url,obj){
		  		var content = "请问是否要删除该资源";
		  		var navigatorName = "Microsoft Internet Explorer"; 
		  		if( navigator.appName == navigatorName ){ 
		  			$.dialog.confirm(content, function(){
		  				submit(url,obj);
		  			}, function(){
		  			});
		  		}else{
		  			layer.open({
						title:"提示",
						content:content,
						icon:7,
						yes:function(index){
							submit(url,obj);
						},
						btn:['确定','取消'],
						btn2:function(index){
							layer.close(index);
						}
					});
		  		}
		  	}
		  	
		  	function submit(url,obj){
		  		$.ajax({
		  			async : false,
		  			cache : false,
		  			type : 'POST',
		  			url : url,// 请求的action路径
		  			error : function() {// 请求失败处理函数
		  			},
		  			success : function(data) {
		  				var d = $.parseJSON(data);
		  				if (d.success) {
		  					var msg = d.msg;
		  					tip(msg);
		  					obj.parentNode.parentNode.parentNode.deleteRow(obj.parentNode.parentNode);
		  				} else {
		  					tip(d.msg);
		  				}
		  			}
		  		});
		  	}
		  	
	  		function jeecgFormFileCallBack(data){
	  			if (data.success == true) {
					uploadFile(data);
				} else {
					if (data.responseText == '' || data.responseText == undefined) {
						$.messager.alert('错误', data.msg);
						$.Hidemsg();
					} else {
						try {
							var emsg = data.responseText.substring(data.responseText.indexOf('错误描述'), data.responseText.indexOf('错误信息'));
							$.messager.alert('错误', emsg);
							$.Hidemsg();
						} catch(ex) {
							$.messager.alert('错误', data.responseText + '');
						}
					}
					return false;
				}
				if (!neibuClickFlag) {
					var win = frameElement.api.opener;
					win.reloadTable();
				}
	  		}
	  		function upload() {
					$('#fileattach').uploadify('upload', '*');	
			}
			
			var neibuClickFlag = false;
			function neibuClick() {
				neibuClickFlag = true; 
				$('#btn_sub').trigger('click');
			}
			function cancel() {
					$('#fileattach').uploadify('cancel', '*');	
			}
			function uploadFile(data){
				if(!$("input[name='id']").val()){
					if(data.obj!=null && data.obj!='undefined'){
						$("input[name='id']").val(data.obj.id);
					}
				}
				if($(".uploadify-queue-item").length>0){
					upload();
				}else{
					if (neibuClickFlag){
						alert(data.msg);
						neibuClickFlag = false;
					}else {
						var win = frameElement.api.opener;
						win.reloadTable();
						win.tip(data.msg);
						frameElement.api.close();
					}
				}
			}
	  	</script>
