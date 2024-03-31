 var isDOMready = false;
var site_url   = window.location.origin;
/*enable_body_overlay_loading();
setTimeout(function(){
	enable_overlay_loading();
}, 50);*/

$(document).ready(function() {
	
	
	//fix_sidebar(); // fix side bar 
	//initDataTables();

	// show the error notifications if there is any message sent by server
	//show_app_error_and_messages();
	//create_dual_list_boxes();
	
	//enable_collapse_data_widget();
	
	//isDOMready = true;
	//disable_overlay_loading();
	 //setLocationInCookie();
	init_data_tables();
	enable_popover();
	
    // hide any open popovers when the anywhere else in the body is clicked	
	$('body').on('click', function (e) {
	    $('[data-toggle=popover]').each(function () {
	        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
	            $(this).popover('hide');
	        }
	    });
	});	
	

$('select.selectpicker').selectpicker({
	"actionsBox":true,
	"selectedTextFormat":"count > 3",
	
});

init_scrolls();



});
function init_scrolls(){
	$('body').overlayScrollbars({
  		resize :'',
	});

	$('.scrollable').overlayScrollbars({
	  resize :'',
	});
	
	
}


function simple__datatable(){
	$('.dataTable').DataTable({
	  "dom": 'Bfrtip',
	  "destroy": true,
      "paging": true,
      "lengthChange": true,
      "searching": true,
      "ordering": true,
      "info": true,
      "autoWidth": false,
      "responsive": {
	        "details": true,
	    },
      "fixedColumns":{
            "leftColumns": 1,
            "rightColumns": 3,
        },
      "buttons": [ 'pageLength', 'copy', 'excel', 'pdf','colvis'],
      "lengthMenu": [
            [ 20, 50,100,500,1000, -1 ],
            [ '20 rows', '50 rows','100 rows','500 rows','1000 rows', 'Show all' ]
        ],
    });
}
function init_data_tables(){
	  
    $(".simple-datatable").DataTable({
      "responsive": true,
      "autoWidth": false,
    });
    $('.datatable').DataTable({
      
	 "destroy": true,
      "paging": true,
      "lengthChange": false,
      "searching": true,
      "ordering": true,
      "info": true,
      "autoWidth": false,
      "lengthMenu": [
            [ 20, 50,100,500,1000 -1 ],
            [ '20 rows', '50 rows','100 rows','500 rows','1000 rows', 'Show all' ]
        ],
     
      "responsive": true,
       "buttons": [ 'pageLength', 'copy', 'excel', 'pdf', 'colvis' ]



    });
    


  
}

function initDatatablesById($id){
	if(isDOMready){
		$('#'+$id).dataTable({
			responsive: true
		});
	}
	
}
function enable_overlay_loading(){
	
	if(isDOMready){
		disable_overlay_loading();
		
	}else{
		$boxesCount  = 	$('body').find('.box').length
				
		$overlayedCount = $('body').find('.box-overlayed').length
		
		$boxesCount = $boxesCount - $overlayedCount;
		
		if($boxesCount > 0){
			
			$("<div class='loading-overlay'></div>").css({
			    position: "absolute",
			    width: "100%",
			    height: "100%",
			    left: 0,
			    top: 0,
			    opacity: 1,
			    zIndex: 1000000,  // to be on the safe side
			    background: "#ffffff url("+site_url +"public/images/loader_gif.gif) no-repeat 50% 60px"
			    
			}).appendTo($(".box").not(".box-overlayed").css("position", "relative"));
			
			$(".box").addClass("box-overlayed");
			
			$(".loading-overlay-body").remove();
			
		}else{
			setTimeout(function(){
				enable_overlay_loading();
			}, 50);
		}
		
		
	}
}
function enable_body_overlay_loading(){
	$("<div class='loading-overlay-body'></div>").css({
		position: "fixed",
		width: "100%",
		height: "100%",
		left: 0,
		top: 0,
		opacity: 1,
		zIndex: 1000000,  // to be on the safe side
		background: "#ffffff url("+site_url +"public/images/loader_gif.gif) no-repeat 50% 50%"
	}).appendTo($(".skin-blue").css("position", "fixed"));
	
	
}
function disable_overlay_loading(){
	$(".loading-overlay-body").remove();
	$(".loading-overlay").remove();
}
function fix_sidebar() {
    //Make sure the body tag has the .fixed class
    if (!$("body").hasClass("fixed")) {
        return;
    }

    //Add slimscroll
    $(".sidebar").slimscroll({
        height: ($(window).height() - $(".header").height()) + "px",
        color: "rgba(0,0,0,0.2)"
    });
}



