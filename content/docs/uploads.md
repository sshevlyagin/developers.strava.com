+++
title = "Uploading to Strava"
slug = "uploads"
+++

<br>
Uploading to Strava is an asynchronous process. A file is uploaded using a multipart/form-data POST request which performs initial checks on the data and enqueues the file for processing. The activity will not appear in other API requests until it has finished processing successfully.

Processing status may be checked by polling Strava. A one-second or longer polling interval is recommended. The mean processing time is currently around 8 seconds. Once processing is complete, Strava will respond to polling requests with the activity’s ID.

Errors can occur during the submission or processing steps and may be due to malformed activity data or duplicate data submission.


## Supported file types
Strava supports FIT, TCX and GPX file types as described below. New file types are not on the road map. Developers are encouraged to use one of these types as it will also maximize compatibility with other fitness applications.

All files are required to include a time with each trackpoint or record, as defined by the file format. Information such as lat/lng, elevation, heartrate, etc. is optional. Manual creation of activities without a data file is not currently supported by the API.

If you feel your file is compatible with the standards but is still not uploading to Strava, please verify that it works with other fitness applications before contacting support.


### FIT - Flexible and Interoperable Data Transfer
Strava strives to comply with the FIT Activity File (FIT_FILE_TYPE = 4) spec as defined in the official [FIT SDK](https://www.thisisant.com/resources/fit).

There are many attributes defined by FIT. Below is an overview of the ones used by Strava.

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">
            <b>MESSAGE TYPES </b>
        </span>
    </td>
    <td width="200px">
        <span class="parameter-name">
            <b>ATTRIBUTES </b>
        </span>
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name"><b>file_id</b></span>
    </td>
    <td>
        <span>
            manufacturer <br/> 
            product <br/>
            time_created
        </span>
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name"><b>session</b></span>
    </td>
    <td>
        <span>
            sport <br/> 
            total_elapsed_time <br/>
            total_timer_time <br/>
            total_distance <br/>
            total_ascent
         </span>
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name"><b>lap</b></span>
    </td>
    <td>
        <span>
            timestamp <br/>
            total_elapsed_time <br/> 
            total_timer_time <br/>
            total_distance <br/>
            total_ascent
        </span>
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name"><b>record</b></span>
    </td>
    <td>
        <span>
            timestamp <br/>
            position_lat <br/> 
            position_long <br/>
            altitude <br/>
            heart_rate <br/>
            cadence <br/>
            distance <br/>
            power <br/>
            temperature
        </span>
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name"><b>event</b></span>
    </td>
    <td>
        <span>
            timestamp <br/> 
            type 
        </span>
    </td>
  </tr>     
</table>

Activity type is detected from `session.sport`.

### TCX - Training Center Database XML
The TCX format was developed by Garmin as part of their Training Center software. For Strava users, an advantage is its ability to include power information. However, it does not support temperature. Strava supports version 2 as defined by Garmin ([schema file](http://www8.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd)).

The base version of TCX does not allow for the inclusion of run cadence or power. As a result, TCX has been extended. From the extensions available, Strava extracts from the `<Trackpoint>` tag:

* runcadence as cadence
* watts as power

Strava reads TCX Courses and only uses the `<Track>`, `<TotalTimeSeconds>` and `<DistanceMeters>` from the `<Lap>` tag. All other averaging information is ignored.

Activity type is detected from `<Activity Sport="*">` where ‘biking’, ‘running’, ‘hiking’, ‘walking’ and ‘swimming’ are mapped to their respective activity types. No other types are currently supported.

A reference TCX file can be obtained for any of your own activities from the Strava website. Visit [here](http://www.strava.com/activities/:id/export_tcx), first replacing :id with the ID of one of your own activities.

### GPX - GPS Exchange Format
GPX is a widely used XML format for geospacial data. Strava follows version 1.1 as [defined by Topografix](http://www.topografix.com/gpx.asp).

The base version of GPX does not allow for the inclusion of heartrate, cadence, distance or temperature data. As a result, extensions to GPX were created and Strava supports the two most popular plus a general format. The extensions extend the <trkpt> tag to include extra attributes with each datapoint.

[Garmin’s Track Point Extension v1](http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd)
From the extensions available, Strava extracts:

* `atemp` as temperature
* `hr` as heartrate

[Cluetrust GPX extension](http://www.cluetrust.com/Schemas/gpxdata10.xsd)
From the extensions available, Strava extracts:

* `cadence` as cadence
* `distance` as distance
* `hr` as heartrate
* `temp` as temperature

Strava also detects general tags placed in the `<extensions>` tag of each <trkpt> tag. Strava extracts:

* `cadence` as cadence
* `distance` as distance
* `heartrate` as heartrate
* `power` as power

Some smaller organizations have created their own undefined extensions to GPX. Adding support for these extensions is not on the roadmap and developers are encouraged to use one of those above as it will also maximize compatibility with other fitness applications.


## Device and elevation data
For devices with a barometric altimeter the elevation data is taken as is from the file. Otherwise it is recomputed using the provided lat/lng points and an elevation database. [More information](https://strava.zendesk.com/entries/20965883-Elevation-for-Your-Activity).

Device type is detected in all file types from standard ‘creator’ tags. These tags are then matched to a list of known devices. In some cases the name of the device will be displayed along with the activity details on [strava.com](http://strava.com/).

A generic “with barometer” device is provided to force the system to use the elevation data from TCX and GPX file types. One only needs to add “with barometer” to the end of the creator name. For example, a TCX file would include something like:
<pre>
    <code>
        `<Creator>
            <Name>My Awesome Device with barometer</Name>
         </Creator>`
    </code>
</pre>

and a GPX file should have an updated creator like:

<pre>
    <code> 
        `< gpx version="1.1" creator="Best app ever with Barometer"/>` 
    </code>
</pre>

For total elevation gain, the value is read directly from FIT file headers if the device includes a barometric altimeter. Otherwise, elevation gain will be computed from the elevation data and may be different than reported on the device. Note that to compute elevation gain noise must be removed from the elevation data and different algorithms/sites will produce different results. [More information](https://strava.zendesk.com/entries/20944466-Elevation-Gain).


## Upload an Activity

Requires `write` permissions, as requested during the authorization process.

Posting a file for upload will enqueue it for processing. Initial checks will be done for malformed data and duplicates.

<table class="parameters">
    <tr>
        <td>
            <b>Parameters </b>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>activity_type: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <i>optional, case insensitive </i> <br/>
                <i><u>Possible values </u></i> : ride, run, swim, workout, hike, walk, nordicski, alpineski, backcountryski, iceskate, inlineskate, kitesurf, rollerski, windsurf, workout, snowboard, snowshoe, ebikeride, virtualride <br/>
                Type detected from file overrides, uses athlete’s default type if not specified
            </span>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>name: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <i>optional </i> <br/>
                if not provided, will be populated using start date and location, if available
            </span>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>description: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <i>optional </i> <br/>
            </span>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>private: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>integer </b>
                <i>optional </i> <br/>
                set to 1 to mark the resulting activity as private, ‘view_private’ permissions will be necessary to view the activity 
                If not specified, set according to the athlete’s privacy setting (recommended)
            </span>
        </td>        
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>trainer: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>integer </b>
                <i>optional </i> <br/>
                activities without lat/lng info in the file are auto marked as stationary, set to 1 to force
            </span>
        </td>        
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>commute: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>integer </b>
                <i>optional </i> <br/>
                set to 1 to mark as commute
            </span>
        </td>        
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>data_type: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <i>required, case insensitive </i> <br/>
                <u><i>possible values</i></u>: fit, fit.gz, tcx, tcx.gz, gpx, gpx.gz
            </span>
        </td>        
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>external_id: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <i>optional </i> <br/>
                data filename will be used by default but should be a unique identifier
            </span>
        </td>        
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>file: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>multipart/form-data </b>
                <i>required, case insensitive </i> <br/>
                the actual activity data, if gzipped the data_type must end with .gz
            </span>
        </td>        
    </tr>
</table>

###### DEFINITION
`POST https://www.strava.com/api/v3/uploads`

###### Example Request
        $ curl -X POST https://www.strava.com/api/v3/uploads \
            -H "Authorization: Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9" \
            -F activity_type=ride \
            -F file=@test.fit \
            -F data_type=fit
            
###### Example Response
        {
          "id": 16486788,
          "external_id": "test.fit",
          "error": null,
          "status": "Your activity is still being processed.",
          "activity_id": null
        }

##### Returns an Upload Status object
This object will return a code and an English language status. On success, a `201 Created` will be accompanied by a status of `success`. This indicates that the activity has been successfully accepted, but is still processing. On error, the `400 Bad Request` will be accompanied by a status describing the error, potentially containing HTML.


## Check upload status

A successful upload will return a response with an upload ID. You may use this ID to poll the status of your upload. Strava recommends polling no more than once a second. The mean processing time is around 8 seconds.


<table class="parameters">
    <tr>
        <td>
            <b>Attributes </b>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>id: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>integer </b>
            </span>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>external_id: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
            </span>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>activity_id: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>integer </b>
                <i>may be null </i> <br/>
            </span>
        </td>
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>status: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <br/>
                describes the error, possible values: ‘Your activity is still being processed.’, ‘The created activity has been deleted.’, ‘There was an error processing your activity.’, ‘Your activity is ready.’
            </span>
        </td>        
    </tr>
    <tr>
        <td width="200px">
            <span class="parameter-name">
                <b>error: </b>
            </span>
        </td>
        <td width="800px">
            <span class="parameter-name">
                <b>string </b>
                <i>may be null </i> <br/>
                if there was an error during processing, this will contain a human a human readable error message that may include escaped HTML
            </span>
        </td>        
    </tr>
</table>

###### DEFINITION
`GET https://www.strava.com/api/v3/uploads/:id`

###### Example Request
        $ curl -G https://www.strava.com/api/v3/uploads/16486788 \
            -H "Authorization: Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9"
            
###### Example Responses
        {
          "id": 16486788,
          "external_id": "test.fit",
          "error": null,
          "status": "Your activity is ready.",
          "activity_id": 14296970
        }
         
        
        {
          "id": 16486769,
          "external_id": "testing.fit",
          "error": null,
          "status": "The created activity has been deleted.",
          "activity_id": null
        }


## Errors
You can determine if there was an error during upload by checking the error attribute for null. At this time error and status messages returned as part of the Upload object are human readable English. They may also include escaped HTML.

##### Example Error Response

        {
          "id": 16486790,
          "external_id": "test.fit",
          "error": "test.fit duplicate of activity 14296882",
          "status": "There was an error processing your activity.",
          "activity_id": null
        }