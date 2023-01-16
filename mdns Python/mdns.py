
from zeroconf import ServiceBrowser, ServiceListener, Zeroconf
from zeroconf import ZeroconfServiceTypes


x="\n".join(ZeroconfServiceTypes.find())

def Convert(string):
	li = list(string.split("\n"))
	return li
p = Convert(x)

class MyListener(ServiceListener):
    def add_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        info = zc.get_service_info(type_, name)
        print("\n")

###############################  for AIRPLAY Devices   ###############################################
    
        if ("airplay") in name:
            if info:
                print("********APPLE device Found********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)



###############################  for SAMSUNG Devices   ###############################################
    
        if ("samsung") in name:
            if info:
                print("********SAMSUNG device Found********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)



###############################  for EZLO Devices   ###############################################

        elif ("ezlo") in name:
            if info:
                print("********EZLO device Found********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key).startswith("b'Vendor'"):
                        print(key, value)  



 ###############################  for SHELLY Devices   ###############################################

        elif ("shelly") in name:
            if info:
                print ("********SHELLY device Found********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)


 ###############################  for PHILIPS HUE Devices   ###############################################

        elif ("hue") in name:
            if info:
                print ("********PHILIPS device Found********")
                print("Device Name: %s "% (info.name))
                print(info._ipv4_addresses)

                for key, value in info.properties.items():
                    if str(key).startswith("b'model'"):
                        print(key, value)

                for key, value in info.properties.items():
                    if str(key) =="b'Firmware Version'":
                        print(key, value)


 ###############################  for SONOS HUE Devices   ###############################################

        elif ("sonos") in name:
            if info:
                print ("********SONOS device Found********")
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