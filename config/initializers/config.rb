DESTINATION_PORTS = %W(Nhava\ Sheva Mundra Tuticorin Chennai)
TYPE = %W(TBL Haulage)
EQUIPMENT_TYPE = %W(20GP 40GP 40OT 40FR 20OT)
SHIPPING_LINE = %W(CMA\ CGM Maersk  Evergreen Safmarine PIL)
TRANSPORTERS = %W(1 2)
# Time in [Hours, Days, Minutes, Seconds]
STATUS_CHANGE_DURATION = {enter_malaba_border:[0,0,0,1],
													exit_malaba_border:[0,0,1,0], 
													release_order:[0,0,12,2], 
													enter_port:[0,0,12,2], 
													handover_document:[0,0,12,2] } 
