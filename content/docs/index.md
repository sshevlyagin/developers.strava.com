+++
date = "2016-02-14T16:11:58+05:30"
title = "Strava API v3 Documentation"
+++

The Strava v3 API is a publicly available interface allowing developers access to the rich Strava dataset. The interface is stable and currently used by the Strava mobile applications.

## Access

All calls to the Strava API require an `access_token` defining the athlete and application making the call. Any registered Strava user can obtain an access_token by first creating an application at labs.strava.com/developers.

The API application settings page provides a public access token to get started. See the [Authentication](/docs/authentication) page for more information about generating access tokens and the OAuth authorization flow.

Generally speaking, a Strava API application only has access to a user’s data after the user has authorized the application to use it. Segment and segment leaderboard data is available to all applications.

## Conventions

### Object representations
Depending on the type of request, objects will be returned in meta, summary or detailed representations. The representation of the returned object is indicated by the resource_state attribute.

Resource states
1	meta
2	summary
3	detailed
Listed in increasing levels of detail.

### Pagination

Requests that return multiple items will be paginated to 30 items by default. The page parameter can be used to specify further pages or offsets. The per_page may also be used for custom page sizes up to 200. Note that in certain cases, the number of items returned in the response may be lower than the requested page size, even when that page is not the last. If you need to fully go through the full set of results, prefer iterating until an empty page is returned.

### JSON-P callbacks

Specify the `callback=<function_name>` parameter to request a JSONP compatible response. This is compatible with JavaScript libraries such as jQuery.

When developing JavaScript applications, please take care to hide the access_token, i.e. do not include it in any deep linked URLs.

### Polylines

Activity and segment API requests may include summary polylines of their respective routes. The values are string encodings of the latitude and longitude points using the Google encoded polyline algorithm format.

### Dates

Dates and times follow the ISO 8601 standard, unless noted. A few examples:

2008-04-12T00:00:00Z
2012-12-30T17:08:56Z
2013-08-23T15:46:20Z

For some resources the `start_date_local` attribute is provided as a convenience. It represents the UTC version of the local start time of the event. Displaying this value as UTC will show the correct local start time. The local time zone is also provided for some resources and can be used along with the start_date to achieve this as well.

### Request methods

Where possible, API v3 strives to use appropriate HTTP verbs for each action.

HEAD	can be issued against any resource to get just the HTTP header info
GET	used for retrieving resources
POST	used for creating resources, or performing custom actions
PUT	used for updating or replacing resources
DELETE	used for removing resources

## Rate Limiting

Strava API usage is limited on a per-application basis using a short term, 15 minute, limit and a long term, daily, limit. The default rate limit allows 600 requests every 15 minutes, with up to 30,000 requests per day. This limit allows applications to make 40 requests per minute for about half the day.

An application’s short term, 15 minute, limit is reset at natural 15 minute intervals corresponding to 0, 15, 30 and 45 minutes after the hour. The long term, daily limit, it resets at midnight UTC. Requests exceeding the limit will return 403 Forbidden along with a JSON error message. Note that requests violating the short term limit will still count toward the long term limit.

An application’s limits and usage are reported on the API application settings page as well as returned with every API request as part of the HTTP Headers.

X-RateLimit-Limit	integer, integer
two comma separate values, short term followed by long term limit
X-RateLimit-Usage	integer, integer
two comma separate values, short term followed by long term usage

As an application grows its rate limit may need to be reassessed. To request an adjustment contact api-rate-limits -at- strava.com.
