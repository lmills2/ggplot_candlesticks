# Long / Short PnL Positions with Candles through KX Dashboards ggplot (Analyst Visual)
This repository contains a q script and a dashboards file to demonstrate using GG Plot for dashboards, with a focus on creating a candlesticks graph.

 ![image](https://user-images.githubusercontent.com/90591113/133034719-69a426f5-4042-4ec0-8212-3a553a7767b8.png)

## Installation
This demo can be run on a local version of Dashboards. You will need the local version of Developer installed also. The dashboard and script files can be downloaded from this repository.
* Local Developer: https://code.kx.com/developer/
* Local Dashboards: https://code.kx.com/dashboards/
### Installation - Developer
* Ensure that Developer is installed and working.
### Installation - Dashboards
#### Configuring Dashboards
* Right click on the dash.bat file that is used to start local Dashboards and select edit.
* Add this line to the beginning of this script: `CALL "C:\path\to\local\developer\config\config.bat"`<br/>
Where the path points to the installation directory of your local Developer copy. This line is calling the config script of Developer that is used to set the environment variables before Developer starts.<br/>
![image](https://user-images.githubusercontent.com/90591113/133193162-4be117b6-1ee3-4643-b83c-d7b2f46e5074.png)
* Save the changes and close.
* Start up your dashboards session.
* Inside the shell window named 'Demo Data', run this command: `\l C:\path\to\file\ggplot.q`<br/>
Where the path points to the location of the ggplot.q q script you downloaded from the repository.<br/>
![image](https://user-images.githubusercontent.com/90591113/133193426-9e1c0be5-faad-4b34-ace6-a2348f994e56.png)<br/>
This loads the q script into the process. Alternatively, you can set the script to be automatically loaded when Dashboards starts:
* Inside the Dashboards install directory, open the 'sample' folder.
* Put the ggplot.q script inside this folder.
* Edit the demo.q script.
* Search for this line - `load datafilter analytics`
* After this line, add the following line: `\l sample/ggplot.q`
* Save and close. Now when starting Dashboards, the script will be automatically loaded.
#### Importing the Dashboard
* Open the Dashboard and enter into edit mode by adding `edit/` to the URL. 
![image](https://user-images.githubusercontent.com/90591113/133036511-b02b0040-2cf5-44e5-9dd7-b6c01b443e27.png)
* Click on the navigator drop down on the top right of the page and select 'Manage Dashboards'
![image](https://user-images.githubusercontent.com/90591113/133036693-9d5c6b57-7364-4075-bff9-3fbb13c633c9.png)
* In the menu, select the 'Import' button and select the 'GG Plot Dashboard.json' file downloaded from this repository.
![image](https://user-images.githubusercontent.com/90591113/133037068-20b54917-e4f2-4766-8755-7cd32c5b282b.png)
* Once it is uploaded, select the 'GG Plot - Candlesticks Trade' dashboard from the list and click Open.
## Configuration
By default, the code generates 1 million market trades. This number can be adjusted by changing the function call to gen_marketTrades at the end of the q script.
## Usage
The graph can be panned left and right using the top slider control and zoomed in and out using the bottom slider control in conjunction with the Range Type dropdown.
The top slider control selects the mid point for the graph. The bottom slider selects a time range to select data from. For example, setting the Range Type to 'Day' and the bottom slider to a value of three, the graph will show data in a 6 day range, centred on the time set by the top slider.
## More Information
More information on Grammar of Graphics can be found here: https://code.kx.com/developer/libraries/grammar-of-graphics/<br/>
More examples of GG Plot can be found here: https://code.kx.com/developer/gg-examples/
