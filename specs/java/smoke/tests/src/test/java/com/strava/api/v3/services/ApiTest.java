package com.strava.api.v3.services;

import com.strava.api.v3.ApiClient;

import org.junit.BeforeClass;

public abstract class ApiTest {

  private static ApiClient apiClient;

  @BeforeClass
  public static void buildApiClient() {
    apiClient = new ApiClient(new String[]{"strava_oauth"});
    String accessToken = System.getProperty("accessToken");
    apiClient.setAccessToken(accessToken);
  }

  public static ApiClient getApiClient() {
    return apiClient;
  }
}
