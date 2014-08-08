DESTINATION_PORTS = %W(Nhava\ Sheva Mundra Tuticorin Chennai)
TYPE = %W(TBL Haulage)
EQUIPMENT_TYPE = %W(20GP 40GP 40OT 40FR 20OT)
SHIPPING_LINE = %W(CMA\ CGM Maersk  Evergreen Safmarine PIL)
TRANSPORTERS = %W(1 2)
# Time in [Hours, Days, Minutes, Seconds]
STATUS_CHANGE_DURATION = {arrived_malaba_border:[0,0,0,1],
													crossed_malaba_border:[0,0,1,0], 
													order_released:[0,0,12,2],
													arrived_port:[2,0,12,2],
													document_handed:[2,0,12,2]}