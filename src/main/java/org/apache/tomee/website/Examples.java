package org.apache.tomee.website;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.johnzon.jaxrs.JohnzonProvider;
import org.apache.johnzon.mapper.JohnzonProperty;
import org.apache.johnzon.mapper.MapperBuilder;
import org.apache.johnzon.mapper.reflection.JohnzonParameterizedType;

import javax.ws.rs.ForbiddenException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import static java.util.Optional.ofNullable;
import static java.util.stream.Collectors.toList;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON_TYPE;
import static lombok.AccessLevel.PRIVATE;
import static org.apache.commons.codec.binary.Base64.decodeBase64;

@NoArgsConstructor(access = PRIVATE)
public class Examples {
    private static final String DEFAULT_README = "No README.md yet, be the first to contribute one!";

    // don't load it for each page, would be pretty inefficient
    private static final Collection<Example> CACHE = new ArrayList<>();
    private static final String CACHE_FILE = "examples.cache";

    public static void populateTree() {
        final String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        load().forEach(e -> {
            try (final Writer w = new FileWriter("src/main/jbake/content/examples/" + e.getName() + ".adoc")) {
                w.write("= " + findTitle(e.getName(), e.getReadme()) + "\n" +
                        ":jbake-date: " + date + "\n" +
                        ":jbake-type: page\n" +
                        ":jbake-tomeepdf:\n" +
                        ":jbake-status: published\n\n" +
                        "Example " + e.getName() + " can be browsed at " + e.getUrl() + "\n\n" +
                        mdToAdoc(e.getReadme()));
            } catch (final IOException ioe) {
                throw new IllegalStateException(ioe);
            }
        });
    }

    public static Collection<Example> load() {
        if (!CACHE.isEmpty()) {
            return CACHE;
        }

        final File cache = new File(CACHE_FILE);
        if (cache.isFile()) {
            System.out.println("Reading examples from cache, delete " + CACHE_FILE + " if you want to reload them");
            try (final InputStream is = new FileInputStream(cache)) {
                CACHE.addAll(new MapperBuilder().build().readCollection(is, new JohnzonParameterizedType(List.class, Example.class)));
            } catch (IOException e) {
                throw new IllegalArgumentException(e);
            }
            return CACHE;
        }

        final Client client = ClientBuilder.newClient().register(new JohnzonProvider<>());
        try {
            final WebTarget github = client.target("https://api.github.com");
            final Invocation.Builder request = github.path("repos/apache/tomee/contents/examples").request(APPLICATION_JSON_TYPE);
            final String auth = System.getProperty("github.auth");
            if (auth != null) {
                request.header("Authorization", auth);
            }
            CACHE.addAll(request
                    .get(new GenericType<Collection<GithubContentItem>>() {
                    }).stream().filter(i -> "dir".equals(i.getType()))
                    .parallel()
                    .sorted((i1, i2) -> i1.getName().compareTo(i2.getName()))
                    .map(i -> new Example(i.getName(), i.getHtmlUrl(), loadReadme(auth, github, i)))
                    .collect(toList()));

            // debug stats
            final int totalExamples = CACHE.size();
            final long exampleMissingReadme = CACHE.stream().filter(e -> DEFAULT_README.equals(e.getReadme())).count();
            System.out.println(exampleMissingReadme + "/" + totalExamples + " miss a README.md");
            CACHE.stream().filter(e -> DEFAULT_README.equals(e.getReadme())).forEach(e -> System.out.println("  - " + e.getName()));

            try (final OutputStream os = new FileOutputStream(CACHE_FILE)) {
                new MapperBuilder().build().writeArray(load(), os);
            } catch (final IOException e) {
                throw new IllegalArgumentException(e);
            }
        } finally {
            client.close();
        }
        return CACHE;
    }

    private static String loadReadme(final String auth, final WebTarget github, final GithubContentItem i) {
        try {
            final Invocation.Builder request = github.path("repos/apache/tomee/contents/examples/{name}/README.md")
                    .resolveTemplate("name", i.getName()).request(APPLICATION_JSON_TYPE);
            if (auth != null) {
                request.header("Authorization", auth);
            }
            return ofNullable(request
                    .get(GithubContentItem.class)
                    .getContent())
                    .map(c -> new String(decodeBase64(c), StandardCharsets.UTF_8))
                    .orElse(DEFAULT_README);
        } catch (final NotFoundException wae) {
            System.err.println(wae.getMessage() + " for the README.md of " + i.getName());
            return DEFAULT_README;
        } catch (final ForbiddenException wae) {
            System.err.println("Can't retrieve examples, set -Dgithub.auth=.... to get a higher rate limit");
            return DEFAULT_README;
        }
    }

    private static String findTitle(final String name, final String readme) {
        try (final BufferedReader reader = new BufferedReader(new StringReader(readme))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("Title: ")) {
                    return line.substring("Title: ".length());
                }
            }
        } catch (final IOException e) {
            throw new IllegalStateException(e);
        }
        return name;
    }

    // quick cleanup of markdown syntax to adoc one used there
    private static String mdToAdoc(final String s) {
        try (final StringWriter writer = new StringWriter();
             final BufferedReader reader = new BufferedReader(new StringReader(s))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("Title: ")) {
                    continue;
                }
                if (line.startsWith("#")) {
                    for (int i = 0; i < line.length(); i++) {
                        if (line.charAt(i) == '#') {
                            writer.append('=');
                        } else {
                            writer.append(" ").append(line.substring(i));
                            break;
                        }
                    }
                } else if (line.startsWith("    package") || line.startsWith("    import") || line.startsWith("    public ") || line.startsWith("    @")) { // java code
                    writer.append("\n[source,java]\n----\n");
                    writer.append(line.replaceFirst("    ", "")).append('\n');
                    while ((line = reader.readLine()) != null) {
                        writer.append(line.replaceFirst("    ", "")).append('\n');
                        if ("    }".equals(line)) {
                            writer.append("----\n");
                            break;
                        }
                    }
                } else if (line.startsWith("    -------------------------------------------------------")) { // run output
                    writer.append("\n[source]\n----\n");
                    writer.append(line.replaceFirst("    ", "")).append('\n');
                    while ((line = reader.readLine()) != null) {
                        writer.append(line.replaceFirst("    ", "")).append('\n');
                        if (line.startsWith("    Tests run:") && !line.contains("Time elapsed:")) {
                            writer.append("----\n");
                            break;
                        }
                    }
                } else if (line.startsWith(">")) {
                    writer.append("\nNOTE: ").append(line.substring(1)).append("\n");
                } else {
                    writer.append(line);
                }
                writer.append('\n');
            }
            return writer.toString();
        } catch (final IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public static void main(final String[] args) {
        populateTree();
    }

    @Data
    public static class Example {
        private final String name;
        private final String url;
        private final String readme;
    }

    @Data
    public static class GithubContentItem {
        private String name;
        private String path;
        private String type;
        private String content;

        @JohnzonProperty("html_url")
        private String htmlUrl;
    }
}