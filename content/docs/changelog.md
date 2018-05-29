# Strava V3 API Changelog

The Strava mobile applications and 3rd party applications use the V3 API to communicate with Strava. The Strava API Team strives to provide a stable interface with clear documentation. It is important to maintain a clear record of functional changes to the V3 API; the changelog is the official external record of these changes.

###### May 25, 2018
+ `GET https://www.strava.com/oauth/authorize` returns the scope of the eventual token in the response.

###### May 18, 2018
+ Add the [deauthorization webhook events](../webhooks).

###### January 17, 2018
+ Athlete-specific data requires authentication.

###### January 16, 2018
+ Release the [activity-update webhook events](../webhooks) system.

###### November 9, 2017
+ Update Premium weight classes so that `0_124` is the bottom bucket for the [segment leaderboard](../reference/#api-Segments-getLeaderboardBySegmentId) endpoint. 

###### October 19, 2017
+ Add expanded Premium weight classes and age groups to [segment leaderboard](../reference/#api-Segments-getLeaderboardBySegmentId) endpoint.

###### October 11, 2017
+ Delete club announcements endpoint.

###### August 29, 2017 
+ Add `owner_id` to [club detail](../reference/#api-models-DetailedClub).
+ Add endpoints to approve club membership, decline club membership, promote a club admin, and revoke a club admin.

###### August 3, 2017
+ Add `type` and `after` to [list routes](../reference/#api-Routes-getRoutesByAthleteId) endpoint. 
+ Add `created_at` and `updated_at` to [route detail](../reference/#api-Routes-getRouteById) endpoint, and deprecate `timestamp`.

###### August 1, 2017
+ Deprecate club announcements endpoint.

###### July 24, 2017
+ Replace [athlete detail](../reference/#api-models-DetailedAthlete) with [athlete summary](../reference/#api-models-SummaryAthlete) on [OAuth token exchange](../authentication).
+ Add `email` to [athlete summary](../reference/#api-models-SummaryAthlete) endpoint.

###### June 27, 2017
+ Add PR counts to [activity summary](../reference/#api-models-SummaryAthlete) endpoint.

###### April 10th, 2017
+ Add pagination & `estimated_moving_time` to [route detail](../reference/#api-Routes-getRouteById) endpoint.

###### March 20, 2017
+ Add `name` to route meta endpoint.

###### March 9, 2017
+ Add schedule-related fields to group event detail endpoint.

###### March 1, 2017
+ Add endpoint to delete group event.

###### February 24, 2017
+ Add `start_latlng` to group event summary endpoint.

###### February 3, 2017
+ Add `joined` to group event summary endpoint. 

###### January 17, 2017
+ Removed delete activity endpoint.

###### January 9, 2017
+ Add name to [club meta](../reference/#api-models-MetaClub) endpoint.

###### December 20, 2016
+ Add group event endpoint.

###### December 15, 2016
+ Add route meta representation.
+ Deprecate `route_id` fields in group event summary group event detail.

###### December 12, 2016
+ Add `club` representations
+ Deprecate `club_id` fields in group event summary and group event detail.

###### December 9, 2016
+ Add `joined` field to group event detail.

###### December 9, 2016
+ Add group event join and leave endpoints.

###### December 5, 2016
+ Add laps and pace zones to [activity detail](../reference/#api-models-DetailedActivity) endpoint. 
+ Add a [laps-specific endpoint](../reference/#api-Activities-getLapsByActivityId).

###### December 2, 2016
+ Restructure club group events into a new page.

###### December 2, 2016
+ Update [club members](../reference/#api-Clubs-getClubMembersById) endpoint to respect Enhanced Privacy Mode.

###### November 2, 2016
+ Add [featured running races](../reference/#api-RunningRaces-getRunningRaces).

###### September 21, 2016
+ Add brand guidelines.

###### August 31, 2016
+ Add ability to [star](../reference/#api-Segments-starSegment) and unstar a segment.

###### August 25, 2016
+ Add `city`, `state` and `country` to [club summary](../reference/#api-models-SummaryClub) endpoint.

###### June 30, 2016
+ Add power zones to [athlete zones](../reference/##api-Athletes-getLoggedInAthleteZones) endpoint.

###### June 27th, 2016
+ Add `private` to [club summary](../reference/#api-models-SummaryClub) endpoint.

###### June 9, 2016
+ Add vanity `url` to [club detail](../reference/#api-models-DetailedClub)) and [club summary](../reference/#api-models-SummaryClub) endpoints. 

###### June 2, 2016
+ Add new [athlete zones](../reference/#api-Athletes-getLoggedInAthleteZones) endpoint to display heart rate zones.

###### May 13, 2016
+ Add club `admin` and `owner` statuses to [club detail](../reference/#api-models-DetailedClub)) endpoint.

###### May 9, 2016
+ Add `following_count` to [club detail](../reference/#api-models-DetailedClub) endpoint.

###### May 2, 2016
+ Add [club admins](../reference/#api-Clubs-getClubAdminsById) endpoint.

###### April 26, 2016
+ New sort orders for [club members](../reference/#api-Clubs-getClubMembersById) endpoint.

###### April 22, 2016
+ Update [club join](../reference/#api-Clubs-joinClubById) for `private` clubs.

###### April 21, 2016
+ Add device name to [activity detail](../reference/#api-models-DetailedActivity)) endpoint.

###### April 20, 2016
+ Add club `membership` status to [club detail](../reference/#api-models-DetailedClub) endpoint.

###### April 13, 2016
+ Update [club detail](../reference/#api-models-DetailedClub) for invite-only clubs to be visible to non-members.

###### March 21, 2016
+ Add `has_heartrate` to [activity detail](../reference/#api-models-DetailedActivity) endpoint.

###### December 29, 2015
+ Add swim stats to [athlete stats](../reference/#api-Athletes-getStats) endpoint.

###### December 23, 2015
+ Add `elev_high`, `elev_low`, `max_watts` to [activity summary](../reference/#api-models-SummaryActivity) and [activity detail](../reference/#api-models-DetailedActivity) endpoints.

###### December 11, 2015
+ Add [route](..reference/#api-Routes-getRouteById) and route streams endpoints.

###### December 10, 2015
+ Move activity location attribute deprecation to December 18, 2016.

###### December 3, 2015
+ Include `suffer_score` in [activity summary](../reference/#api-models-SummaryActivity)) endpoint.

###### November 23, 2015
+ Deprecate activity location attributes.

###### October 8, 2015
+ Add embed token to [activity detail](../reference/#api-models-DetailedActivity) endpoint.

###### September 25, 2015
+ Remove `CrossCountrySkiing` from list of valid activity types on [activity summary](../reference/#api-models-SummaryActivity) and [activity detail](../reference/#api-models-DetailedActivity)) endpoints. 

###### September 25, 2015
+ Add `hazardous` attribute to [segment summary](../reference/#api-models-SummarySegment).

###### July 17, 2015
+ Add `trainer` option to activity create endpoint.
+ Add `commute` option to [activity upload](../reference/#api-Uploads-createUpload) endpoint.

###### July 16, 2015
+ Add `private` and `commute` options to activity create endpoint.

###### June 12, 2015
+ Remove `trucated` from [activity summary](../reference/#api-models-SummaryActivity) and [activity detail](../reference/#api-models-DetailedActivity) endpoints. 

###### June 12, 2015
+ Clarify updating athlete gender.

###### June 5, 2015
+ Document `total_photo_count` parameter on [activity summary](../reference/#api-models-SummaryActivity) and [activity detail](../reference/#api-models-DetailedActivity) endpoints.

###### May 18, 2015
+ Add `athlete_type` to [athlete detail](../reference/#api-models-DetailedActivity) endpoint.

###### April 27, 2015
+ Add club group events endpoint.

###### April 7, 2015
+ Document photo-specific changes to [activity detail](../reference/#api-models-DetailedActivity) and [photos summary](../reference/#api-models-PhotosSummary) endpoints.

###### April 6, 2015
+ Add [club announcements](../reference/#api-Clubs-getClubAnnouncementsById) endpoint.

###### March 10, 2015
+ Add `weight` to [athlete detail](../reference/#api-models-DetailedAthlete) endpoint.

###### February 7, 2015
+ Document [athlete stats](../reference/#api-Athletes-getStats) and [segment leaderboard](../reference/#api-Segments-getLeaderboardBySegmentId) endpoints.

###### December 29, 2014
+ Document [activity related](../reference/#api-Activities-getRelatedActivities) (group activity) endpoint.

###### December 18, 2014
+ Add [join club](../reference/#api-Clubs-joinClubById) and [leave club](../reference/#api-Clubs-leaveClubById).
+ Add TCX support for 'hiking', 'walking', and 'swimming'.

###### September 23, 2014
+ Add `weighted_average_watts` to the [activity summary](../reference/#api-models-SummaryActivity) endpoint
+ Add documentation about the generic "with barometer" device.

###### September 5, 2014
+ Add `device_watts` to [athlete activities](../reference/#api-Activities-getLoggedInAthleteActivities), which indicates if the source of the power data is a device or Strava's estimate.

###### August 26, 2014
+ Add new [activity](../reference#api-Activities-getActivityById) types.

###### August 11, 2014
+ Represent [segment effort](../reference/#api-SegmentEfforts-getSegmentEffortById) IDs ith 64-bit datatypes.

###### July 24, 2014
+ Add [list starred segments](../reference/#api-Segments-getLoggedInAthleteStarredSegments) endpoint for any athlete.

###### June 15, 2014
+ Add `starred` to [segment summary](../reference/#api-models-SummarySegment) and remove `pr_effort_id`, `pr_time` and `pr_distance`.
+ Add `star_count` to [segment detail](../reference/#api-models-DetailedSegment) endpoint.

###### June 3, 2014
+ Add `average_cadence`, `average_watts`, `average_heartrate` and `max_heartrate` to the [segment effort](../reference/#api-SegmentEfforts-getSegmentEffortById) endpoint.
+ Remove `bike_weight` and `athlete_weight` from the [activity zones](../reference/#api-Activities-getZonesByActivityId) endpoint.

###### April 7, 2014
+ Add [list segment efforts](../reference/#api-SegmentEfforts-getEffortsBySegmentId) endpoint to list segment efforts filtered by date and athlete.

###### March 17, 2014
+ Remove `calories` attribute from the [activity summary](../reference/#api-models-SummaryActivity) endpoint.

###### February 26, 2014
+ Rename [activity upload](../reference/#api-Uploads-createUpload)  parameter `stationary` to `trainer` for consistency throughout the API.

###### February 10, 2014
+ Add `hidden` attribute to segment effort objects returned as part of an [activity detail](../reference/#api-models-DetailedAthlete) response.

###### February 3, 2014
+ Allow the clearing of gear from an activity by passing 'none' for `gear_id` on [activity update](../reference/#api-Activities-updateActivityById).

###### January 31, 2014
+ Add `pr_effort_id` to [segment summary](../reference/#api-models-SummarySegment). 
+ Include `pr_distance` and `pr_time` in segment summary in addition to [segment detaile](../reference/#api-models-SummarySegment).

###### January 24, 2014
+ Add [segment leaderboard](../reference/#api-Segments-getLeaderboardBySegmentId) pagination.

###### January 12, 2014
+ Add `location_country` to [athlete](../reference/#api-models-SummaryAthlete)), [activity](../reference/#api-models-SummaryActivity)), [segment](../reference/#api-models-SummarySegment)) and [club](../reference/#api-models-SummaryClub)) summary endpoints.

###### January 8, 2014
+ Remove `gear` object from [activity summary](../reference/#api-models-SummaryActivity), provide `gear_id` instead.
+ Add [activity laps](../reference/#api-Activities-getLapsByActivityId) endpoint.

###### January 6, 2014
+ Expand [club detail](../reference/#api-models-DetailedClub) to include more attributes such as `description`, `type`, `location`, etc.
+ Add endpoint to [delete activity](../reference/#api-Activities-deleteActivityById).
