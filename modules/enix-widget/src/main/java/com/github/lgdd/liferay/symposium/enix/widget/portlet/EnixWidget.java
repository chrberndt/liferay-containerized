package com.github.lgdd.liferay.symposium.enix.widget.portlet;

import com.github.lgdd.liferay.symposium.enix.widget.constants.EnixWidgetKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import javax.portlet.Portlet;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component(
    immediate = true,
    property = {
        "com.liferay.portlet.display-category=category.sample",
        "com.liferay.portlet.header-portlet-css=/css/main.css",
        "com.liferay.portlet.css-class-wrapper=enix-widget",
        "com.liferay.portlet.instanceable=true",
        "javax.portlet.display-name=Enix Widget",
        "javax.portlet.init-param.template-path=/",
        "javax.portlet.init-param.view-template=/view.jsp",
        "javax.portlet.name=" + EnixWidgetKeys.ENIXWIDGET,
        "javax.portlet.resource-bundle=content.Language",
        "javax.portlet.security-role-ref=power-user,user"
    },
    service = Portlet.class
)
public class EnixWidget
    extends MVCPortlet {

  @Activate
  public void activate() {

    log.info("+-----------------------+");
    log.info("| ENIX Widget is READY! |");
    log.info("+-----------------------+");
  }

  private static final Logger log = LoggerFactory.getLogger(EnixWidget.class);

}
