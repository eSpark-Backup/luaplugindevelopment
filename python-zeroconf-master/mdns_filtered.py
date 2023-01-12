
from zeroconf import ServiceBrowser, ServiceListener, Zeroconf
from zeroconf import ZeroconfServiceTypes
x="\n".join(ZeroconfServiceTypes.find())   # Shows All Services
#print("\n*********************Services Types******************\n")
#print(x)
#print("\n***********Services Types Searching Ends*************\n")

def Convert(string):
	li = list(string.split("\n"))
	return li
p = Convert(x)

class MyListener(ServiceListener):

    def add_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        info = zc.get_service_info(type_, name)
        print("\n")

###############################  for HTTP Devices   ###############################################

        if type_== ("_http._tcp.local." or "_smb._tcp.local."):
            if info:
                print("********HTTP device Detected********")          
                print("Device Name: %s " % (info.name))
                print(info._ipv4_addresses)

###############################  for EZLO Devices   ###############################################

        elif type_== "_ezlo._tcp.local.":
            if info:
                print("********EZLO device Detected********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key).startswith("b'Vendor'"):
                        print(key, value)                   

###############################  for AIRPLAY Devices   ###############################################

        elif type_== ("_airplay._tcp.local." or "raop._tcp.local." or "_sleep-proxy._udp.local." or "_touch-able._tcp.local."):      
            if info:
                print("********APPLE device Detected********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)

 ###############################  for SHELLY Devices   ###############################################

        elif type_== "_shelly._tcp.local":
            if info:
                print ("********SHELLY device Detected********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)

			
			
 ###############################  for PHILIPS HUE Devices   ###############################################

        elif type_== "_hue._tcp.local":
            if info:
                print ("********PHILIPS device Detected********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)			
			
							
###############################  for Devices   ###############################################

        elif type_== "device._tcp.local":    
            if info:
                print ("********Device Detected********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)




    def update_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        pass
        #print("\n")
        #print(f"Service {name} updated")

    def remove_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        pass
        #print("\n")
        #print(f"Service {name} removed")



zeroconf = Zeroconf() 
listener = MyListener()


for i in p:
    browser = ServiceBrowser(zeroconf, i, listener)



try:
    input("Press enter to exit...\n\n")
finally:
    zeroconf.close()

