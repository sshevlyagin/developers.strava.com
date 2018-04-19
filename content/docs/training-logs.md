# Training Log 

The Training Log is an aggregated, visual representation of an athlete’s training on Strava. It includes the following elements:

* [Activities](http://developers.strava.com/docs/reference/#api-Activities) (Activities)
* Weekly progress goals (ProgressGoals)
* [Group events](http://developers.strava.com/docs/reference/#api-Clubs) that the athlete has rsvp’d to (GroupEventRsvps)
* [Running races](http://developers.strava.com/docs/reference/#api-RunningRaces) that the athlete has joined (AthleteRunningRaces)
* Planned activities (PlannedEntries)
* A timeline of past group events and races (EventsTimeline)

**Terminology**:

* “Entity” refers to any of the above “elements” included in the training log. For example, `Activities` entities have an `entity_type` of `activity`.
* `EntityEntry` refers to how an entity is represented and returned in the data response. There are `ActivityEntries`, `GoalEntries`, `UpcomingEventEntries`, and `PlannedEntryEntries`
* `GroupEventRsvps` and `AthleteRunningRaces` are returned together as `UpcomingEvents`. An `UpcomingEventEntry` will have an event_type of `past_race`, `running_race`, `group_run`, or `group_ride`.
* `xt_activities` are distinguished as activities whose type is not the requested sport (i.e. Ride when Run is requested, or Yoga when Triathlon is requested).
* “Summary Data” means aggregation over an interval of `moving_time`, `elapsed_time`, `elev_gain`, and `distance`
* `GroupEventRsvps`, `AthleteRunningRaces`, and `PlannedEntries` can all occur in the past, today, or in the future.
* Triathlon requests, where applicable, will create keys for data for `run`, `ride`, and `swim`.
* Data is always returned with respect to the Training Log owner’s local time.

# Endpoints
#### Training Log Data (by weeks)

###### DEFINITION

`GET https://www.strava.com/api/v3/athletes/:id/training/log/weeks?start_week=:start_week&num_weeks=:num_weeks&sport=:sport`

Retrieve the objects that fall within a chunk of weeks.

###### Example Request
        $ curl -G \
            https://www.strava.com/api/v3/athletes/12345670987654/training/log/weeks \
            -d start_week=2016y35w \
            -d num_weeks=12 \
            -d sport=Triathlon \
            -d include_commutes=true \
            -H "Authorization: Bearer 1234567890987654321"
            
<span style="color:EA5929">**Request Parameters**</span>
<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">id</span>
      <br/>
      <span class="parameter-description">
        Integer *required*, in path
      </span>
    </td>
    <td>
        The athelete id of the training log owner.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">start_week</span>
      <br/>
      <span class="parameter-description">
        String *required*, in form data
      </span>
    </td>
    <td>
        Formatted as `YYYYyWWw` i.e. 2016y35w. Corresponds to the most recent week number from which to request data from. For example, to request data for weeks 30-35 in 2016, start_week=2016y35w and num_weeks=6. Weeks must be 0-prefixed, where applicable.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">num_weeks</span>
      <br/>
      <span class="parameter-description">
        Integer *required*, in form data
      </span>
    </td>
    <td>
        The number of weeks of data to request.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">sport</span>
      <br/>
      <span class="parameter-description">
        String *required*, in form data
      </span>
    </td>
    <td>
        Must be either `Run`, `Ride`, or `Triathlon`. Determines what types of entities to filter out of the response. If sport=Triathlon, entities will be returned for “Run”, “Ride”, and “Swim”.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">include_commutes</span>
      <br/>
      <span class="parameter-description">
        Boolean *optional*, in form data
      </span>
    </td>
    <td>
        `true` by default. If `false`, activities tagged as commutes (i.e. commute=1) will not be returned and likewise, not included in any summary totals.
    </td>
  </tr>    
</table>

<span style="color:EA5929">**Top-Level Response Structures**</span>

###### EXAMPLE TOP-LEVEL RESPONSE (TRIATHLON)
``` json
{
  "earliest_date": "2012-02-14",
  "furthest_future_date": "2016-12-04",
  "entries": [
    {
      "id": "2016y50w",
      "month_interval": "2016y12m",
      "month": 11,
      "year": 2016,
      "sport": "triathlon",
      "start_date": 1481500800,
      "end_date": 1482019200,
      "entry": "ENTRY",
      "by_day_of_week": "---BY_DAY_OF_WEEK---",
      "display_type": "multisport_goal",
      "goals_by_sport": "---GOALS_BY_SPORT---",
      "totals_by_sport": "---TOTALS_BY_SPORT---"
    },
    {
      "...": "..."
    }
  ]
}
```
<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">earliest_date</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
        The date of the athlete’s earliest activity, with a limit of Jan 1, 2000. If the athlete has no activities, defaults to Jan 1 of last year.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">furthest_future_date</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
        If the training log owner athlete does not have access to upcoming events, this is today’s date. If the athlete does have access to upcoming events, this is the date of the athlete’s furthest future entity (i.e. furthest away race or group event). If that event is less than 2 weeks away, this is the date 2 weeks from today.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">entries</span>
      <br/>
      <span class="parameter-description" style="color:EA5929">
        Array
      </span>
    </td>
    <td>
        Each element of the array contains data for a requested week, sorted from most recent to least recent. Thus entries.length == num_weeks. This is explained in detail below.
    </td>
  </tr>
</table>

<span style="color:EA5929">**Data Structure for entries**</span>

The data structure for the `entries` returned above is : 

<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">id</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
        The week interval corresponding to this element - same as `start_week` parameter.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">month_interval</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
        The month interval corresponding to this element - formatted the same as `id` and `start_week` parameter. i.e. YYYYyMMm. Month strings are 0-prefixed and 1-indexed i.e. January is 01.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">month</span>
      <br/>
      <span class="parameter-description">
       Integer
      </span>
    </td>
    <td>
        Month corresponding to this element 0-indexed, i.e. January is 0.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">year</span>
      <br/>
      <span class="parameter-description">
        Integer
      </span>
    </td>
    <td>
        Year as YYYY i.e. 2016.
    </td>
  </tr>   
  <tr>
    <td width="200px">
        <span class="parameter-name">start_date</span>
      <br/>
      <span class="parameter-description">
        Integer
      </span>
    </td>
    <td>
        Timestamp since epoch corresponding to the the start of the week or Monday, 00:00:00 local time.
    </td>
  </tr>  
  <tr>
    <td width="200px">
        <span class="parameter-name">end_date</span>
      <br/>
      <span class="parameter-description">
        Integer
      </span>
    </td>
    <td>
        Timestamp since epoch corresponding to the the end of the week or Sunday, 23:59:59 local time.
    </td>
  </tr>
  <tr>
    <td width="200px">
        <span class="parameter-name">by_day_of_week</span>
      <br/>
      <span class="parameter-description">
        Hash
      </span>
    </td>
    <td>
        Keys from 1 to 7 corresponding to Monday-Sunday. Each day contains a hash with keys for `activities`, `upcoming_events`, `planned_entries`, `xt_activities` and `date_type`. Each of the entity keys, accordingly, stores an array of `EntityEntries` of that entity_type occurring on the given day, sorted chronologically (least to most recent) by `start_date` or `occurence_date`. `date_type` is either `past`, `today`, or `future`.
    </td>
  </tr>   
  <tr>
    <td width="200px">
        <span class="parameter-name">entry</span>
      <br/>
      <span class="parameter-description">
        Hash
      </span>
    </td>
    <td>
        Keys for `activities`, `goal`, `planned_entries`, and  `upcoming_events`. Each of those keys, accordingly, stores an array of `EntityEntries` of that `entity_type`, sorted chronologically (least to most recent) by `start_date` or `occurence_date`. Here, all activities, even of non-requested sport type, are in the `activities` array.
    </td>
  </tr>  
  <tr>
    <td width="200px">
        <span class="parameter-name">display_type</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
        Describes the type of Goal. Can be `distance_goal` or `time_goal` for single sport request, or will always be `multisport_goal` for Triathlon request. If the athlete does not have a goal set for the week that this element of entries corresponds to, will be `distance_no_goal`.
    </td>
  </tr>   
  <tr>
    <td width="200px">
        <span class="parameter-name">goals_by_sport</span>
      <br/>
      <span class="parameter-description">
        Hash
      </span>
    </td>
    <td>
        Key(s) corresponding to requested sport(s), stores a GoalEntry. If there are no goals for a sport, or it is not requested, it will not appear as a key in the hash.
    </td>
  </tr> 
  <tr>
    <td width="200px">
        <span class="parameter-name">totals_by_sport</span>
      <br/>
      <span class="parameter-description">
        Hash (Triathlon only)
      </span>
    </td>
    <td>
        “Summary Data” returned by sport.
    </td>
  </tr>  
  <tr>
    <td width="200px">
        <span class="parameter-name">"Summary data"</span>
      <br/>
      <span class="parameter-description">
        Hash (Single sport only)
      </span>
    </td>
    <td>
        “Summary Data” returned as their own keys for each `entries` element.
    </td>
  </tr>   
</table>


EXAMPLE ENTRIES DATA STRUCTURES

entry
``` json
{
  "activities": [
    "---ACTIVITY_ENTRY_1---",
    "---ACTIVITY_ENTRY_2---",
    "---ACTIVITY_ENTRY_3---",
    "---ACTIVITY_ENTRY_4---"
  ],
  "goal": "---GOAL_ENTRY---",
  "planned_entries": [
    "---PLANNED_ENTRY_ENTRY_1---",
    "---PLANNED_ENTRY_ENTRY_2---"
  ],
  "upcoming_events": [
    "---UPCOMING_EVENT_ENTRY_1---",
    "---UPCOMING_EVENT_ENTRY_2---"
  ]
}
```

by_day_of_week
``` json
{
  "by_day_of_week": {
    "1": {
      "activities": [
        "---ACTIVITY_ENTRY_1---",
        "---ACTIVITY_ENTRY_2---"
      ],
      "date_type": "past",
      "planned_entries": [
        "---PLANNED_ENTRY_ENTRY_1---",
        "---PLANNED_ENTRY_ENTRY_2---"
      ],
      "upcoming_events": [
        "---UPCOMING_EVENT_ENTRY_1---",
        "---UPCOMING_EVENT_ENTRY_2---"
      ],
      "xt_activities": [
        "---ACTIVITY_ENTRY_3---",
        "---ACTIVITY_ENTRY_4---"
      ]
    },
    "...": "...",
    "7": "..."
  }
}
```

goals_by_sport
``` json
{
  "run": "---GOAL_ENTRY---",
  "ride": "---GOAL_ENTRY---",
  "swim": "---GOAL_ENTRY---"
}
```

totals_by_sport
``` json
{
  "run": {
    "distance": 12174.9,
    "elapsed_time": 6929,
    "elev_gain": 99,
    "moving_time": 3475
  },
  "ride": {
    "distance": 84673.9,
    "elapsed_time": 11741,
    "elev_gain": 590,
    "moving_time": 10228
  },
  "swim": {
    "distance": 1500.0,
    "elapsed_time": 2040,
    "elev_gain": 0,
    "moving_time": 2040
  }
}
```
EXAMPLE ENTITY ENTRIES

``` json
ActivityEntry

{
  "id": 999999999999,
  "entity_type": "activity",
  "name": "Afternoon Ride",
  "description": "Feeling good today",
  "type": "Run",
  "workout_type": 0,
  "start_date": 1472866272,
  "utc_offset": -25200,
  "moving_time": 1865,
  "elapsed_time": 3006,
  "distance": 6280.3,
  "elev_gain": 44,
  "speed": 3.36,
  "avg_watts": 0,
  "commute": 0,
  "private": 0,
  "trainer": 0
}


GoalEntry

{
  "goal": 241402,
  "type": "DistanceGoal"
}


UpcomingEventEntry

{
  "id": 999999999,
  "entity_type": "upcoming_event",
  "entry_type": "group_ride",
  "name": "Hawk Hill",
  "start_date": 1475760600,
  "utc_offset": -25200,
  "description": "Come to ride fast, come to ride slow.",
  "distance": null,
  "moving_time": null,
  "url": "/clubs/1111111/group_events/999999999",
  "logo_alt": "Our Friend Group",
  "logo_url": "https://cloudfront.net/pictures/clubs/1111111/large.jpg",
  "state": "rsvp"
}


PlannedEntryEntry
{
  "id": 1111111111,
  "athlete_id": 999999999,
  "entity_type": "planned_entry",
  "entry_type": 0,
  "name": "Mile Repeats",
  "description": "6 intervals with 2 minutes rest.",
  "start_date_local": 1475673825,
  "start_date": 1475699025,
  "utc_offset": -25200,
  "activity_type": 9,
  "type": "Run",
  "workout_type": 0,
  "moving_time": 3723,
  "elapsed_time": 3723,
  "distance": 16093.4,
  "elev_gain": 30.48,
  "route_id": null
}
```

#### Events Timeline

###### DEFINITION

`GET https://www.strava.com/api/v3/athletes/:id/training/log/weeks/timeline?sport=:sport`

Retrieve an athlete’s significant events in the past and future, organized by the year and month that they occurred in.
Significant events constitute:

* future [running races](http://developers.strava.com/docs/reference/#api-RunningRaces) that the athlete has joined (running_race)
* future `group events` that the athlete has rsvp’d to (group_ride or group_run)
* past [activities](http://developers.strava.com/docs/reference/#api-Activities) of any sport that the athlete has tagged as a “Race” (`past_race`)

###### Example Request
        $ curl -G \
            https://www.strava.com/api/v3/athletes/12345678909876543/training/log/weeks \
            -d sport=Triathlon \
            -H "Authorization: Bearer 1234567890987654321"


<span style="color:EA5929">**Parameters**</span>
<table class="parameters">
  <tr>
    <td width="200px">
        <span class="parameter-name">id</span>
      <br/>
      <span class="parameter-description">
        Integer *required*, in path
      </span>
    </td>
    <td>
        The athelete id of the training log owner.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">sport</span>
      <br/>
      <span class="parameter-description">
        String *required*, in form data
      </span>
    </td>
    <td>
      Must be either `Run`, `Ride`, or `Triathlon`. Determines what types of `activities` to return. Note that joined `running_races` and `group_events` will always be returned regardless of requested sport. The `past_races` will, however, respect the requested sport.
    </td>
  </tr>
</table>
 
<span style="color:EA5929">**Top-Level Response Structures**</span>
<table class="parameters">
  <tr>
    <td width="200px">
      <span class="parameter-name">earliest_date</span>
      <br/>
      <span class="parameter-description">
         String
      </span>
    </td>
    <td>
      The date of the athlete’s earliest activity, with a limit of Jan 1 2000. If the athlete has no activities, defaults to Jan 1 of last year.
    </td>
   </tr>
   <tr>
    <td width="200px">
      <span class="parameter-name">furthest_future_date</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
      If the training log owner athlete does not have access to upcoming events, this is today’s date. If the athlete does have access to upcoming events, this is the date of the athlete’s furthest future entity (i.e. furthest away race or group event). If that event is less than 2 weeks away, this is the date 2 weeks from today.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">years</span>
      <br/>
      <span class="parameter-description" style="color:EA5929">
         Array
      </span>
    </td>
    <td>
      Each element of the array contains data for a year in the athlete’s history, sorted reverse chronologically (from least recent to most recent).       
      Each element contains an identifying year as a YYYY int (i.e. 2016), and a months array of hashes, also ordered reverse chronologically.
      Each element of the months array accordingly contains an identifying month (1-indexed i.e. January is 1) and an events array. 
      The detailed structure is described below.
    </td>
  </tr>   
</table>


<span style="color:EA5929">**Event Data Structure**</span>

Each element of the events array is represented as follows

<table class="parameters">
  <tr>
    <td width="200px">
      <span class="parameter-name">id</span>
      <br/>
      <span class="parameter-description">
         Integer
      </span>
    </td>
    <td>
      The unique identifier for that particular event’s type. For example, a `past_race` is an `Activity` and would thus contains the `activity.id`.
    </td>
   </tr>
   <tr>
    <td width="200px">
      <span class="parameter-name">name</span>
      <br/>
      <span class="parameter-description">
        String
      </span>
    </td>
    <td>
      The name of the event.
    </td>
  </tr>
  <tr>
    <td width="200px">
      <span class="parameter-name">type</span>
      <br/>
      <span class="parameter-description">
         String
      </span>
    </td>
    <td>
      The type of event. Can be `running_race`, `group_ride`, `group_run`, or `past_race`.
    </td>
  </tr>   
  <tr>
    <td width="200px">
      <span class="parameter-name">start_date</span>
      <br/>
      <span class="parameter-description" >
         Integer
      </span>
    </td>
    <td>
      The start date and time of the event, as a timestamp since epoch.
    </td>
  </tr>  
  <tr>
    <td width="200px">
      <span class="parameter-name">utc_offset</span>
      <br/>
      <span class="parameter-description">
         Integer
      </span>
    </td>
    <td>
      The utc offset in the event’s zone at the time the event occurred.
    </td>
  </tr>      
</table>

EXAMPLE RESPONSE

``` json
{
  "earliest_date": "2015-12-14",
  "furthest_future_date": "2016-10-04",
  "years": [
    {
      "year": 2015,
      "months": [
        {
          "events": [

          ],
          "month": 12
        }
      ]
    },
    {
      "months": [
        {
          "events": [
            {
              "id": 12345667890987665,
              "name": "ABC Nationals Alumni Relay - Bike",
              "start_date": 1461447000,
              "type": "past_race",
              "utc_offset": -25200
            },
            {
              "id": 12345667890987665,
              "name": "ABC Nationals Alumni Relay - Run",
              "start_date": 1461447000,
              "type": "past_race",
              "utc_offset": -25200
            }
          ],
          "month": 1
        },
        {
          "...": "..."
        },
        {
          "events": [
            {
              "id": 12345667890987665,
              "name": "Pastry Ride",
              "start_date": 1478179800,
              "type": "group_ride",
              "utc_offset": -25200
            }
          ],
          "month": 9
        },
        {
          "events": [
            {
              "id": 12345667890987665,
              "name": "California Marathon",
              "start_date": 1480863600,
              "type": "running_race",
              "utc_offset": -28800
            }
          ],
          "month": 10
        }
      ],
      "year": 2016
    }
  ]
}
```
