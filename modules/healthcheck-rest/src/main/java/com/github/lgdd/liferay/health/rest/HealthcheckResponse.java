package com.github.lgdd.liferay.health.rest;

import com.liferay.portal.kernel.json.JSONFactoryUtil;

public class HealthcheckResponse {

  private HealthcheckStatus status;
  private String message;

  public HealthcheckResponse(HealthcheckStatus status, String message) {

    this.status = status;
    this.message = message;
  }

  public HealthcheckStatus getStatus() {

    return status;
  }

  public void setStatus(HealthcheckStatus status) {

    this.status = status;
  }

  public String getMessage() {

    return message;
  }

  public void setMessage(String message) {

    this.message = message;
  }

  public String toJson(){

    return JSONFactoryUtil.createJSONSerializer().serialize(this);
  }
}
