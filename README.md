# Bank Locations

Get all bank locations for different countries from API. 
Show information about each location.

## Implementation

### Initial controller

RegionsTableViewController starts updating data and shows list of regions by country.

### Main controllers

LocationsTableViewController shows list of locations in selected region.
LocationDetailsViewController shows info for selected location.

## Requirements

 - Xcode 12
 - Swift 5
 - Core Data
 - iOS 13.0+

## Solution

When application loaded, data is trying to update. When regions controller or locations controller appear, then updating time is checked and updating process starts, if last update was one hour (or more) ago. I guess this way better than update data every hour in background mode because application can be active rarely, but long time may be stayed in background (in this case it is not necessary to update data).

Data is updated step by step by one country (link). In my opinion it is better for resources and for control also (clear for understanding, if something went wrong). For example, if app got error when data is uploading, app shows alert and starts updating process again. Here can do delay or try to update data for next country (link). But I guessed than we need to update all information for all countries (or nothing).