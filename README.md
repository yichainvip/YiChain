![Yi logo](http://www.Yichain.vip/cn/images/logo400.png)


# YiChain
*Delphi REST Library*

Build your REST applications (server and client) with my library:
1. lightweight: no dictations on your application code, no heavy dependencies, take what you need of the library;
1. standard: build Delphi REST servers to be consumed by other technologies (including web apps, .Net, Java, php...) and build your client applications against any REST server;
1. Delphi-like: built using modern Delphi features and enabled with Delphi-to-Delphi specific facilities to get more power!

- Compatibility: **Recent Delphi versions (from XE7 up to 10.2.2 Tokyo)** (older versions should be quite compatible)

# Get started
* Grab a copy of Yichain (git clone or download zip)
* Add three folders to your Library Path:
  * [Yichain Folder]\Source
  * [Yichain Folder]\ThirdParty\delphi-jose-jwt\Source
  * [Yichain Folder]\ThirdParty\mORMot\Source
* Packages (example for 10.2 Tokyo Enterprise):
  * Open [Yichain Folder]\Packages\102Tokyo\Yichain.Enterprise.groupproj
    * Build All
  * Open [Yichain Folder]\Packages\102Tokyo\YichainClient.Enterprise.groupproj
    * Build All
    * Install YichainClient.Core
    * Install YichainClient.FireDAC    

(please correct accordingly to your Delphi version and edition)

# Demos and YichainTemplate
* Try some demos (i.e. "Demos\HelloWorld", "Demos\Authorization", "Demos\FireDAC Basic")
* compile and run the Yichaincmd_VCL.dproj in [Yichain Folder]\Utils\Source\Yichaincmd, it will help you to create your first project by cloning "Demos\YichainTemplate" into a new folder

# Map (list most functionalities and concepts)

[PDF](media/Yichain-Curiosity%20Map.pdf) | [PNG](media/Yichain-Curiosity%20Map.png)
![Yichain map](media/Yichain-Curiosity%20Map.png)

# Contributions
This is an open source project, so obviously every contribution/help/suggestion will be very appreciated.
Most of the code has been written by me with some significant contributions by Nando Dessena and Stefan Glienke. Some of my customers actually act as beta testers and early adopters (I want to thank them all for the trust and efforts).


