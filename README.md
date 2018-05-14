# full-sitemap

**The goal of this module is to provide a sitemap.xml of a full site using a XML view of all the visible content (not only the jnt:page)**

Typically, when the module is enabled on the acme site, calling this URL will provide a full xml sitemap
https://host.domain/cms/render/live/en/sites/acme/home.full-sitemap.xml

In production, the idea is to generate a static sitemap.xml using linux cron. Here is an example:

    0 4 * * * /usr/bin/wget https://host.domain/cms/render/live/en/sites/acme/home.full-sitemap.xml -O /var/www/vhosts/host.domain/html/sitemap.xml

Then the sitemap.xml file will be available as a static if the parent directory is accessible. For people using apache ProxyPass, then you need to set the /var/www/vhosts/host.domain/html into your root folder add such line into your VirtualHost config

    ProxyPass /sitemap.xml !

Of course you need ajust the URL, the path and the host name, and you can also set the language for i18n sites.

----------

This module can work with https://github.com/jahia/sitemap and will use the changefreq and priority properties if set.
