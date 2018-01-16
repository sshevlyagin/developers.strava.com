+++
title = "Webhook Events API"
slug = "webhooks"
+++

<br>

## Webhooks Overview
Webhook events subscriptions allow an application to subscribe to events that occur within Strava.
These events are pushed to a callback designated by the subscription shortly after the events occur on Strava.
Webhooks enable applications to receive real-time updates while eliminating polling for supported objects.

We encourage all API applications to use our webhook events API.
To request access, email developers@strava.com with your client id, which you can find on your [API settings page](https://strava.com/settings/api), as well as a short description of what your app does -- we love hearing about what people are doing with our API.

## Event Data

The Strava Webhook Events API supports webhook events for Strava activities.

When an event occurs that corresponds to a push subscription, a POST request will be made to the callback url defined in the subscription.
The payload contains the `object_type` and `aspect_type` for the updated object as well as the `object_id`, which is the activity's ID.

You should acknowledge the POST with a status code of 200 OK within two seconds.
Events will be sent up to twice more if a 200 is not returned.
If you need to do more processing of the received information, you can do so in an asynchronous task.
Your endpoint should additionally return a status code of 200 to acknowledge receiving the event.

Additional information about the object is not included, and an application must decide how or if it wants to fetch updated data.
For example, you may decide only to fetch new data for specific users, or after a certain number of activities have been uploaded.

Webhook events are fired whenever an activity is created, deleted, or one of the following fields has been updated:

* Title
* Type
* Privacy, requires a an access token with view_private scope

These are the fields that are returned with webhook events:

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">object_type</span>
      <br>
      <span class="parameter-description">
        string
      </span>
    </td>
    <td>
        Always "activity."
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">aspect_type</span>
      <br>
      <span class="parameter-description">
        string
      </span>
    </td>
    <td>
        Always "create," "update," or "delete."
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">updates</span>
      <br>
      <span class="parameter-description">
        hash
      </span>
    </td>
    <td>
        For update events, keys can contain "title," "type," and "privacy." Empty for delete and create events.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">owner_id</span>
      <br>
      <span class="parameter-description">
        integer
      </span>
    </td>
    <td>
        The activity owner's athlete ID.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">subscription_id</span>
      <br>
      <span class="parameter-description">
        integer
      </span>
    </td>
    <td>
        The push subscription ID that is receiving this event.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">event_time</span>
      <br>
      <span class="parameter-description">
        integer
      </span>
    </td>
    <td>
        The time that the event occurred.
    </td>
  </tr>
</table>

###### Example Request

    {
        "aspect_type": "update",
        "event_time": 1516126040,
        "object_id": 1360128428,
        "object_type": "activity",
        "owner_id": 134815,
        "subscription_id": 120475,
        "updates": {
            "title": "Messy"
        }
    }

Note that a single event can have multiple `updates`.
Also note that some activity attributes take longer to save than others, so one save can result in multiple webhook events.
For example, an updated activity type often takes longer to save than an activity title.

Applications that have a `public` access token (recommended) and not a `view_private` access token will receive a `delete` event when an activity's privacy is changed from public to private
similarly, these applications will receive a `create` event when an activity's privacy is set from private to public.
Per the [Strava API Agreement](https://www.strava.com/legal/api), applications must respect an activity's privacy.

## Subscriptions
Once your application has been approved to receive webhook events by the Strava API Team, you will only need to create one subscription to receive all webhook events for data owned by athletes who have authorized your application.

**Note: No action is required for application owners who created subscriptions with older subscriptions models to continue receiving webhook events.**

Requests to the subscription endpoint are made using the client_id and client_secret of the application because requests are made on behalf of an application.

Note: The subscription service requires a calls to a specific domain:

    $ https://api.strava.com/api/v3/push_subscriptions

### Create a subscription

Clients must make two requests to create a webhook events subscription:

1. Define the desired callback address with application-specific authentication data.

2. Validate that the callback address from the first request is up and running.

Each Strava API application can only have one webhook events subscription and subscriptions cannot be updated, so to update a subscription you will need to delete your existing subscription and create a new subscription with the desired parameters.

#### Initial Subscription Creation Request

Note that request parameters must be sent as HTTP form data, i.e. in URL format.
These are the required request parameters to create a webhook events subscription:

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">client_id</span>
      <br>
      <span class="parameter-description">
        required integer
      </span>
    </td>
    <td>
        Strava API application ID
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">client_secret</span>
      <br>
      <span class="parameter-description">
        required string
      </span>
    </td>
    <td>
        Strava API application secret
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">callback_url</span>
      <br>
      <span class="parameter-description">
        required string
      </span>
    </td>
    <td>
        Address where webhook events will be sent; maximum length of 255 characters
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">verify_token</span>
      <br>
      <span class="parameter-description">
        required string
      </span>
    </td>
    <td>
        String chosen by the application owner for client security. An identical string should be returned by Strava's subscription service.
    </td>
  </tr>
</table>

###### Example Request

    $  curl -X POST https://api.strava.com/api/v3/push_subscriptions \
          -F client_id=5 \
          -F client_secret=7b2946535949ae70f015d696d8ac602830ece412 \
          -F 'callback_url=http://a-valid.com/url' \
          -F 'verify_token=STRAVA'

After your initial request to create a subscription, you will receive a HTTP GET response to the `callback_url` you specified.
The response will contain a `"hub.challenge"` field that you must you to validate your callback address.

Here is the complete list of response fields:

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">hub.mode</span>
      <br>
      <span class="parameter-description">
        string
      </span>
    </td>
    <td>
        Always will be "subscribe".
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">hub.challenge</span>
      <br>
      <span class="parameter-description">
        string
      </span>
    </td>
    <td>
        Random string the callback address must echo back to verify its existence.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">hub.verify_token</span>
      <br>
      <span class="parameter-description">
        string
      </span>
    </td>
    <td>
        This will be set to whatever verify_token is passed in with the initial subscription request, and it enables application owners to know that they are receiving the correct response from Strava's subscription service.
    </td>
  </tr>
</table>

###### Example Response

    {
      "hub.mode": "subscribe",
      "hub.verify_token": "STRAVA",
      "hub.challenge": "15f7d1a91c1f40f8a748fd134752feb3"
    }

#### Callback Validation

Your callback address must respond within two seconds to the response from Strava's subscription service with an HTTP GET request.
You will only have two seconds to echo the `"hub.challenge"`, so you will have to program your client to send the callback validation request automatically.
Your GET request must have a response code of 200 and contain the `"hub.challenge"` key and value as valid JSON, i.e.

    {“hub.challenge”:”15f7d1a91c1f40f8a748fd134752feb3”}

Once you have successfully created a webhook events subscription, you will receive a response with information about your subscription.

###### Example Response
    {
      "id": 1,
      "callback_url": "http://a-valid.com/url",
      "created_at": "2015-04-29T18:11:09.400558047-07:00",
      "updated_at": "2015-04-29T18:11:09.400558047-07:00"
    }

### View a subscription

These are the required request parameters to view an existing webhook events subscription:

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">client_id</span>
      <br>
      <span class="parameter-description">
        required integer
      </span>
    </td>
    <td>
        Strava API application ID
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">client_secret</span>
      <br>
      <span class="parameter-description">
        required string
      </span>
    </td>
    <td>
        Strava API application secret
    </td>
  </tr>
</table>

###### Example Request

    $ curl -G https://api.strava.com/api/v3/push_subscriptions \
        -d client_id=5 \
        -d client_secret=7b2946535949ae70f015d696d8ac602830ece412

### Delete a subscription

These are the required request parameters to delete a webhook events subscription:

<table class="parameters">
  <tr>
    <tr>
     <td width="200px">
         <span class="parameter-name">id</span>
       <br>
       <span class="parameter-description">
         required integer
       </span>
     </td>
     <td>
         Push subscription ID
     </td>
   </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">client_id</span>
      <br>
      <span class="parameter-description">
        required integer
      </span>
    </td>
    <td>
        Strava API application ID
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">client_secret</span>
      <br>
      <span class="parameter-description">
        required string
      </span>
    </td>
    <td>
        Strava API application secret
    </td>
  </tr>
</table>

You will receive a 204 No Content if the delete is successful. Otherwise, an error will be returned containing the reason for a failure.