function enable_popover(){
	$("[data-toggle=popover]")
    .popover({
	    container: 'body',
	    html: true,
	    placement: 'top'
	});

	/*
	$('.popover-link').popover({
	    container: 'body',
	    html: true,
	    placement: 'bottom'
	});
	$(document).click(function (e) {
	    $('.popover-link').each(function () {
	        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
	            //$(this).popover('hide');
	            if ($(this).data('bs.popover').tip().hasClass('in')) {
	                $(this).popover('toggle');
	            }
	            
	            return;
	        }
	    });
	});
	*/
	$(".pagination li a").click(function (e){
		setTimeout(function(){
			 enable_popover();
	    }, 500);
	});
}




// revalidate the Date fields on Date picker
function dateTimePickerRevalidator(){
	$('.date')
		.on('dp.change dp.show dp.hide', function(e) {
// list all the datepicker here		
			$('#employee_form').bootstrapValidator('revalidateField', 'date_of_joining');
			$('#employee_form').bootstrapValidator('revalidateField', 'date_of_resigning');
			$('#due_fee_form').bootstrapValidator('revalidateField', 'due_fee_date');
			$('#expense_form').bootstrapValidator('revalidateField', 'expense_date');
			$('#student_add_update_form').bootstrapValidator('revalidateField', 'student_admission_date');
			$('#student_add_update_form').bootstrapValidator('revalidateField', 'student_date_of_birth');
			$('#issue_salary_form').bootstrapValidator('revalidateField', 'salary_date');
	});
}



 
    const Toast = Swal.mixin({
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 10000
    });
 
function hide_alerts(){
	$('.swal2-container').hide();
}
function show_alert(type, text){
		
	 Toast.fire({
        icon: type,
		html: text,
		showCloseButton: false,
      });
	
}





function show_app_error_and_messages() {
		if ($("#appNotifications .custom_ul").length) {
		  $('#appNotifications').slideDown();
		}
	
	
	
		if ($("#appErrors .custom_ul").length) {
		  $('#appErrors').slideDown();
		  
			setTimeout(function(){
				 $('#appErrors').slideUp();    
		    }, 10000);
		  
		  
		// adjust overlapping in case all the notifications are visibile at the same time
		  if ($("#appNotifications .custom_ul").length) {
			   
			  //$count_li = $("#appNotifications .custom_ul li").length ;
			   //$topMargin = $count_li * 38;
			  // $topMargin = $topMargin + 52;
			   
			  $topMargin = $("#appNotifications .custom_ul").height();
			   $topMargin = $topMargin + 15;
			   $topMargin = $topMargin + "px";
			   // $topMargin = $topMargin + $("#appErrors").position().top;
			   $("#appErrors").css({
				top : $topMargin
			   });
		  }
		  
		  
		  
		}
		
		if ($("#appMessages .custom_ul").length) {
		  $('#appMessages').slideDown();
		  

		  // adjust overlapping in case both notifications are visibile
		    if ($("#appErrors .custom_ul").length || $("#appNotifications .custom_ul").length) {
		    	$topMargin = 0;
		    	if ($("#appErrors .custom_ul").length) {
		    		
		    		$topMargin = $("#appErrors .custom_ul").height();
					   $topMargin = $topMargin + 10;
					  
				  }
		    	 if ($("#appNotifications .custom_ul").length) {
		    		 $topMargin = $topMargin + $("#appNotifications .custom_ul").height();
					 $topMargin = $topMargin + 10;
				  }
		    	 $topMargin = $topMargin + 4;
		    	 $topMargin = $topMargin +"px";
		    	 $("#appMessages").css({
					top : $topMargin
				  });
		    	
		    }
		  
		    setTimeout(function(){
				 $('#appMessages').slideUp();    
		    }, 10000);
		

		}
	}

function clear_app_error_and_messages(){
	$('#appErrors').slideUp();
	$('#appMessages').slideUp();
	
	$("#appMessages .message_container .custom_ul").remove();
	$("#appErrors .message_container .custom_ul").remove();
	$("#appNotifications .message_container .custom_ul").remove();
	
}


