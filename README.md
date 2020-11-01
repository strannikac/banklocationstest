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

When application loaded, data is trying to update. Also customer can update data from main screen (Regions), but data will be updated one time in one hour. Data is updated async. 