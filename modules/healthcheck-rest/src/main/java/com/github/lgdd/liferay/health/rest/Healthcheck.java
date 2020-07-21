package com.github.lgdd.liferay.health.rest;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Application;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.apache.felix.dm.ComponentDeclaration;
import org.apache.felix.dm.diagnostics.DependencyGraph;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.jaxrs.whiteboard.JaxrsWhiteboardConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Component(
    immediate = true,
    property = {
        JaxrsWhiteboardConstants.JAX_RS_APPLICATION_BASE + "=/health",
        JaxrsWhiteboardConstants.JAX_RS_NAME + "=Health",
        "oauth2.scopechecker.type=none",
        "liferay.access.control.disable=true"
    },
    service = Application.class
)
public class Healthcheck
    extends Application {


  @GET
  @Path("/readiness")
  @Produces(MediaType.APPLICATION_JSON)
  public Response readiness() {

    return verifyComponents();
  }

  @GET
  @Path("/liveness")
  @Produces(MediaType.APPLICATION_JSON)
  public Response liveness() {

    return verifyComponents();
  }

  public Response verifyComponents() {

    String dependencyGraphState = "No unregistered components found";

    DependencyGraph graph = DependencyGraph.getGraph(
        DependencyGraph.ComponentState.UNREGISTERED,
        DependencyGraph.DependencyState.REQUIRED_UNAVAILABLE);

    List<ComponentDeclaration> unregisteredComponents =
        graph.getAllComponents();

    if (unregisteredComponents.isEmpty()) {
      return Response
          .ok(new HealthcheckResponse(HealthcheckStatus.UP, dependencyGraphState).toJson())
          .build();
    }

    dependencyGraphState =
        unregisteredComponents.size() +
            " unregistered components found: ";

    _log.warn(dependencyGraphState);

    for (ComponentDeclaration componentDeclaration :
        unregisteredComponents) {

      BundleContext bundleContext =
          componentDeclaration.getBundleContext();

      if (bundleContext != null) {
        Bundle bundle = bundleContext.getBundle();

        if (bundle != null) {
          _log.warn(
              "Found unregistered component " +
                  componentDeclaration.getName() +
                  " in bundle: " + bundle.getSymbolicName());
        }
      }
    }
    return Response.serverError()
                   .entity(
                       new HealthcheckResponse(HealthcheckStatus.DOWN, dependencyGraphState)
                           .toJson()
                   )
                   .build();
  }

  public Set<Object> getSingletons() {

    return Collections.singleton(this);
  }

  private static final Logger _log = LoggerFactory.getLogger(Healthcheck.class);
}
