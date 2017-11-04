package com.strava.api.v3.services;

import com.strava.api.v3.CollectionFormats;
import com.strava.api.v3.models.StreamSet;
import io.reactivex.observers.TestObserver;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.assertNotNull;

public class StreamsApiTest extends ApiTest {

  private static StreamsApi streamsApi;

  @BeforeClass
  public static void buildStreamsApi() {
    streamsApi = getApiClient().createService(StreamsApi.class);
  }

  @Test
  public void testGetActivityStream() throws InterruptedException {
    CollectionFormats.CSVParams keys = new CollectionFormats.CSVParams("altitude", "distance");
    TestObserver<StreamSet> observer = streamsApi.getActivityStreams(
        1196721622L, keys, true).test().await();
    observer.assertNoErrors();
    StreamSet streams = observer.values().get(0);
    assertNotNull(streams.getDistance());
    assertNotNull(streams.getAltitude());
  }

  @Test
  public void testGetSegmentStream() throws InterruptedException {
    CollectionFormats.CSVParams keys = new CollectionFormats.CSVParams("altitude", "latlng");
    TestObserver<StreamSet> observer = streamsApi.getSegmentStreams(
        8109834L, keys, true).test().await();
    observer.assertNoErrors();
    StreamSet streams = observer.values().get(0);
    assertNotNull(streams.getLatlng());
    assertNotNull(streams.getAltitude());
  }

  @Test
  public void testGetSegmentEffortStream() throws InterruptedException {
    CollectionFormats.CSVParams keys = new CollectionFormats.CSVParams("latlng");
    TestObserver<StreamSet> observer = streamsApi.getSegmentEffortStreams(
        29487713000L, keys, true).test().await();
    observer.assertNoErrors();
    StreamSet streams = observer.values().get(0);
    assertNotNull(streams.getLatlng());
  }
}
