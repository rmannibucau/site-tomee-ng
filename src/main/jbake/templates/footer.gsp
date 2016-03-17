<footer>
		<div class="container">
			<div class="row">
				<div class="col-sm-6 text-center-mobile">
					<h3 class="white">Apache TomEE the little great server.</h3>
					<h5 class="light regular light-white">"A good application in a good server"</h5>
					<a href="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>admin/index.html" class="btn btn-blue ripple trial-button">Administration</a>
					<a href="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>developer/index.html" class="btn btn-blue ripple trial-button">Developer</a>
					<a href="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>advanced /index.html" class="btn btn-blue ripple trial-button">Advanced</a>
				</div>
				<div class="col-sm-6 text-center-mobile">
				    <!--
					<h3 class="white">Some title <span class="open-blink"></span></h3>
					<div class="row opening-hours">
						<div class="col-sm-6 text-center-mobile">
							<h5 class="light-white light">Left</h5>
							<h3 class="regular white">Sub left</h3>
						</div>
						<div class="col-sm-6 text-center-mobile">
							<h5 class="light-white light">Right</h5>
							<h3 class="regular white">Sub right</h3>
						</div>
					</div>
					-->
				</div>
			</div>
			<div class="row bottom-footer text-center-mobile">
				<div class="col-sm-8">
					<p>Copyright &copy; 1999-2016 The Apache Software Foundation, Licensed under the Apache License, Version 2.0. Apache TomEE, TomEE, Apache, the Apache feather logo, and the Apache TomEE project logo are trademarks of The Apache Software Foundation. All other marks mentioned may be trademarks or registered trademarks of their respective owners.</p>
				</div>
				<div class="col-sm-4 text-right text-center-mobile">
					<ul class="social-footer">
						<li><a href="https://fr-fr.facebook.com/ApacheTomEE/"><i class="fa fa-facebook"></i></a></li>
						<li><a href="https://twitter.com/apachetomee"><i class="fa fa-twitter"></i></a></li>
						<li><a href="https://plus.google.com/communities/105208241852045684449"><i class="fa fa-google-plus"></i></a></li>
					</ul>
				</div>
			</div>
		</div>
	</footer>
	<!-- Holder for mobile navigation -->
	<div class="mobile-nav">
		<ul>
		</ul>
		<a href="#" class="close-link"><i class="arrow_up"></i></a>
	</div>
	<!-- Scripts -->
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/jquery-1.11.1.min.js"></script>
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/owl.carousel.min.js"></script>
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/bootstrap.min.js"></script>
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/wow.min.js"></script>
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/typewriter.js"></script>
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/jquery.onepagenav.js"></script>
	<script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/tree.jquery.js"></script>
    <script src="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>js/main.js"></script>
</body>

</html>
