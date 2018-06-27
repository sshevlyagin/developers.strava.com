+++
date = "2016-02-14T16:11:58+05:30"
title = "Strava API V3 Documentation"
+++

The Strava V3 API is a publicly available interface allowing developers access to the rich Strava dataset. The interface is stable and currently used by the Strava mobile applications.

## Access

All calls to the Strava API require an `access_token` defining the athlete and application making the call. Any registered Strava user can obtain an access_token by first creating an application at https://www.strava.com/settings/api.

The API application settings page provides a public access token to get started. See the [Authentication](/docs/authentication) page for more information about generating access tokens and the OAuth authorization flow.

Generally speaking, a Strava API application only has access to a user’s data after the user has authorized the application to use it. Segment and segment leaderboard data is available to all applications.

## Rate Limiting

Strava API usage is limited on a per-application basis using a short term (15 minute) limit and a long term (daily) limit. The default rate limit allows 600 requests every 15 minutes, with up to 30,000 requests per day. This limit allows applications to make 40 requests per minute for about half the day.

An application’s short term limit is reset at natural 15 minute intervals corresponding to 0, 15, 30 and 45 minutes after the hour. The long term limit resets at midnight UTC. Requests exceeding the limit will return 403 Forbidden along with a JSON error message. Note that requests violating the short term limit will still count toward the long term limit.

An application’s limits and usage are reported on the API application settings page as well as returned with every API request as part of the HTTP Headers.

* **X-RateLimit-Limit:** short term limit, long term limit
* **X-RateLimit-Usage:** short term usage, long term usage

As an application grows its rate limit may need to be reassessed. To request an adjustment, email [api@strava.com](mailto:api@strava.com?subject=Rate%20Limits) with the subject "Rate Limits".

## Conventions

### Object representations
Depending on the type of request, objects will be returned in meta, summary or detailed representations. The representation of the returned object is indicated by the resource_state attribute.

Resource states, in increasing levels of detail.

1. meta
2. summary
3. detailed

### Pagination

Requests that return multiple items will be paginated to 30 items by default. The page parameter can be used to specify further pages or offsets. The per_page may also be used for custom page sizes up to 200. Note that in certain cases, the number of items returned in the response may be lower than the requested page size, even when that page is not the last. If you need to fully go through the full set of results, prefer iterating until an empty page is returned.

### Polylines

Activity, segment and route API requests may include summary polylines of their respective paths. The values are string encodings of the latitude and longitude points using the [Google encoded polyline algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm) format.

### Dates

Dates and times follow the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) standard, unless noted. A few examples:

* 2015-08-23T15:46:20Z
* 2018-06-24T09:54:13-07:00

For some resources the `start_date_local` attribute is provided as a convenience. It represents the UTC version of the local start time of the event. Displaying this value as UTC will show the correct local start time. The local time zone is also provided for some resources and can be used along with the start_date to achieve this as well.

### Request methods

Where possible, API V3 strives to use appropriate HTTP verbs for each action.

* **HEAD** can be issued against any resource to get just the HTTP header info
* **GET** used for retrieving resources
* **POST** used for creating resources, or performing custom actions
* **PUT** used for updating or replacing resources
* **DELETE** used for removing resources