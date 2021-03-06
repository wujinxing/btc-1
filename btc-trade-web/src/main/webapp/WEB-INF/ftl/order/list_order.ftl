<#assign spring=JspTaglibs["http://www.springframework.org/tags"]>
<#import "../layout.ftl" as layout />
<#assign title><@spring.message code="label.listorder.title"/></#assign>
<#assign cancelUrl><@spring.url value="/order/cancelOrder.html"/></#assign>
<#assign updateUrl><@spring.url value="/order/updateOrder.html"/></#assign>
<#assign failedUrl><@spring.url value="/order/failedOrder.html"/></#assign>
<#assign detailUrl><@spring.url value="/order/detail.html"/></#assign>

<@layout.masterTemplate title="${title}">	
	<script language="javascript" type="text/javascript" src="<@spring.url value="/assets/datatables/jquery.dataTables.min.js"/>"></script>
	<script language="javascript" type="text/javascript" src="<@spring.url value="/assets/datatables/dataTables.bootstrap.min.js"/>"></script>
	<link rel="stylesheet" type="text/css" href="<@spring.url value="/assets/datatables/dataTables.bootstrap.min.css"/>">	
	
	<script language="javascript" type="text/javascript">		
		$(function() {
			var userOrderDatatable = $('#userOrderListTable').DataTable({
		        "ajax": '<@spring.url value="/order/query.request"/>',
        		"serverSide": true,
        		ordering: false,
        		searching: false,        		
        		"columnDefs": [ {
				    "targets": 0,
				    "data": null,
				    "render": function ( data, type, full, meta ) {
					      return meta.settings._iDisplayStart + meta.row + 1;
					    }
				  	}, {
				  		"targets": 1,
				    	"data": null,
				    	"render" : function ( data, type, row ) {				    		
				    		var html = '<a href="${detailUrl}?uoId=' + data.id + '" ' +
				    							'data-toggle="modal" data-target="#detailModal">' +
				    							data.id +
				    						'</a>';
			    			return html;				    		
				    	}
				  	}, {
				  		"targets": 2,
				    	"data": "parentId",
				  	}, {
				  		"targets": 3,
				    	"data": "orderType",
				  	}, {
				  		"targets": 4,
				    	"data": "basePrice",
				  	}, {
				  		"targets": 5,
				    	"data": "price",
				  	}, {
				  		"targets": 6,
				    	"data": "amount",
				  	}, {
				  		"targets": 7,
				    	"data": "completedAmount",
				  	}, {
				  		"targets": 8,
				    	"data": null,
				    	"render" : function ( data, type, row ) {				    		
				    		if (data.basePrice > 0) {
				    			if (data.orderType == 'B') {
				    				return (-1 * (data.price - data.basePrice) * data.completedAmount).toFixed(4)
				    			}
				    			return ((data.price - data.basePrice) * data.completedAmount).toFixed(4);
				    		}				    		
				    		return 0;
				    	}
				  	}, {
				  		"targets": 9,
				    	"data": null,
				    	"render" : function ( data, type, row ) {				    		
				    		if (data.status == 'F') {
				    			var html = '<a href="${failedUrl}?uoId=' + data.id + '" ' +
				    							'data-toggle="modal" data-target="#failedOrderModal">' +
				    							data.status +
				    						'</a>';
				    			return html;
				    		}
				    		else {
				    			return data.status;
				    		}
				    	}
				  	}, {
				  		"targets": 10,
				    	"data": "createDateStr",
				  	}, {
				  		"targets": 11,
				    	"data"   : null,
				    	"render" : function ( data, type, row ) {
				    		var html = '<div class="btn-group" role="group" aria-label="...">' +
					    			'<a href="${cancelUrl}?uoId=' + data.id + '" class="btn btn-default '; 
					    	
						    	if (data.status !== 'P' && data.status !== 'M') {
						    		html += 'disabled';
						    	}
					    						    	
					    		html += '" title="Cancel" ' +
					    				'data-toggle="modal" data-target="#cancelOrderModal"/>' +
										'<span class="glyphicon glyphicon-remove"></span>' +
									'</a>' +									
									'<a href="${updateUrl}?uoId=' + data.id + '" class="btn btn-default '; 
					    	
							    	if (data.status !== 'P' && data.status !== 'M') {
							    		html += 'disabled';
							    	}
							    						    	
						    	html += '" title="Update" ' +
					    				'data-toggle="modal" data-target="#updateOrderModal"/>' +
										'<span class="glyphicon glyphicon-pencil"></span>' +
									'</a>' +
									
									
				    			'</div>';
				    		
				    		return html;
				    	}
				  	}],
		        "lengthMenu": [ 10, 25, 50, 75, 100 ],
		        "pageLength": 25
		    });
		    
		    $('#filterOrdersSubmitBtn').on('click', function() {
		    	var queryUrl = "order/query.request?";
				queryUrl += $('#filterOrderForm').serialize();
				
				userOrderDatatable.ajax.url(queryUrl).load();	
		    });
		    
		    $('#cancelOrderModal').on('hide.bs.modal', function () {
	   			$('#cancelOrderModal').removeData();
	   			userOrderDatatable.ajax.reload();
			});
			
			$('#updateOrderModal').on('hide.bs.modal', function () {
	   			$('#updateOrderModal').removeData();
	   			userOrderDatatable.ajax.reload();
			});
			
			$('#failedOrderModal').on('hide.bs.modal', function () {
	   			$('#failedOrderModal').removeData();
	   			userOrderDatatable.ajax.reload();
			});
			
			$('#detailModal').on('hide.bs.modal', function () {
	   			$('#detailModal').removeData();
			});
	   	});	   
	</script>
	
	<div class="panel panel-default">
		<div class="panel-heading">
	    	<h3 style="cursor: pointer" class="panel-title" data-toggle="collapse" data-target="#filterOrderDiv">
	    		<@spring.message code="label.filterorder.title"/>
	    	</h3>				    	
	  	</div>
	  	<#include "filter_order.ftl">
	</div>
	
	<table id="userOrderListTable" class="table table-hover">
		<thead>
			<tr>
				<th>#</th>
				<th><@spring.message code="label.listorder.id"/></th>
				<th><@spring.message code="label.listorder.parent"/></th>
				<th><@spring.message code="label.listorder.ordertype"/></th>
				<th><@spring.message code="label.listorder.baseprice"/></th>
				<th><@spring.message code="label.listorder.price"/></th>
				<th><@spring.message code="label.listorder.orderamount"/></th>
				<th><@spring.message code="label.listorder.completedamount"/></th>
				<th><@spring.message code="label.listorder.profit"/></th>
				<th><@spring.message code="label.listorder.status"/></th>
				<th><@spring.message code="label.listorder.createdate"/></th>
				<th><@spring.message code="label.listorder.edit"/></th>		
			</tr>
		</thead>
	</table>
	
	<div class="modal fade" id="cancelOrderModal">
		<div class="modal-dialog">
	    	<div class="modal-content">
	    	
	    	</div><!-- /.modal-content -->
	  	</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<div class="modal fade" id="updateOrderModal">
		<div class="modal-dialog">
	    	<div class="modal-content">
	    	
	    	</div><!-- /.modal-content -->
	  	</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<div class="modal fade" id="failedOrderModal">
		<div class="modal-dialog">
	    	<div class="modal-content">
	    	
	    	</div><!-- /.modal-content -->
	  	</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<div class="modal fade" id="detailModal">
		<div class="modal-dialog">
	    	<div class="modal-content">
	    	
	    	</div><!-- /.modal-content -->
	  	</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

</@layout.masterTemplate>