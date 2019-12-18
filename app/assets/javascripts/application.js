// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require turbolinks
//= require select2
//= require bootstrap-datepicker/core
//= require jquery.form-validator
//= require jquery_nested_form
//= require moment
//= require daterangepicker
//= require multi-select
//= require_tree

 $(document).on("page:load ready", function(){
   $("input.datepicker").datepicker();
 });

var callbacks = {
  beforeRecordRender: function(record) {
    if(record.voucher_type == "Payment") {
      record.amount = -record.amount
    }
  },
  afterFilter: function(result) {
    // formatting the rows
    $("#payment_search_result td.voucher_type").each(function() {
      if( $(this).html() == "Payment") { 
        $(this).parent().addClass("text-danger")
      }
      else {
        recv = $(this).parent().children("td.received").html()
        amount = $(this).parent().children("td.amount").html()
        if(recv == amount) {
          $(this).parent().addClass("success")
        }
      }
    })
    // Consolidated results
    var received = 0
    var invoiced = 0
    var opening_balance = 0
    var closing_balance = 0
    var result_index = result.length -1
    if(result.length){
      for(i= all_time_payments.length-1 ; i>=0;i--)
      {
        if(all_time_payments[i].voucher_type=="Invoice" &&(all_time_payments[i].invoice_number == result[result_index].invoice_number)){
          break
        }
        if(all_time_payments[i].voucher_type=="Invoice")
        {
          opening_balance=opening_balance+(all_time_payments[i].amount-all_time_payments[i].received)
        }
      }
    }
    
    closing_balance = closing_balance+opening_balance
    for (i in result) {
      if(result[i].voucher_type == "Invoice") {
        invoiced = invoiced + result[i].amount
        if(result[i].received!=result[i].amount)
        {
          closing_balance = closing_balance + result[i].amount
        }
      }
      else { // Payment
        received = received + result[i].amount
      }
    }
    $("#payment_details_result .invoiced").html(invoiced)
    $("#payment_details_result .received").html(-received)
    $("#payment_details_result .opening_balance").html(opening_balance)
    $("#payment_details_result .closing_balance").html(closing_balance)
  }
}

function PaymentFilterInit(){
  var FJS = FilterJS(payments, '#payment_search_result', {
    template: '#payment_search_result_template',
    callbacks: callbacks,
    search: {}
  });
  FJS.addCriteria({field: 'date', ele: '#filter_by_date_select', type: 'range'});
}
