<%@ include file="init.jsp" %>

<c:set var="heroImageURL"
       value="https://enix.io/fr/services/formation/online/fullofcards_hud03efc7a5ca2c733e1a66eeabdf75901_123807_300x0_resize_box_2.png"/>

<div class="container-wrapper">
    <div class="container">
        <div id="hero-container" class="row align-items-lg-center">
            <div class="col-lg-7 mb-7 mb-lg-0">

                <h1 class="mb-4">
                    <span class="badge badge-pill badge-warning mb-4">
                        <liferay-ui:message key="enix-widget.in-remote"/>
                    </span>
                    <br>Notre formation <span class="text-primary font-weight-bold">Docker</span> et
                    <span class="text-primary font-weight-bold">
                        <%-- TODO add "Kubernetes" --%>

                    </span>
                </h1>
                <ul>
                    <li>
                        <liferay-ui:message key="enix-widget.prepare-certifications"/>
                    </li>
                    <li>
                        <liferay-ui:message key="enix-widget.operate-k8s"/>
                    </li>
                    <li>
                        <liferay-ui:message key="enix-widget.master-docker"/>
                    </li>
                </ul>
            </div>
            <div class="col-lg-4 offset-lg-1 col-md-8 offset-md-2">
                <picture id="hero-image">
                    <%-- TODO update placeholder with ${heroImageURL} --%>
                    <img src='${"https://dummyimage.com/300x367/333/fff"}'
                         alt="">
                </picture>
            </div>
        </div>
    </div>

    <figure class="position-absolute-bottom-0">
        <svg preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg" width="100%"
             height="140px"
             viewBox="20 -20 300 100" style="margin-bottom: -8px;" xml:space="preserve">
				<path class="u-fill-white" opacity="0.4" d="M30.913,43.944c0,0,42.911-34.464,87.51-14.191c77.31,35.14,113.304-1.952,146.638-4.729
		c48.654-4.056,69.94,16.218,69.94,16.218v54.396H30.913V43.944z"></path>
            <path class="u-fill-white" opacity="0.4" d="M-35.667,44.628c0,0,42.91-34.463,87.51-14.191c77.31,35.141,113.304-1.952,146.639-4.729
		c48.653-4.055,69.939,16.218,69.939,16.218v54.396H-35.667V44.628z"></path>
            <path class="u-fill-white" opacity="0" d="M43.415,98.342c0,0,48.283-68.927,109.133-68.927c65.886,0,97.983,67.914,97.983,67.914v3.716
		H42.401L43.415,98.342z"></path>
            <path class="u-fill-white" d="M-34.667,62.998c0,0,56-45.667,120.316-27.839C167.484,57.842,197,41.332,232.286,30.428
		c53.07-16.399,104.047,36.903,104.047,36.903l1.333,36.667l-372-2.954L-34.667,62.998z"></path>
			</svg>
    </figure>
</div>
