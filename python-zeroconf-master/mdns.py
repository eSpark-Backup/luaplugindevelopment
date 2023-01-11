
from zeroconf import ServiceBrowser, ServiceListener, Zeroconf
from zeroconf import ZeroconfServiceTypes
x="\n".join(ZeroconfServiceTypes.find())   # Shows All Services
print("\n*********************Services Types******************")
print(x)
print("***********Services Types Searching Ends*************\n")

def Convert(string):
	li = list(string.split("\n"))
	return li
p = Convert(x)

class MyListener(ServiceListener):

    def update_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        print("\n")
        print(f"Service {name} updated")

    def remove_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        print("\n")
        print(f"Service {name} removed")

    def add_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        info = zc.get_service_info(type_, name)
        print("\n")
        print(f"Service {name} added, \n service info: {info}")


zeroconf = Zeroconf() 
listener = MyListener()


for i in p:
    browser = ServiceBrowser(zeroconf, i, listener)

try:
    input("Press enter to exit...\n\n")
finally:
    zeroconf.close()

