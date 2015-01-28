require 'patch'

DESTINATION_PORTS = %W(Nhava\ Sheva Mundra Tuticorin Chennai Jebel\ Ali Mersin)
TYPE = %W(TBL Haulage)
EQUIPMENT_TYPE = %W(20GP 40GP 40OT 40FR 20OT)
SHIPPING_LINE = %W(CMA\ CGM Maersk  Evergreen Safmarine PIL Emirates)
#TRANSPORTERS =  Vendor.pluck(:name)
#%W(Mansons Farsham Panafrica Crown Panafrica\ Logistics Midland\ Hauliers Blue\ Jay)
# Time in Days
STATUS_CHANGE_DURATION = {arrived_malaba_border: 2,
                          crossed_malaba_border: 2,
                          order_released: 2,
                          arrived_port: 3,
                          document_handed: 1}
CLEARING_AGENTS = %W(Panafrica EACL Agility Paul)
PAYMENT_MODES = %W(Cheque Cash TT)

