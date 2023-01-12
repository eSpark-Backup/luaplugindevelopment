# Here all the Windows Visual Studio C language files for mDNS discovery can be found

## To compile and run use the following scripts at windows administrator cmd

``` c:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat ```

``` cl mdns.c /Zi /Fdmdns.pdb /link /out:mdns.exe ws2_32.lib iphlpapi.lib ```
