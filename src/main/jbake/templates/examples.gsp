<%include "header.gsp"%>
<%include "menu.gsp"%>

<div id="main-block" class="container section-padded">
<div class="row title">
  <div class='page-header'>
    <%if (content.containsKey('tomeepdf')) {%>
    <div class='btn-toolbar pull-right'>
      <div class='btn-group'>
        <a class="btn" href="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>${content.uri.replace('html', 'pdf')}"><i class="fa fa-file-pdf-o"></i> Download as PDF</a>
      </div>
    </div>
    <% } %>
    <h2>${content.title}</h2>
  </div>
</div>
<div class="row">
  <div class="col-md-12 contributors">
    <ul>
      <% org.apache.tomee.website.Examples.load().each {example -> %>
      <li><a href="${example.url}">${example.name}</a></li>
      <% } %>
    </ul>
  </div>
</div>
</div>
<%include "footer.gsp"%>
