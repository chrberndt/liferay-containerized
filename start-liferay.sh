#!/bin/sh

function main {
	if [ "${LIFERAY_JPDA_ENABLED}" == "true" ]
	then
		${LIFERAY_HOME}/tomcat-9.0.33/bin/catalina.sh jpda run
	else
		${LIFERAY_HOME}/tomcat-9.0.33/bin/catalina.sh run
	fi
}

main
