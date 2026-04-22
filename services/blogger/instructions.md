To use a custom domain with Blogger:

1. In Blogger, open your blog settings and start the custom domain setup.
1. Enter the custom domain you want to use, such as `www.example.com`.
1. Blogger will show two CNAME records:
   - the blog CNAME, which points your chosen subdomain to `ghs.google.com`
   - a security CNAME with a Blogger-generated host and target
1. Add this service to the root domain in DNSimple and enter:
   - the blog subdomain, such as `www` or `blog`
   - the security CNAME name and target shown by Blogger
1. After the records have propagated, finish the custom domain setup in Blogger.

If you want `example.com` to redirect to your Blogger subdomain, use DNSimple's
redirect feature instead of adding Blogger apex A records.

If your domain uses CAA records, Blogger requires a CAA entry for
`letsencrypt.org` so certificates can be issued and renewed.

See the current Blogger documentation for details: https://support.google.com/blogger/answer/1233387?hl=en
