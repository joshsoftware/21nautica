require 'patch'

DESTINATION_PORTS = %W(Nhava\ Sheva Mundra Tuticorin Chennai Jebel\ Ali Mersin Sydney Kolkata KARACHI PORT\ QASIM MATADI DOHA TOKYO)
TYPE = %W(TBL Haulage)
CURRENCY = %w(USD UGX)
EQUIPMENT_TYPE = %W(20GP 40GP 40OT 40FR 20OT)
ROLE = %W(Admin Staff Yard Operations Accounts)
SALES_REP_NAMES = ['Kaushik', 'Rajan'] 
EMAILS_DEFAULTS = ENV['EMAILS_DEFAULTS'] 
#SHIPPING_LINE = %W(CMA\ CGM Maersk  Evergreen Safmarine PIL Emirates MSC COSCO 
#  NYK\ line WECLINES)
# Time in Days
STATUS_CHANGE_DURATION = {arrived_malaba_border: 2,
                          crossed_malaba_border: 2,
                          order_released: 2,
                          arrived_port: 3,
                          document_handed: 1}
PAYMENT_MODES = %W(Cheque Cash TT)
#INVOICE_PARTICULARS = %w( Ocean\ Freight Clearing\ Charges ICD Demurrage 
#	Empty Final\ Clearing Haulage Forest\ Permits Port\ Storage Other)
INVOICE_PARTICULARS = ["Ocean Freight", "Agency Fee", "THC as per Line", "Container Demurrage", "Port Charges as per KPA", "Final Clearing", "Transport Charges", "Forest Permits", "Port Storage", "Other"]
PORTS = {"Dar Es Salaam" => ["Kigali", "Lusaka", "Goma"], "Mombasa" => ["Kampala", "Kigali"]}
CHARGES = {"transporter" => ["Haulage", "Empty Return", "Truck Detention", "Local Shunting"],
           "icd" => ["ICD Charges", 'Other charges'],
           "clearing_agent" => ["Ocean Freight", "Container Demurrage",
                                "Port Charges", "Shipping Line Charges",
                                "Port Storage", "VAT", "Final Clearing",
                                "Others", "Agency Fee"],
           "shipping_line" => ["Ocean Freight", "Container Demurrage", "THC"],
           "final_clearing_agent" => ['Border Clearing Expense'],
           "port_authority" => ['Port Charges', 'Port Storage', 'Others/Misc']
          }

ITEM_FOR = { 'transporter'=> ['container'] , 'icd'=> ['container'] , 'shipping_line'=> ['bl'], 'clearing_agent'=> ['bl'],
             'final_clearing_agent' => ['container'], 'port_authority' => ['bl'] }
CHARGES_CLASSIFICATION = {'container' =>["Haulage","Empty Return","Truck Detention","Local Shunting",
                                         "ICD Charges", "Border Clearing Expense", "Other charges", 'THC',
                                         'Port Charges', 'Port Storage', 'Others/Misc' ],
                      'bl' => ['Haulage', "Ocean Freight", "Container Demurrage", "Port Charges", "Shipping Line Charges", "Port Storage", 
                               "VAT", "Final Clearing", "Others", "Agency Fee", "Ocean Freight", "Container Demurrage", 'THC',
                               'Port Charges', 'Port Storage', 'Others/Misc']
                        }
#ITEM_FOR = { transporter: ['container'] , icd: ['container'] , shipping_line: ['bl'], clearing_agent: ['bl']}
