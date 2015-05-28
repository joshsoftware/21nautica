require 'patch'

DESTINATION_PORTS = %W(Nhava\ Sheva Mundra Tuticorin Chennai Jebel\ Ali Mersin)
TYPE = %W(TBL Haulage)
EQUIPMENT_TYPE = %W(20GP 40GP 40OT 40FR 20OT)
SHIPPING_LINE = %W(CMA\ CGM Maersk  Evergreen Safmarine PIL Emirates MSC COSCO 
  NYK\ line SASI\ INT'L\ FREIGHT\ LOGISTICS\ LTD)
# Time in Days
STATUS_CHANGE_DURATION = {arrived_malaba_border: 2,
                          crossed_malaba_border: 2,
                          order_released: 2,
                          arrived_port: 3,
                          document_handed: 1}
PAYMENT_MODES = %W(Cheque Cash TT)
INVOICE_PARTICULARS = %w( Ocean\ Freight Clearing\ Charges ICD Demurrage 
	Empty Final\ Clearing Haulage Forest\ Permits Port\ Storage Other)

