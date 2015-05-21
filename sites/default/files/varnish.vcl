backend default {
        .host = "localhost";
        .port = "8080";
}
sub vcl_fetch {
               	## Remove the X-Forwarded-For header if it exists.
        remove req.http.X-Forwarded-For;

                ## insert the client IP address as X-Forwarded-For. This is the normal IP address of the user.
        set    req.http.X-Forwarded-For = req.http.rlnclientipaddr;
                ## Added security, the "w00tw00t" attacks are pretty annoying so lets block it before it reaches our webserver
        if (req.url ~ "^/w00tw00t") {
                error 403 "Not permitted";
        }
if (req.http.X-Forwarded-Proto ~ "(?i)https") {
     return (deliver);
   }

                ## Deliver the content
        return(deliver);
}
## Deliver
sub vcl_deliver {
                ## We'll be hiding some headers added by Varnish. We want to make sure people are not seeing we're using Varnish.
              ## Since we're not caching (yet), why bother telling people we use it?
        remove resp.http.X-Varnish;
        remove resp.http.Via;
        remove resp.http.Age;

                ## We'd like to hide the X-Powered-By headers. Nobody has to know we can run PHP and have version xyz of it.
        remove resp.http.X-Powered-By;
}
