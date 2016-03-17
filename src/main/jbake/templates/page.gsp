<%include "header.gsp"%>
	<%include "menu.gsp"%>

    <div class="container section-padded">
        <div class="row title">
            <h2>${content.title}</h2>
        </div>
        <div class="row">
            <%if (content.containsKey('tomeepdf')) {%>
            <div class="col-md-12">
                <i class="fa fa-file-pdf-o"></i> <a href="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>${content.uri.replace('html', 'pdf')}">Download as PDF</a>
            </div>
            <% } %>
            <div class="col-md-12">
                ${content.body}
            </div>
        </div>
    </div>
<%include "footer.gsp"%>
