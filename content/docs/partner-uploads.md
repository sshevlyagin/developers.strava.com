+++
title = "Partner Activity Uploads"
slug = "partner-uploads"
+++

<br>
Partners can upload an activity and attach a photo to that activity in two steps.
Please email developers@strava.com to request access to the partner upload flow, or if you have questions while integrating against the partner upload API.

#### Step 1: Upload an activity and photo metadata

Uploading activities as a partner is identical to the normal activity upload flow.
Partners can upload activities with or without a file, and there are details about each option below.

As a partner, Strava will recognize your app and automatically generate a signed URL for your photo.
After a successful activity upload request, the response will include this URL to upload a photo in step 2.

##### Upload an activity with a file
If you wish to upload streams (e.g. location, elapsed time, heart rate, etc.), please familiarize yourself with our [file-based activity upload instructions](../uploads).
Here is an example request.

###### Example Upload Creation Request
		$ curl -X POST https://www.strava.com/api/v3/uploads \
		        -H "Authorization: Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9" \
		        -F activity_type=ride \
		        -F file=@test.fit \
		        -F data_type=fit

###### Example Upload Creation Response
	{
	    "id": 1570175274,
	    "external_id": "Lunch_Run.gpx",
	    "error": null,
	    "status": "Your activity is still being processed.",
	    "activity_id": null
	}

If the file was uploaded successfully, the response code will be `201 Created`.
Strava then processes your file data to create an activity, which usually takes about 8 seconds.

You can check the status of your upload to see when an activity has been created from your upload.

###### Example Upload Check Request
	  $ curl -G https://www.strava.com/api/v3/uploads/16486788 \
	      -H "Authorization: Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9"

When an activity has been created, the upload check response will contain a `"photo_metadata"` field with a `"uri"` which contains the URL to upload a photo in step 2.
Before the activity is finished processing, the upload check will not contain a `"photo_metadata"` field.

###### Example Upload Check Response

	{
	    "id": 1570175274,
	    "external_id": "Lunch_Run.gpx",
	    "error": null,
	    "status": "Your activity is ready.",
	    "activity_id": 1456449319,
	    "photo_metadata": [
	      {
	        "uri": "https://strava-photo-uploads-prod.s3.amazonaws.com/sU&AWSAccessKeyId=ZOI&Expires=1521148201&Signature=LEfm%3D",
	        "header": {
	            "Content-Type": "image/jpeg"
	        },
	        "method": "PUT",
	        "max_size": 1600
	      }
	    ]
	}

You should now be able to see your activity at www.strava.com/activities/{id}, where {id} is the `id` field that was returned in the API response.

##### Upload an activity without a file
If you wish to upload an activity without streams, please familiarize yourself with our [activity creation (without a file) documentation](../reference/#api-Activities-createActivity).
Here is an example request.

###### Example Request
	  $ curl -X POST https://www.strava.com/api/v3/activities \
	        -H "Authorization: Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9" \
	        -d name="Most Epic Ride EVER!!!" \
	        -d elapsed_time=18373 \
	        -d distance=1557840
	        -d start_date_local="2013-10-23T10:02:13Z" \
	        -d type="Ride"

If the activity is created successfully, the response code will be `201 Created` and the response will contain a `"photo_metadata"` field with a `"uri"` which contains the URL to upload a photo in step 2.

###### Example Response
	{
	    "id": 12345678987654321,
	    "resource_state": 3,
	    "external_id": null,
	    "upload_id": null,
	    "athlete": {
	      "id": 12345678987654321,
	      "resource_state": 1
	    },
	    "photo_metadata": {
	      [
	        {
	          "uri": "https://strava-photo-uploads-prod.s3.amazonaws.com/snsU&AWSAccessKeyId=ZOI&Expires=1521148201&Signature=LEHffm%3D",
	          "header": {
	              "Content-Type": "image/jpeg"
	          },
	          "method": "PUT",
	          "max_size": 1600
	        }
	      ]
	    }
	}

You should now be able to see your activity at www.strava.com/activities/{id}, where {id} is the `id` field that was returned in the API response.

#### Step 2: Upload a photo

After successfully completing step 1, you should have a `"uri"` which contains the address where you should upload your photo.
Images should be uploaded in their raw format with a `image/jpeg` content type, not using a multipart form or base64 encoding.

Two important notes:

1. You can upload JPG or PNG images, but you should always specify the `image/jpeg` content type in your request.

2. Make sure to unescape the `"uri"` from step 1 before using it in step 2. All `\u0026`s should be `&`s.

###### Example Request
	  $ curl -X PUT "https://strava-photo-uploads-prod.s3.amazonaws.com/snsU&AWSAccessKeyId=ZOI&Expires=1521148201&Signature=LEHffm%3D" \
	        -H "Content-Type: image/jpeg" \
	        --upload-file download.jpg

The response should be a `200 OK` with no response body.

You should now be able to see the photo attached to your activity at at www.strava.com/activities/{id}.
