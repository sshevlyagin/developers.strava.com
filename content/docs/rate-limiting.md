# Rate limiting

Strava API usage is limited on a per-application basis using both a 15-minute and daily request limit.
The default rate limit allows 600 requests every 15 minutes, with up to 30,000 requests per day.
This limit allows applications to make 40 requests per minute for about half the day.
As an application grows, its rate limit may need to be adjusted.
To request an adjustment, email [api@strava.com](mailto:api@strava.com?subject=Rate%20Limits) with the subject "Rate Limits".

An application's 15-minute limit is reset at natural 15-minute intervals corresponding to 0, 15, 30 and 45 minutes after
the hour. The daily limit resets at midnight UTC.
Requests exceeding the limit will return `403 Forbidden` along with a JSON error message.
Note that requests violating the short term limit will still count toward the long term limit.

An application's limits and usage are reported on the [API application settings](https://www.strava.com/settings/api)
page as well as returned with every API request as part of the HTTP Headers:

<table class="parameters">
  <tr>   
    <td width="200px">
        <span class="parameter-name">X-RateLimit-Limit</span>
      <br>
      <span class="parameter-description">
        integer, integer <br /> two comma-separated values
      </span>
    </td>
    <td>
        15-minute limit, followed by daily limit.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">X-RateLimit-Usage</span>
      <br>
      <span class="parameter-description">
        integer, integer <br /> two comma-separated values
      </span>
    </td>
    <td>
        15-minute usage, followed by daily usage.
    </td>
  </tr>
</table>
<br>

Below is an example request using to the Strava API using [HTTPie](https://httpie.org/), along with sample response headers for a
successful and rate-limited request:

###### Example request

    $ http 'https://www.strava.com/api/v3/athlete' \
        'Authorization:Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9'

###### Example successful response headers

    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    Date: Tue, 10 Oct 2013 20:11:01 GMT
    X-Ratelimit-Limit: 600,30000
    X-Ratelimit-Usage: 254,12536

###### Example rate-limited response headers

    HTTP/1.1 403 Forbidden
    Content-Type: application/json; charset=utf-8
    Date: Tue, 10 Oct 2013 20:11:05 GMT
    X-Ratelimit-Limit: 600,30000
    X-Ratelimit-Usage: 642,27300