// Loads the correct sidebar on window load,
// collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
$(function() {
	$(window)
			.bind(
					"load resize",
					function() {
						topOffset = 50;
						width = (this.window.innerWidth > 0) ? this.window.innerWidth
								: this.screen.width;
						if (width < 768) {
							$('div.navbar-collapse').addClass('collapse')
							topOffset = 100; // 2-row-menu
						} else {
							$('div.navbar-collapse').removeClass('collapse')
						}

						height = (this.window.innerHeight > 0) ? this.window.innerHeight
								: this.screen.height;
						height = height - topOffset;
						if (height < 1)
							height = 1;
						if (height > topOffset) {
							$("#page-wrapper").css("min-height",
									(height) + "px");
						}
					});
});



function enable_collapse_data_widget(){
	$("[data-widget='collapse']").click(function() {
	    //Find the box parent        
	    var box = $(this).parents(".box").first();
	    //Find the body and the footer
	    var bf = box.find(".box-body, .box-footer");
	    if (!box.hasClass("collapsed-box")) {
	        box.addClass("collapsed-box");
	        //Convert minus into plus
	        $(this).children(".fa-minus").removeClass("fa-minus").addClass("fa-plus");
	        bf.slideUp();
	    } else {
	        box.removeClass("collapsed-box");
	        //Convert plus into minus
	        $(this).children(".fa-plus").removeClass("fa-plus").addClass("fa-minus");
	        bf.slideDown();
	    }
	});
}

$(function(){
	$(".dropdown-menu > li > a.trigger").on("click",function(e){
		var current=$(this).next();
		var grandparent=$(this).parent().parent();
		if($(this).hasClass('left-caret')||$(this).hasClass('right-caret'))
			$(this).toggleClass('right-caret left-caret');
		grandparent.find('.left-caret').not(this).toggleClass('right-caret left-caret');
		grandparent.find(".sub-menu:visible").not(current).hide();
		current.toggle();
		e.stopPropagation();
	});
	$(".dropdown-menu > li > a:not(.trigger)").on("click",function(){
		var root=$(this).closest('.dropdown');
		root.find('.left-caret').toggleClass('right-caret left-caret');
		root.find('.sub-menu:visible').hide();
	});
});



function show_ajax_loader(){
	$('#ajax_loader_wrapper').modal('show');
}
function hide_ajax_loader(){
	$('#ajax_loader_wrapper').modal('hide');
}

function append_request_type_delimiter(url){
	if (url.indexOf("?") >-1) {
		url= url +"&rt=m"
	}else{
		url= url +"?rt=m"
	}
	return url;
}

 
function load_remote_model(url, modal_title, $serializedData) {
	
	show_ajax_loader();
	
	//window.history.pushState("",  modal_title + " " + currentTitle, url);
	
	url = append_request_type_delimiter(url);
	
	// remove modal-lg class
	$("#global_modal .modal-dialog ").removeClass("modal-lg");
	$.ajax({
		url : url,
		type : "post",
		data : $serializedData,
		success : function(result) {
			// set Title
			$('#global_modal_label').html(modal_title);
			$('#global_modal_body').html(result);
			hide_ajax_loader();
			$('#global_modal').modal('show');
			show_app_error_and_messages();
			enable_popover();
			
			// console.log(result);
		}
	});
}

function onModelCloseBtn(){
	window.history.pushState("",  currentTitle, currentPageUrl);
	
	
}

function load_local_model(modal_title, model_body) {
	$('#local_modal_title').html(modal_title);
	$('#local_modal_body').html($html);
	$('#local_modal').modal('show');
	enable_popover();
}

function load_image_details(modal_title, image_path) {
	$html = "<div class='col-lg-12>'<center><div class='alert alert-info'>"
	    	+" Image Path: "+ image_path                          
	    	+"	</div><br/>";
	$html = $html + "<img src='"+image_path+"' style='max-width: 100%;' /></center></div>";
	
	$('#global_image_lighbox_title').html(modal_title);
	$('#global_image_lighbox_body').html($html);
	
	$('#global_image_lighbox').modal('show');
	enable_popover();
}
function load_gallery_images(targetId){
	var url = site_url +  "website/galleryImagesForRichEditor";
	$.ajax({
		url : url,
		type : "post",
		success : function(result) {
			// set Title
			//gallery_in_editor_popup
			$("#"+targetId).html(result);
			enable_popover();
			// console.log(result);
		}
	});
}
var targetControleForImagePath=""; 
function copy_image_path_to_field($imagePath){
	
	$(targetControleForImagePath).val($imagePath);
}
function enlarge_remote_model() {
	$("#global_modal .modal-dialog ").addClass("modal-lg");
}

