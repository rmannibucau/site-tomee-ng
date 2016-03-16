<%include "header.gsp"%>
	
	<%include "menu.gsp"%>
	<div class="container section-padded">
        <div class="row title">
            <h2>${content.title}</h2>
        </div>
        <div class="row">
            <div class="col-md-12">
                <%if (content.date) {%><p><em>${content.date}</em></p><% } %>

                ${content.body}
            </div>
        </div>
    </div>
<%include "footer.gsp"%>
