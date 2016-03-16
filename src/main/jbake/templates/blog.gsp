<%include "header.gsp"%>

	<%include "menu.gsp"%>

    <div class="container section-padded">
        <div class="row title">
            <h2>${content.title}</h2>
        </div>
        <div class="row">
            <div class="col-md-12">
                <%published_posts.each {post ->%>
                    <a href="<%if (content.rootpath) {%>${content.rootpath}<% } else { %><% }%>${post.uri}"><h1>${post.title}</h1></a>
                    <%if (post.date) {%><p><small>${post.date.format("dd MMMM yyyy")}</small></p><% } %>
                    <p>${post.body}</p>
                <%}%>
                <hr />

                <p>Older posts are available in the <a href="/${config.archive_file}">archive</a>.</p>
            </div>
        </div>
    </div>

<%include "footer.gsp"%>