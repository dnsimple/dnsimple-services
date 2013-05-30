# Templates

Templates are each stored in their own directory. A template must have a config.json file and a logo.png file at minimum.

## Config

The config section contains meta-data about the template.

* name - The unique template name. All lower-case and only the characters a-z, 0-9 and the dash.
* label - The human-readable template name, used for display.
* description - An English description of the template, used for display.

## Template

The template object holds all of the configuration details for the template. At minimum it must include the records collection, however it may include the fields collection and a hook object as well.

### Fields

A list of variable names and descriptions. These will be presented to the user in the UI.

The variables are substituted into the content and name for each record when the template records are rendered into real records.

### Records

A list of record objects which will be processed to create the real records.

The name and content fields may use variables defined in the Attributes section. Values such as {{variable_name}} will be replaced when the template is applied.

Template records are rendered into the real records when the template is applied to a domain. All variables are replaced with attributes at this time.

In addition to custom attributes, there are also the following variables:

* domain - The domain name, such as example.com.

### Hook

Template hooks provide a way to invoke a URL when the template is applied. This can be used to execute custom behavior at services. One example is CloudFlare, where we use this service to provision the domain in the CloudFlare system.

A hook object has two parts:

* url
* data

The `url` attribute is a fully qualified URL that will be invoked in one of several ways:

* POST url on create
* PUT url on update
* DELETE url/{{domain}} on delete

Where {{domain}} will be replaced by the domain name to which the service is being applied.

The hook must return 200 to indicate that the operation completed successfully.
