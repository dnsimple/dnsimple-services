# Welcome

Welcome to the home of the [DNSimple](https://dnsimple.com) service templates. The one-click services in DNSimple are defined as JSON configurations and loaded into our system at deploy time. This means that you can contribute a new template by creating a pull request, simplifying the process of creating and updating templates. 

# Contributing

Read through the documentation below and look at the other templates in this repository before starting your own. If you have any questions feel free to get in touch with the DNSimple team using the support@dnsimple.com email address. Once you're ready to create your template, fork the project, add the template and issue a pull request.

# Tools

If you have ruby installed then you can use the following steps to get a few rake tasks to make creating new service configurations easier:

* `gem install bundler --no-ri --no-rdoc`
* `bundle install`

Once you've done that you have access to several tasks:

To generate a new service definition:

`rake generate[$name]` where $name is the short name of your service (for example: wordpress)

For example: `rake verify[my-service]`

To verify that a service definition meets our requirements for deployment:

`rake verify[$name]` where $name is the short name of your service

For example: `rake verify[blogger]`

# Service Definitions

Services are each stored in their own directory. A service definition must have a config.json file and a logo.png file at minimum. The logo.png must be 228 pixels wide by 78 pixels high.

Services may have a readme.md file and/or an instructions.md file as well.

## config.json

The JSON object defined in config.json holds all of the configuration details for the service. At minimum it must include the config section and the records collection with at least one record, however it may include the fields collection and a hook object as well.

### Config

The config section contains meta-data about the template. All of these attributes are required.

* name - The unique template name. All lower-case and only the characters a-z, 0-9 and the dash.
* label - The human-readable template name, used for display.
* description - An English description of the template, used for display.
* category - ["blogging" | "hosting" | "infrastructure" | "email" | "ecommerce" | "productivity" ]
* default-subdomain - Optional: If the service requires a subdomain and none is provided then use this.

#### Categories

You have to choose one and only one category for your service:

* blogging
* hosting (static pages, CMS)
* infrastructure (CDN, link shorteners)
* email
* e-commerce
* productivity (google-apps, office-365, marketing, support)

### Fields

A list of variable names and descriptions. These are presented to the user in the UI.

The variables are substituted into the content and name for each record when the template records are rendered into real records.

Each field may have the following attributes:

* name - When rendered the record subtitues values with the given name.
* label - Displayed to customers as the field label when the field is displayed.
* description - Displayed to customers as help text when the field is displayed.
* append - Text that is appended to the input field.
* example - Text that is subsitituted in samples that are displayed to customers.

### Records

A list of record objects which are rendered to create the real records.

Each record may have the following attributes:

* name - The host name (if omitted, it will be considered a blank string). Joined with the domain name to produce the fully-qualified record host name (optional subdomain + domain name) when rendered.
* type - The DNS type (such as "A", "CNAME", "MX", etc).
* content - The content of the record, such as an IP address or another host name. This depends on the record type.
* ttl - The time-to-live for the record.
* prio - The priority of the record. Used for MX and SRV records.

The name, type and content fields may use variables defined in the Attributes section as well as any values returned by the service hook.

Service records are rendered into the real records when the service is applied to a domain. All variables such as {{variable_name}} are replaced with attributes at this time. If a subdomain is provided then the record name is prepended to the subdomain which is joined with the domain name. For example, if the record name is "email", the subdomain is "staging", and the domain "example.com", the full record name will be "email.staging.example.com". If the record name is provided but the subdomain is omitted, then the full name would be "email.example.com". If the record name is omitted then it would be "staging.example.com". If the subdomain is omitted and the record name is omitted, then it would be "example.com".

In addition to custom attributes, there are also the following variables:

* domain - The domain name, such as example.com.
* subdomain - The subdomain name, such as www.

### Hook

Service hooks provide a way to invoke a URL when the service is applied. This can be used to execute custom behavior at services.

One example service that uses hooks is CloudFlare. The hook is used to provision the domain in the CloudFlare system.

The `url` attribute is a fully qualified URL that is invoked in one of several ways:

* POST url on create
* DELETE url on delete

The following parameters are always sent to the hook as an application/x-www-form-urlencoded body.

* domain_name: The domain name that the service is being applied to.
* subdomain: The subdomain that the service is being applied to. May be blank.
* user_id: The DNSimple user ID of the customer applying the service.

In addition to the parameters that are always sent, the values provided by the customer for any fields specified in the service definition are sent along as well.

For example, using the Heroku template, the body of a POST might look like the following:

    domain_name=example.com&user_id=123&app=myapp

The hook must return 200 to indicate that the operation completed successfully. Any status code other than 200 are considered an error.

The hook may return a JSON object that contains variables that is substitued in records within the service definition.

For example, the Cloudflare hook returns the following JSON:

    {
      "user_key": "some_user_key",
      "target_name": "abef4637291",
      "target_type": "CNAME"
    }

Any values returned from the hook are merged with the customer-provided values before being rendered into the services records.

## readme.md

All service definitions should include a readme.md file that explains what the service is for and whether there any specific details about the service that are important. The readme.md is a Markdown file.

## instructions.md

If a service requires additional set up you should include an instructions.md file. The file is a Markdown file and will be displayed on the service setup screen.
