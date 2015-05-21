backend default {
        .host = "localhost";
        .port = "8080";
}

if (req.http.X-Forwarded-Proto ~ "(?i)https") {
     return (pass);
   }