function ajax_file_submit(url , preview_container_id, update_path_id,inputFileId="browse_file"){
	$html_loader = "<img src='"+ site_url +"public/images/loader_gif.gif' alt=''  class='img-circle circle_border'/>";
	 
	$existing_html =  $("#"+preview_container_id).html();
	$("#"+preview_container_id).html("");
	$("#"+preview_container_id).html($html_loader);
	
	// clear existing messages from list 
	clear_app_error_and_messages();
	var file_data = $("#"+inputFileId).prop("files")[0];   
    var form_data = new FormData();                  
    form_data.append("file", file_data);
	
	$.ajax({
		url : url,
		type : "post",
		cache:false,
	    processData:false,
	    contentType:false,
		data : form_data,
		success : function(result) {
			//console.log(result);
			//console.log(result);
			
			var json = jQuery.parseJSON(result);
			
			$server_message = "<ul  class='custom_ul'><li>"+json.message+"</li></ul>";
			if(json.status == "success"){
				
				$cssClass ="img-circle circle_border max-100 ";
				if(json.hasOwnProperty('cssClass')){
					$cssClass = json.cssClass;
				}
				
				
				$("#"+update_path_id).val(json.absolute_path);
				
				$("#"+preview_container_id).html("");
				$previewHTML = "<img src='"+json.absolute_path+"' alt=''  class='"+$cssClass+"' />";
				$("#"+preview_container_id).html($previewHTML);
				$("#appMessages .message_container").append($server_message);
			}else{
				$("#"+preview_container_id).html($existing_html);
				$("#appErrors .message_container").append($server_message);
			}
			
			
			show_app_error_and_messages();
		},
		error: function(result){
			$("#"+preview_container_id).html("");
			$("#appErrors .message_container").append("<ul  class='custom_ul'><li>Error Occured. Please Re-login and try again.</li></ul>");
			show_app_error_and_messages();
			
		}
		
	});
	
}

function create_dual_list_boxes() {

	var dual_list_box = $('.dual_list_box').bootstrapDualListbox({
		nonSelectedListLabel : 'Available',
		selectedListLabel : 'Selected',
		preserveSelectionOnMove : 'moved',
		moveOnSelect : false,
		nonSelectedFilter : ''
	});
	// dual_list_box.bootstrapDualListbox('refresh', true); // to refresh on
	// ajax.

}

function ajax_submit(url, $targetId='',$formId='', $method='GET',   $serializedData='', callbacksucccess, callbackfail, content_type=false) {

	//enable_overlay_loading();
	var formData  ="";
	if($formId != ''){
		var formData =  new FormData( document.getElementById($formId));
//		$formData = $("#"+$formId).serialize();
			
	}else{
		formData = $serializedData;
	}
	url = append_request_type_delimiter(url);
	
	beforeAjaxFormSubmit($targetId);
	$.ajax({
		type : $method,
		url : url,
		data : formData,
		contentType: content_type, //'multipart/form-data'
    	processData: false, // NEEDED, DON'T OMIT THIS
		beforeSend: function (xhr) {
        	xhr.setRequestHeader('X-CSRFToken', getCookie('csrftoken'));
    	},
		success : function(response) {
			
			if(callbacksucccess!=undefined && callbacksucccess!=''){
				callbacksucccess(response);
			}else{
				if ($targetId != "") {
					$("#" + $targetId).html(response);
					afterAjaxResponse($targetId);	
				}
			
			}
		
		},
		error : function(response) {
			if(callbackfail != undefined && callbackfail!=''){
				callbackfail(response);
			}
		
		},
		 
	});
}
 function ajax_submit_no_loader(url,$targetId='',$formId='', $method='GET',   $serializedData='', callbacksucccess, callbackfail, content_type=false) {

	//enable_overlay_loading();
	var formData  ="";
	if($formId != ''){
		var formData =  new FormData( document.getElementById($formId));
//		$formData = $("#"+$formId).serialize();
			
	}else{
		formData = $serializedData;
	}
	url = append_request_type_delimiter(url);
	
	//beforeAjaxFormSubmit($targetId);
	$.ajax({
		type : $method,
		url : url,
		data : formData,
		contentType: content_type, //'multipart/form-data'
    	processData: false, // NEEDED, DON'T OMIT THIS
		beforeSend: function (xhr) {
        	xhr.setRequestHeader('X-CSRFToken', getCookie('csrftoken'));
    	},
		success : function(response) {
			
			if(callbacksucccess!=undefined && callbacksucccess!=''){
				callbacksucccess(response);
			}else{
				if ($targetId != "") {
					$("#" + $targetId).html(response);
					afterAjaxResponse($targetId);	
				}
			
			}
		
		},
		error : function(response) {
			if(callbackfail != undefined && callbackfail!=''){
				callbackfail(response);
			}
		
		},
		 
	});
}
function beforeAjaxFormSubmit($targetId){
	if($targetId.length > 0){
		$currHeight = $("#" + $targetId).height();
		if($currHeight > 400){
			$currHeight = 400;
		}
		if($currHeight < 20){
			$currHeight = 20;
		}
		$topMargin = $currHeight/2;
		
		$topMargin -= 16;
		$("#" + $targetId).height($currHeight);
		
		$html = '<div class="full-width bg-transparent"><div class="center-inner"><i class="fas fa-circle-notch center fa-spin center-inner text-xl" style="margin-top:'+$topMargin+'px;" ></i></div></div>';
		$("#" + $targetId).html($html);
		
		
	}
}
function afterAjaxResponse($targetId){
	
	$("#"+$targetId).css("height", "");
	show_app_error_and_messages();
	//enableFormValidatorOnAjax($formId);
	disable_overlay_loading();
}
function enableFormValidatorOnAjax($formId){
	$('#'+$formId).bootstrapValidator({
        fields: {
        	
        }
    });
}


