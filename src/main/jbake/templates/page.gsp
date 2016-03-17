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
            <%if (content.body) {%>
            <div class="col-md-12">
                ${content.body}
            </div>
            <% } %>
            <%if (content.containsKey('tomeecontributors')) {%>
            <div class="col-md-12">
                <%
                    def loader = this.class.classLoader
                    try { // ensure we already added target/classes to the build
                        loader.loadClass('org.apache.tomee.website.Contributors')
                    } catch (java.lang.ClassNotFoundException cnfe) {
                        loader.addURL(new java.io.File("target/classes").toURI().toURL())
                    }
                    def path = content.uri + "/../" + content.get('tomeecontributors');
                    def contributors =loader.loadClass('org.apache.tomee.website.Contributors').getMethod('load', String).invoke(null, path)
                    contributors.each {contributor ->
                %>
                <div class="contributors">
                  <div class="col-sm-4">
                    <div class="photo col-sm-5">
                      <img alt="${contributor.name}" src="${contributor.gravatar}?s=140">
                    </div>
                    <div class="col-sm-7">
                      <h3 class="contributor-name">${contributor.name}</h3>
                      <p>${contributor.description ? contributor.description : ''}</p>
                      <ul class="list-inline">
                      <%contributor.link.each {l ->%>
                      <li><a href="${l.url}">${l.name}</a></li>
                      <%}%>
                      </ul>
                    </div>
                  </div>
                </div>
                <%}%>
            </div>
            <% } %>
        </div>
    </div>
<%include "footer.gsp"%>
