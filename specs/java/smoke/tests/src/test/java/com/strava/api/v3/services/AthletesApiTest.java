package com.strava.api.v3.services;

import com.strava.api.v3.models.DetailedAthlete;
import io.reactivex.observers.TestObserver;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class AthletesApiTest extends ApiTest {

  private static AthletesApi athletesApi;

  @BeforeClass
  public static void buildAthletesApi() {
    athletesApi = getApiClient().createService(AthletesApi.class);
  }

  @Test
  public void testGetAthleteById() throws InterruptedException {
    TestObserver<DetailedAthlete> observer = athletesApi.getAthleteById(136697).test().await();
    observer.assertNoErrors();
    DetailedAthlete athlete = observer.values().get(0);
    assertEquals("Julien", athlete.getFirstname());
  }
}
