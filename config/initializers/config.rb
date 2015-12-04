require 'patch'

DESTINATION_PORTS = %W(Nhava\ Sheva Mundra Tuticorin Chennai Jebel\ Ali Mersin)
TYPE = %W(TBL Haulage)
CURRENCY = %w(USD UGX)
EQUIPMENT_TYPE = %W(20GP 40GP 40OT 40FR 20OT)
ROLE = %W(Admin Staff)
EMAILS_DEFAULTS = 'accounts@21nautica.com, kaushik@21nautica.com, sachin@21nautica.com, docs@21nautica.com, docs-ug@21nautica.com, ops-ug@21nautica.com, chetan@21nautica.com, ops@21nautica.com ' 
#SHIPPING_LINE = %W(CMA\ CGM Maersk  Evergreen Safmarine PIL Emirates MSC COSCO 
#  NYK\ line WECLINES)
# Time in Days
STATUS_CHANGE_DURATION = {arrived_malaba_border: 2,
                          crossed_malaba_border: 2,
                          order_released: 2,
                          arrived_port: 3,
                          document_handed: 1}
PAYMENT_MODES = %W(Cheque Cash TT)
INVOICE_PARTICULARS = %w( Ocean\ Freight Clearing\ Charges ICD Demurrage 
	Empty Final\ Clearing Haulage Forest\ Permits Port\ Storage Other)
PORTS = {"Dar Es Salaam" => ["Kigali"], "Mombasa" => ["Kampala"]}
CHARGES = {"transporter" => ["Haulage", "Empty Return", "Truck Detention", "Local Shunting"],
           "icd" => ["ICD Charges", 'Other charges'],
           "clearing_agent" => ["Ocean Freight", "Container Demurrage",
                                "Port Charges", "Shipping Line Charges",
                                "Port Storage", "VAT", "Final Clearing",
                                "Others", "Agency Fee"],
           "shipping_line" => ["Ocean Freight", "Container Demurrage"],
           "final_clearing_agent" => ['Border Clearing Expense']
          }

ITEM_FOR = { 'transporter'=> ['container'] , 'icd'=> ['container'] , 'shipping_line'=> ['bl'], 'clearing_agent'=> ['bl'],
             'final_clearing_agent' => ['container']}
CHARGES_CLASSIFICATION = {'container' =>["Haulage","Empty Return","Truck Detention","Local Shunting",
                                         "ICD Charges", "Border Clearing Expense", "Other charges"],
                      'bl' => ["Ocean Freight", "Container Demurrage", "Port Charges", "Shipping Line Charges", "Port Storage", 
                               "VAT", "Final Clearing", "Others", "Agency Fee", "Ocean Freight", "Container Demurrage"]
                        }
#ITEM_FOR = { transporter: ['container'] , icd: ['container'] , shipping_line: ['bl'], clearing_agent: ['bl']}
