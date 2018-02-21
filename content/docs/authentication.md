+++
date = "2016-02-14T16:11:58+05:30"
title = "Authentication"
slug = "authentication"
+++

Strava uses OAuth2 as an authentication protocol. It allows external applications to request authorization to a user’s private data without requiring their Strava username and password. It allows users to grant and revoke API access on a per-application basis and keeps users’ authentication details safe.

All developers need to register their application before getting started. A registered application will be assigned a Client ID and Client SECRET. The SECRET should never be shared.

## Overview of the 3-legged OAuth flow

Strava provides an authorization mechanism that is an implementation of OAuth 2.0 [3-legged flow](http://oauthbible.com/#oauth-2-three-legged).

In this flow, the user is prompted by the application to log in on the Strava website and to give consent to the requesting application.

If the user authorizes the application, the Strava website will issue a redirect response to a URL of the application's choosing. This URL will include an authorization code. Using this code, the application must complete the process by exchanging the code for an access token.

This is done by presenting a `client_id` and `client_secret` (obtained during application registration), along with the authorization code, to Strava. Upon success, an access token will be returned that can be used to access the API on behalf of the user.

The access token represents the granting of access of a user to an application. Users can revoke access by deleting the token for a given application on their settings page.

## Request access

To initiate the flow, redirect the user to Strava’s authorization page, `GET https://www.strava.com/oauth/authorize`. The page will prompt the user to consent access of your application to their data while providing basic information about what is being asked.

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">client_id</span>
      <br>
      <span class="parameter-description">
        required integer, in query
      </span>
    </td>
    <td>
        The application’s ID, obtained during registration
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">redirect_uri</span>
      <br>
      <span class="parameter-description">
        required string, in query
      </span>
    </td>
    <td>
        URL to which the user will be redirected with the authorization code, must be to the callback domain associated with the application, or its sub-domain, `localhost` and `127.0.0.1` are white-listed.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">response_type</span>
      <br>
      <span class="parameter-description">
        required string, in query
      </span>
    </td>
    <td>
        Must be `code`.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">approval_prompt</span>
      <br>
      <span class="parameter-description">
        string, in query
      </span>
    </td>
    <td>
        `force` or `auto`, use `force` to always show the authorization prompt even if the user has already authorized the current application, default is ‘auto’.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">scope</span>
      <br>
      <span class="parameter-description">
        string, in query
      </span>
    </td>
    <td>
      <p>
        The requested scopes of the eventual token, as a comma delimited string of `view_private` and/or `write`. By default, applications can only view a user’s public data. The scope parameter can be used to request more access. It is recommended to only requested the minimum amount of access necessary.
      </p>
      <ul>
        <li>`public`: default, private activities are not returned, privacy zones are respected in stream requests.</li>
        <li>`write`: modify activities, upload on the user’s behalf.</li>
        <li>`view_private`: view private activities and data within privacy zones.</li>
        <li>`view_private,write`:both ‘view_private’ and ‘write’ access.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">state</span>
      <br>
      <span class="parameter-description">
        string, in query
      </span>
    </td>
    <td>
        Returned to your application in the redirect URI. Useful if the authentication is done from various points in an app.
    </td>
  </tr>
</table>

## Token exchange

Strava will respond to the authorization request by redirecting the user agent to the `redirect_uri` provided.

On success, a `code` parameter will be included in the query string. If access is denied, `error=access_denied` will be included in the query string. In both cases, if provided, the `state` parameter will also be included.

If the user accepts the request to share access to their Strava data, Strava will redirect back to `redirect_uri` with the authorization code. The application must now exchange the temporary authorization code for an access token, using its client ID and client secret. The endpoint is `POST https://www.strava.com/oauth/token`.

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">client_id</span>
      <br>
      <span class="parameter-description">
        required integer, in query
      </span>
    </td>
    <td>
        The application’s ID, obtained during registration.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">client_secret</span>
      <br>
      <span class="parameter-description">
        required string, in query
      </span>
    </td>
    <td>
        The application’s secret, obtained during registration.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">code</span>
      <br>
      <span class="parameter-description">
        required string, in query
      </span>
    </td>
    <td>
        The `code` parameter obtained in the redirect.
    </td>
  </tr>
</table>

## Access the API using an Access Token

The application will now be able to make requests on the user’s behalf using the `access_token` query string parameter or by specifying the `Authorization` header. For instance, using [HTTPie](https://httpie.org/):

```
$ http https://www.strava.com/api/v3/athlete 'Authorization: Bearer 83ebeabdec09f6670863766f792ead24d61fe3f9'
$ http 'https://www.strava.com/api/v3/athlete?access_token=83ebeabdec09f6670863766f792ead24d61fe3f9'
```

Applications should check for a 401 Unauthorized response. Access for those tokens has been revoked by the user.

## Deauthorization

Allows an application to revoke its access to an athlete’s data. This will invalidate all access tokens associated with the ‘athlete,application’ pair used to create the token. The application will be removed from the Athlete Settings page on Strava. All requests made using invalidated tokens will receive a 401 Unauthorized response.

The endpoint is `POST https://www.strava.com/oauth/deauthorize`.

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">access_token</span>
      <br>
      <span class="parameter-description">
        required string, in query
      </span>
    </td>
    <td>
        Responds with the access token submitted with the request.
    </td>
  </tr>
</table>
