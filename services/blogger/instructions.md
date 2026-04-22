1. In Blogger, open your blog settings and enter this domain name as the custom domain
1. Blogger will show two CNAME records that you must add below:
   - the blog CNAME, which points your chosen subdomain to `ghs.google.com`
   - a security CNAME with a Blogger-generated host and target

If your domain uses CAA records, Blogger requires a CAA entry for
`letsencrypt.org` so certificates can be issued and renewed.

See the current Blogger documentation for details: https://support.google.com/blogger/answer/1233387?hl=en
