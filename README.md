# GG Plot for Dashboards - Candlesticks
This repository contains a q script and a dashboards file to demonstrate using GG Plot for dashboards, with a focus on creating a candlesticks graph.

 ![image](https://user-images.githubusercontent.com/90591113/133034719-69a426f5-4042-4ec0-8212-3a553a7767b8.png)

## Installation
This demo can be run on local versions of Developer and Dashboards. You will need the GG Plot library available (packaged with local Developer). The two required files can be downloaded from this repository.
* Local Developer: https://code.kx.com/developer/
* Local Dashboards: https://code.kx.com/dashboards/
### Installation - Developer
* Start up your developer session and create a new workspace. 
* Right click in the workspace explorer and create a new repository. This can be named anything.
* Right click on the repository name and click New > Upload Local Files. Select the q script you downloaded named "gg plot.q" and click upload.
* Open the q script from the explorer, press Control+A to select all of the code and Control+D to run it.
### Installation - Dashboards
* Start up your dashboards session and enter into edit mode. 
![image](https://user-images.githubusercontent.com/90591113/133036511-b02b0040-2cf5-44e5-9dd7-b6c01b443e27.png)
* Click on the navigator drop down on the top right of the page and select 'Manage Dashboards'
![image](https://user-images.githubusercontent.com/90591113/133036693-9d5c6b57-7364-4075-bff9-3fbb13c633c9.png)
* In the menu, select the 'Import' button and select the 'GG Plot Dashboard.json' file downloaded from this repository.
![image](https://user-images.githubusercontent.com/90591113/133037068-20b54917-e4f2-4766-8755-7cd32c5b282b.png)
* Once it is uploaded, select the 'GG Plot - Candlesticks Trade' dashboard from the list and click Open.
### Troubleshooting
The dashboard should be configured to connect to your local developer session automatically. If you are using a different port than the default 8080 then it will not be able to find it.
* To fix this, go into design mode in Dashboards, click on the large blank area where the GG plot component is, and open its Data Source.
![image](https://user-images.githubusercontent.com/90591113/133037597-5cd7fc37-d58e-4fcf-9cbc-bda4f0833fea.png)
* Inside the data source menu, click the connection manager button and update the port for the 'analyst' connection to the port that your developer session is using.
![image](https://user-images.githubusercontent.com/90591113/133038016-816dfed5-2043-401f-9526-25deefe966db.png)
* Save the changes in this menu and close it.
* Save changes to the dashboard and reload the page. &nbsp;
![image](https://user-images.githubusercontent.com/90591113/133038289-cc1a1599-ad03-4151-86f2-91084e9f1591.png)
## Configuration
By default, the code generates 1 million market trades. This number can be adjusted by changing the function call to gen_marketTrades on line 153 in Developer.
## Usage
The graph can be panned left and right using the top slider control and zoomed in and out using the bottom slider control in conjunction with the Range Type dropdown.
The top slider control selects the mid point for the graph. The bottom slider selects a time range to select data from. For example, setting the Range Type to 'Day' and the bottom slider to a value of three, the graph will show data in a 6 day range, centred on the time set by the top slider.
## More Information
More information on Grammar of Graphics can be found here: https://code.kx.com/developer/libraries/grammar-of-graphics/                
More examples of GG Plot can be found here: https://code.kx.com/developer/gg-examples/