function toggle_all_source_chkbx(controlling_chkbx, cls) {
	//source_chkbx_all
	var checked = $("#" + controlling_chkbx).is(':checked'); // Checkbox state
	
	if (checked) {
		check_by_class(cls);
	} else {
		un_check_by_class(cls);
	}
}
function toggle_chkbx(cls) {
	var checked = $("." + cls).is(':checked'); // Checkbox state
	if (checked) {
		check_by_class(cls);
	} else {
		un_check_by_class(cls);
	}
}

function check_by_class(cls) {
	$("." + cls).each(function() {

		this.checked = true;
	});
}
function un_check_by_class(cls) {
	$("." + cls).each(function() {

		this.checked = false;
	});
}

function get_selected_checkbox_by_class(cls){
	var selected = [];
	$("."+cls+":checked").each(function(){
		selected.push($(this).val());
	});
	return selected;
}


function setLocationInCookie(){
	var sl_country = getCookie("SL_COUNTRY");
	if (sl_country == "" ) {
		 $.getJSON('https://jsonip.com?callback=?', function(data) {
		        var ip = data.ip;
		        $.getJSON("https://cors-anywhere.herokuapp.com/http://www.geoplugin.net/json.gp?ip=" + ip, function(response) {
		            console.log(response);
		            setCookie('SL_COUNTRY', response.geoplugin_countryCode, 5000);
		        });
		        
		    }); 
	} else{
		console.log(sl_country);
	}
} 


function getCookie(cname) {
	  var name = cname + "=";
	  var decodedCookie = decodeURIComponent(document.cookie);
	  var ca = decodedCookie.split(';');
	  for(var i = 0; i <ca.length; i++) {
	    var c = ca[i];
	    while (c.charAt(0) == ' ') {
	      c = c.substring(1);
	    }
	    if (c.indexOf(name) == 0) {
	      return c.substring(name.length, c.length);
	    }
	  }
	  return "";
	}

function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + (exdays*24*60*60*1000));
  var expires = "expires="+ d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}
 

function display_loader(selector, loader_class='small-right-loader'){
	
  	loader = '<span class="loader  bg-transparent '+loader_class+'" ><i class="fas fa-circle-notch center fa-spin center-inner text-lg " ></i></span>'
  	$(selector).prepend(loader);
  }
  function hide_loader(selector){
  	$(selector+" .loader").remove();
  }
	
$(document).ready(function(){
	$(".remote-dropdown").click(function(event) {
		$targetUpdate = $(this).next(".dropdown-menu" );
		$url = $(this).attr('data-url');
		$url = append_request_type_delimiter($url);
		$.ajax({
			type : "POST",
			url : $url,
			success : function(response) {
				$targetUpdate.html(response);
			},
			error : function() {
				$targetUpdate.html("error Occured.");
			}
		});
    });
	
});












     