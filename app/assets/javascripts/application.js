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
//= require_tree .

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
        console.log(recv, amount)
        if(recv == amount) {
          $(this).parent().addClass("success")
        }
      }
    })

    // Consolidated results
    var balance = 0
    var total = 0
    for (i in result) {
      balance = balance + result[i].amount
      if(result[i].voucher_type == "Invoice") {
        total = total + result[i].amount
      }
    }

    $("#payment_details_result .total").html(total)
    $("#payment_details_result .balance").html(balance)
  }
}

function PaymentFilterInit(){
  var FJS = FilterJS(payments, '#payment_search_result', {
    template: '#payment_search_result_template',
    callbacks: callbacks,
    search: {}
  });
  FJS.addCriteria({field: 'date', ele: '#filter_by_days_select', type: 'range'});
}
