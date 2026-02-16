# Single Directory Components (SDC) in Drupal

This document provides comprehensive information on creating and using Single Directory Components (SDC) in Drupal. SDC is Drupal's implementation of components, where all files necessary to render a component (Twig, YAML, CSS, JS) are grouped in a single directory.

## About Single Directory Components

### What is a component in general?

In web development, a component is a part of a web page or application that is modular and reusable, with a specific functionality or purpose. It's like a building block that can be used to create more complex interfaces.

Components are made up of HTML, CSS, and JavaScript code, and can be easily customized and reused across multiple pages or applications. Examples of components include navigation menus, forms, sliders, and buttons.

### What is a single-directory component?

Single-Directory Components (often abbreviated as SDC) are Drupal core’s implementation of components. Within SDC, all files necessary to render the component are grouped together in a single directory (hence the name). This includes Twig, YAML, and optional CSS, JavaScript, etc. SDC will automatically generate a library to load CSS/JS when the template is invoked.

### What are the benefits of using Single-Directory Components?

There are many benefits of using single-directory components.

- **Organization:** Grouping all necessary code into one directory makes finding and jumping between relevant files easier.
- **Automatic library creation**: SDC will automatically look for a `my-component.css` and `my-component.js` and add to an automatically generated library if found. You can specify additional assets and dependencies within the component’s YML file if necessary.
- **Reusability**: Components are designed to be modular and reusable, which means that they can be easily integrated into multiple pages or applications.
- **Consistency**: By using components, developers can ensure that their web pages or applications have a consistent look and feel throughout.
- **Scalability**: Components can help make web pages or applications more scalable, as they can be easily added or removed as needed.
- **Testing**: Components can often be tested in isolation, which can make it easier to identify and fix bugs or issues.
- **Collaboration**: Using components can make it easier for teams of developers to work together, as they can share and reuse components across different projects.

### Future benefits

Because SDC allows you to define schemas within the YML definition file, contributed modules (and eventually Drupal core) can automatically generate forms to populate the data. This means that in the future, we’ll be able to add components directly from systems like Layout Builder, CKEditor, etc. without having to make custom entities!

### Manual enablement needed in 10.2.x or earlier

Starting with Drupal 10.3, Single-Directory Components became part of Drupal Core's render system. If you're using Drupal 10.2 or earlier, you must enable the module in Core manually to use this feature.

## Quickstart

In web development, a component is a part of a web page or application that is modular and reusable, with a specific functionality or purpose. It's like a building block that can be used to create more complex interfaces. Drupal's Single-Directory Components consist of metadata that describe the component, HTML markup, and, optionally, CSS and JavaScript, which are all located in the same directory. Hence, the name, Single-Directory Components.

To demonstrate how Single-Directory Components work, we're going to walk through creating an example 'chip' component and use it in a theme.

### Prerequisites to working with components

- You must be using **Drupal 10.1 or greater**
  - If using a version prior to **Drupal 10.3**, you must have the *Single-Directory Components* module enabled (at *admin/modules*)
- You must have a theme (or module) that you want to add components to. The theme must be installed (at *admin/appearance*)
- You must know where in the filesystem the theme's code is located. (We'll be using a custom theme, located in the custom directory at *themes/custom/MY-THEME* in this example. Learn more about generating a custom theme with the Starterkit theme script.)

### Define a component

Every component requires a single directory for its assets to reside in. This directory must exist in a *components/* subdirectory of your theme (so that Drupal can find it). A *{NAME}.component.yml* file with metadata about the component is required.

Pick a name for your component. We'll use "chip" for our example. It should be unique within the theme. Components are namespaced, so multiple different themes could declare a "chip" component.

Create the directory *themes/custom/MY-THEME/**components/chip/***. Then, in that directory, create a file starting with your component name, followed by *.component.yml*. For example, *chip.component.yml*.

Populate the *chip.component.yml* file with metadata that describes the component:

```yaml
name: Chip
props:
  type: object
  required:
    - color
  properties:
    # Can the chip be dismissed by clicking on it?
    dismissable:
      type: boolean
      title: Dismissable
      description: If true users can dismiss the chip by clicking on it.
    # One of 'primary', or 'secondary'.
    color:
      type: string
      title: Color
      description: "Background color to use for the chip, one of 'primary' or 'secondary'."
      # The enum directive restricts the possible values in the element to our list.
      enum: ['primary', 'secondary']
slots:
  # Content to display in the chip.
  content:
    title: Content
    description: Content of the chip
```

The data in this file describes your component to Drupal and to anyone who wants to make use of it. This one includes a human-readable `name` for the component. Definitions of the component’s inputs in the form of **props** (for data whose type and structure is well defined) and **slots** (for data with an unknown structure, like nested components). These act as an API or contract for the component, and is like saying, "We promise to always accept and use these inputs."

Props, and slots, are declared using [JSON Schema](https://json-schema.org/) syntax, and null, boolean, object, array, number, and string are valid types. The top level *props* key is always an object that contains the *properties* which are mapped to variables in the component's template file.

### Add some markup

A component that doesn't output anything isn't that useful. So let’s add some markup via a Twig file. Within the component’s directory, create a *.twig* file using the name of your component.

For example, in *components/chip/chip.twig*, add the following:

```twig
{%
  set classes = [
  'chip',
  'chip--color-' ~ color|clean_class,
  dismissable ? 'chip--dismissable',
]
%}
<div{{ attributes.addClass(classes) }}>
   {{ content }}
</div>
```

The above code contains some HTML markup and Twig expressions that make use of component inputs in order to output dynamic content.

The Twig variables available to the template, which in the above example are `color`, `dismissable`, and `content`, are the keys of the `props.properties` and `slots` arrays defined in the `[COMPONENT].component.yml` file. The `attributes` variable that is automatically added to all component templates is also available.

*Note:* There is an alternative syntax for printing slots using Twig `block` tag. See Learn more about using your components in render element and template files for more information.

### Add some style

Let's add some CSS and make that chip look a little more attractive. This requires creating a CSS file with the name of your component in the component directory, and well, ...that's it!

Create the file, *themes/custom/MY-THEME/components/chip/chip.css*, with the following contents:

```css
.chip {
  display: inline-block;
  padding: 0.25rem;
}

.chip--color-primary {
  background-color: darkblue;
  color: white;
}

.chip--color-secondary {
  background-color: lightgray;
  color: black;
}

.chip--dismissed {
  display: none;
}
```

If the component’s *{NAME}.css* file exists, Drupal will automatically find it, and include it on the page. In the case of our chip component, since the *chip.css* file exists, Drupal will use it whenever the chip component is used in a template file.

### Finally, add some interaction with JavaScript

Adding some JavaScript to our component isn't any harder. Let's add some JavaScript that will make it so the chip can be dismissed (hidden) when a user clicks on it. This requires creating a *{NAME}.js* file with the component name in the component’s directory.

Create the file, *themes/custom/MY-THEME/components/chip/chip.js*, with the following JavaScript code:

```js
((Drupal) => {
  Drupal.behaviors.chip = {
    attach(context) {
      context.querySelectorAll('.chip--dismissable').forEach((chip) => {
        chip.addEventListener('click', () => {
          chip.classList.toggle('chip--dismissed');
        })
      });
    },
  };
})(Drupal);
```

Refresh the page and Drupal should automatically locate this new JavaScript file and include it whenever the chip component is used. You can test that it's working by setting the `dismissable` prop of your component to `true`, and then clicking on the chip element. (It should disappear.) Now set it to `false`, and clicking should have no impact.

Note: this ties together code in CSS where we have classes to show/hide the chip and the Twig file where we dynamically decide whether or not to add the `.chip--dismissable` class depending on the `dismissable` prop's value.

### Take it further

Components can do a lot more. Now that you understand this brief example, check out the complete annotated example to learn more. Here are a few things to experiment with:

- You can include other assets in the directory, too, like images, but they won't be automatically loaded. You'll need to reference them via your Twig, CSS, or JavaScript files. Can you add an icon to your chip component?
- Use the `libraryOverrides` in your *{NAME}.component.yml* file to require additional JavaScript libraries like *drupal/once* or jQuery. Can you rewrite the JavaScript so that it uses the *drupal/once* library?

### Use your component

In order to use the markup generated by your component, you'll need to "use" it into:

- a render element on PHP code
- a Twig template file in your theme.

With the rise of design system methodology and display building tools, render elements are the way to go, but in the context of this tutorial, let's try to use ours in the node template file to display the node type (bundle) as a chip.

Edit the *themes/custom/MY-THEME/templates/content/node.html.twig* template file and add the following (where you want the chip to display):

```twig
{% set chip_content %}
Type: <span>{{ node.bundle() }}</span>
{% endset %}

{{ include('MY-THEME:chip', {
  color: 'primary',
  dismissable: true,
  content: chip_content,
}, with_context = false) }}
```

This Twig uses the standard Twig `include` function to include the chip component (with a twist: the namespacing of the component `MY-THEME:chip` resolves to the 'chip' component in the *MY-THEME* theme) and pass the expected values:

- `color` and `dismissable` are props defined the component’s definition file ({`NAME}.component.yml`).
- `content` is a slot, also defined in the component’s definition file

Clear the cache and view a node on your site. You should see the node type output as a `chip` on the page where you included the component in the node template file.

## Creating a Single-Directory Component

### A single-directory component meets the following criteria

1. It **must** be within your theme or module’s `components/` directory. Note that it can be nested within subdirectories (for example `components/atoms/`, `components/molecules/`, etc)
2. It **must** contain the following files (where `my-component` is the name of your component)
   1. `my-component.component.yml` - this contains the definition of the component including name, status, schema, etc
   2. `my-component.twig` - this is the normal Twig file that contains markup as well as logic such as conditionals and loops to interact with the variables defined within the YML. (Note that the filename extension should be `.twig` and not `.html.twig`, as regularly seen in other theme template files.)
3. It *may* contain other files such as CSS, JavaScript, source files (Sass, etc), images, documentation, etc

### Note about creating the schema

Creating a schema within your `my-component.component.yml` is mandatory for modules, but optional for themes. However it’s highly recommended to do so. Benefits include:

- Only components that have schemas can override other components.
- Using schemas will illuminate problems with your components earlier.
- Schemas will enable contributed modules (and maybe eventually core) to automatically generate forms to populate the component.

Note you can force all components within your theme to require schemas by adding the following to your `themename.info.yml`.

```yaml
enforce_prop_schemas: true
```

### To create your first single-directory component, follow these steps

1. Create a new directory called `components/` in your theme or module’s directory.
2. Create a new directory within your theme’s `components/` directory with the name of your new component (ex `my-component`) .
3. Create two new files within this directory
   1. A twig file with the name of your component (ex `my-component.twig`)
   2. A YAML file with the `*.component.yml` extension that is named with your component (ex `my-component.component.yml`). View (or copy and paste) the example annotated YAML file to get started.
4. For the CSS and JavaScript to automatically load, they must be named after the component (ex. `my-component.css`, and `my-component.js`).
5. You can load additional styles, scripts, and dependencies using the `libraryOverrides` key within your component’s YML file if necessary.

The final directory structure will look something like this

```
|- my-theme
    |- components
        |- my-component
            |- my-component.twig (required)
            |- my-component.component.yml (required)
            |- README.md
            |- thumbnail.png
            |- my-component.js
            |- my-component.css
            |- assets
                |- img1.png
```

### Props typing

Props typing is using JSON schema with 7 primitive types:

| PHP          | JSON schema | Twig   |
|--------------|-------------|--------|
| string or Stringable object | string | string |
| float        | number      | number |
| integer      | integer     | number |
| true or false| boolean     | boolean|
| null         | null        | null   |
| (associative) array | object | mapping |
| array (list) | array       | sequence |

### Component data validation

During development time the data provided to the props can be validated against the schema. This will give developers an early warning that something is off.

For schema to be validated, two conditions must be met:

1. The `justinrainbow/json-schema` composer package must be installed. This can easily be installed via `drupal/core-dev`:

   ```bash
   composer require drupal/core-dev --dev
   ```

2. Assertions must be enabled. If assertions are disabled within your local environment, you can add the following to your `settings.php` to enable them:

   ```php
   ini_set('zend.assertions', 1);
   ```

Writing the schema for your components is mandatory if the component lives in a module or a theme that contains `enforce_prop_schemas: true` in its info file.

Note that `enforce_prop_schemas: false` only applies to the absence of a schema definition for the entire component. Even with this setting present, each individual element of the schema will be validated individually.

### Overriding components provided by other modules or themes

Only themes can override components (modules cannot override). For a theme to override a component, use the `replaces` key within the `mytheme.component.yml` file.

In addition, both components must have schemas defined within their YML files, and the schemas’ props and slots must match.

The value of the `replaces` key must refer to the other component using the machine name of the module/theme and the machine name of the component, delimited with a colon (`:`). In the example below, `sdc_theme_test` is the name of the theme that contains the component to be replaced, and `my-card` is the machine name of that component.

```yaml
replaces: 'sdc_theme_test:my-card'
```

### Manual enablement needed in 10.2.x or earlier

Starting with Drupal 10.3, Single-Directory Components became part of Drupal Core's render system. If you're using Drupal 10.2 or earlier, you must enable the module in Core manually to use this feature.

## Using Your New Single-Directory Component

### Figure out the component ID

To use a component you'll need to know the component ID. This is the machine name of the module or theme that provides the component, plus the name of the component itself, separated by a colon. Examples:

- `{module}:{component}.` Example: `sdc_examples:button` where *sdc_examples* is the module name, and *button* is the component name.
- `{theme}:{component}.` Example: `olivero:chip` where *olivero* is the theme name, and *chip* is the component name

Once you know the component ID there are two ways you can make use of it.

### Using your component through a render array

SDC comes with its own render element in order to be usable from PHP code. This is the preferred way if you want to keep your theme shareable and agnostic and make Drupal aware of your component usage.

Model:

**Render property** | **PHP type** | **Description**
---|---|---
#component | String | Mandatory. Full component ID: `{provider}:{component_id}`
#variants (since Drupal 11.2+, not supported before) | String | Optional. Name of the variant to use.
#slots | Array | Optional. Associative array, keyed by slot ID. Each value is a Drupal renderable.
#props | Array | Optional. Associative array, keyed by prop ID. Each value must be valid according to the prop JSON schema.

Notes:

- `#attributes` is not available yet. Core issue: [#3515506: Process #attributes render property for SDCs](https://www.drupal.org/project/drupal/issues/3515506 "Status: Closed (fixed)")
- "Universal" `#cache` and `#attached` render properties are available.

Most of the time, you will use this render element as the return value of configurable plugins related to display building:

- [BlockPluginInterface::build()](https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Block%21BlockPluginInterface.php/function/BlockPluginInterface%3A%3Abuild/11.x)
- [FormatterInterface::viewElements()](https://api.drupal.org/api/drupal/core%21modules%21views%21src%21Plugin%21views%21style%21StylePluginBase.php/function/StylePluginBase%3A%3Arender/8.9.x)
- [LayoutInterface::build()](https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Layout%21LayoutInterface.php/function/LayoutInterface%3A%3Abuild/11.x)
- [StylePluginBase::render()](https://api.drupal.org/api/drupal/core!modules!views!src!Plugin!views!style!StylePluginBase.php/function/StylePluginBase%3A%3Arender/11)
- ...

Example:

```php
<?php
return [
  '#type' => 'component',
  '#component' => 'sdc_examples:my-cta',
  '#props' => [
    'label' => t('Click Me'),
  ],
  '#slots' => [
    'body' => [
      '#type' => 'html_tag',
      '#tag' => 'span',
      '#value' => t('I am a render array in a slot.'),
    ]
  ],
];
```

### Using your component in Twig template

#### Twig functions

When using a render element is not possible, you can use your component in an `*.html.twig` template use Twig’s built in [`include`](http://twig.symfony.com/doc/3.x/functions/include.html) or [`embed`](http://twig.symfony.com/doc/3.x/tags/embed.html) functions, according to the way you are printing slots in your template:

Slot in the component template | When called from another template
---|---
`{{ label }}` | `{{ include('provider:my_component', {label: label}, with_context = false) }}`
`{% block label %}{% endblock %}` | `{% embed 'provider:my_component' only %} {% block label %}{{ label }}{% endblock %} {% endembed %}`
`{% block label %}{{ label }}{% endblock %}` | Compatible with both `include` and `embed`

##### Use `include()`:

Use the Twig `include()` function if there is no data being sent to slots or if you are printing your slots as Twig variables in the component template.

Example of how to include the `sdc_examples:my-button` component from a Drupal Twig template:

```twig
{{ include('sdc_examples:my-button', { text: 'Click Me', iconType: 'external' }, with_context = false) }}
```

You’ll need to provide the component ID (`[module/theme name]:[component]`) of the component.

`with_context = false` parameter is optional but recommended to avoid unexpected side-effects.

[Read more about `include()` in the Twig documentation.](http://twig.symfony.com/doc/3.x/functions/include.html)

#### Use `{% embed %}`:

Use a Twig `{% embed %}` tag only if you are using Twig blocks to manage your slots in the component template.

Example of how to pass in a slot (Twig block) in a card component:

```twig
{% embed 'sdc_examples:my-card' with { header: label } only %}
  {% block card_body %}
    {{ content.field_media_image }}
    {{ content|without('field_media_image') }}
    {{ include('sdc_examples:my-button', { text: 'Like', iconType: 'like' }, with_context = false) }}
  {% endblock %}
{% endembed %}
```

`only` keyword is optional but recommended to avoid unexpected side-effects.

[Read more about `embed` in the Twig documentation.](http://twig.symfony.com/doc/3.x/tags/embed.html)

#### About `{% include %}` tag

This tag is not recommended according to Twig documentation:

> It is recommended to use the include function instead as it provides the same features with a bit more flexibility:
>
> - The include function is semantically more "correct" (including a template outputs its rendered contents in the current scope; a tag should not display anything)
> - The include function is more "composable"
> - The include function does not impose any specific order for arguments thanks to named arguments.

Source: [https://twig.symfony.com/doc/3.x/tags/include.html](https://twig.symfony.com/doc/3.x/tags/include.html)

### Slots & props data in a Drupal template

Some templates are providing distinct variables for data expected in slots and props:

In `node.html.twig`:

- `content` variable has the data to send to slots
- `node` variable has the data to send to props

In `user.html.twig`:

- `content` variable has the data to send to slots
- `user` variable has the data to send to props

And so on.

Example with icons from the Core's Icon API, which can be send to both slots and props.

**In component definition**

**In the presenter template**

**In the component template**

`slots:   icon:   title: Icon`

`{{ include('my_theme:button', {   label: node.title,   icon: content.field_icon   }, with_context = false) }}`

`{{ icon }}`

`props:   type: object   properties:   icon:   title: Icon   type: object   properties:   pack_id:   type: string   icon_id:   type: string   settings:   type: object   required:   - pack_id   - icon_id`

`{{ include('my_theme:button', {   label: node.title,   icon: node.field_icon   }, with_context = false) }}`

`{{ icon(icon.pack_id, icon.icon_id, icon.settings) }}`

### Manual enablement needed in 10.2.x or earlier

Starting with Drupal 10.3, Single-Directory Components became part of Drupal Core's render system. If you're using Drupal 10.2 or earlier, you must enable the module in Core manually to use this feature.

## Annotated Example Component.yml

A YML metadata file is required in each single-directory component. Below is a sample `component.component.yml` file that identifies and explains each option.

### Full example

```yaml
# Everything in this file is optional. Still, the file needs to exist.
# Adding metadata here will improve the DX when using components.

# Note: currently in Drupal 10.1, the schema will fail to validate if
# props section is not present. This may change in a future release.

# This is so your IDE knows about the syntax for fixes and autocomplete.
$schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json

# The human readable name.
name: Tabs

# The human readable component description.
description: Horizontal or vertical tabs.

# Status can be: "experimental", "stable", "deprecated", "obsolete".
status: experimental

# Use this key to organize components together.
group: Navigation

# Override components provided by other themes or modules. The format
# is <module-or-theme-machineName>:<component-machineName>. Note that
# only themes can override components. This will not work in modules.
replaces: 'sdc_module_test:my-component'

# Schema for the props. We support JSON Schema. Learn more about the
# syntax at https://json-schema.org
# The props section is currently required. See Components without
# Properties section below.
props:
  # Props are always an object with keys. Each key is a variable in your
  # component template.
  type: object

  # If your component has required properties, you list them here.
  required:
    - primary

  properties:
    # The key is the name of the variable in the template.
    primary:
      # You can add a human-readable name to your props.
      title: Primary
      # This variable is an array of strings: ['foo', 'bar', 'baz'].
      # This information is required for every prop.
      type: array
      items:
        type: string
    secondary:
      type: array
      title: Secondary
      description: You can describe your props
      items:
        type: string
    tertiary:
      type: string
      title: Tertiary
      # Limit the available options by using enums.
      enum:
        - success
        - warning
        - danger
      # Provide a default value. It isn't used in Twig template.
      default: success
    quaternary:
      type: ['string', 'null']
      title: Quaternary
      # Allow string or null.
      enum:
        - 'One'
        - 'Two'
        - 'Three'
        - null

# Slots always hold arbitrary markup. We know that beforehand, so no need
# for a schema for slots.
slots:
  # The key is the name of the slot. In your template you will use
  # {% block body %}.
  body:
    # A human-readable name.
    title: Body
    # A description.
    description: This is the body

  # Only the key is required when declaring slots. This is how you
  # declare a slot with minimal typing.
  minimal: {}

# This is how you take control of the keys in your library
# declaration. The overrides specified here will be merged (shallow merge)
# with the auto-generated library. The result of the merge will become the
# library for the component.
libraryOverrides:
  # Once you add a key in the overrides, you take control of it. What you
  # type here is what will end up in the library component.
  dependencies:
    - core/drupal
    - core/once

  # Here we are taking control of the JS assets. So we need to specify
  # everything, even the parts that were auto-generated. This is useful
  # when adding additional files or tweaking the <script>
  # tag's attributes.
  js:
    my-component.js: { attributes: { defer: true } }
    my-other-file.js: {}
```

### Minimal example

```yaml
# You can leave it empty.
# If you have a YAML linter (like core's) that won't allow empty YAML
# files, use: null
```

### Components without props, with a schema

```yaml
# Everything from the Full example applies here. We are focusing on the
# props for this example.

# Even when we have no props, we need to add a schema of an empty object
# for them.
props:
  type: object
  additionalProperties: false
  properties: {}
```

### Add a remote schema on IDE

When editing or viewing an sdc `*.component.yml` file most modern IDEs will understand the top key `$schema` value and will use it to validate or suggest key - value pairs for the `*.component.yml`.

If your IDE does not understand by default the remote schema you can add it manually.

- **PHPStorm**: https://www.jetbrains.com/help/phpstorm/yaml.html#remote_json
- **VSCode**: https://code.visualstudio.com/Docs/languages/json#_json-schemas-and-settings

## API for Single-Directory Components

The API of Single-Directory Components includes:

1. The component plugin manager: the `plugin.manager.sdc` service is implemented in `Drupal\Core\Theme\ComponentPluginManager` by default. This service is needed by modules that need to find and instantiate components.
2. Various component-related exceptions listed in `core/lib/Drupal/Core/Render/Component/Exception`. Code using Single-Directory Components can rely and extend these exceptions.
3. The folder structure of a component and the naming conventions of the files in it.
4. The structure of the component metadata (the `my-component.component.yml`). Note that the metadata of the component is described, and optionally validated, by the schema in `metadata.schema.json` (this file is for internal validation and not part of the API).
5. The render element and its class `\Drupal\Core\Render\Element\ComponentElement.`
6. The naming convention for the ID when using Twig's [`include`](https://twig.symfony.com/doc/3.x/functions/include.html) and [`embed`](https://twig.symfony.com/doc/3.x/tags/embed.html) fucntions. This naming convention is `[module-or-theme-machine-name]:[component-machine-name]`. See the example below.

```twig
{{ include('sdc_examples:my-button', { text: 'Click Me', iconType: 'external' }, with_context = false) }}
```

This way of specifying the component for Twig's [`include`](https://twig.symfony.com/doc/3.x/functions/include.html) and [`embed`](https://twig.symfony.com/doc/3.x/tags/embed.html) function (`'my-theme:my-component'` in the example) will not change, as it is considered an API.

### Manual enablement needed in 10.2.x or earlier

Starting with Drupal 10.3, Single-Directory Components became part of Drupal Core's render system. If you're using Drupal 10.2 or earlier, you must enable the module in Core manually to use this feature.

## What are Props and Slots in Drupal SDC Theming?

Managing multiple versions of the same component leads to duplicated code and extra maintenance. Each variation often means another file to update when changes are needed.

SDC address this by separating component structure from the data it receives. Rather than duplicating components, you reuse one flexible component and customise it through *props* and *slots*.

Benefits:

- Fewer components to manage
- Centralised updates to structure
- Dynamic rendering based on passed data

Using *props* for structured values and *slots* for nested content, SDC enables clean, scalable, and reusable components.

The concept of "props" (or “properties”) and "slots" are shared with other component technologies:

| Drupal SDC | Drupal Layout API | Drupal Render API | Vuejs | WebComponent | ReactJS | Symfony Twig Component |
|------------|-------------------|-------------------|-------|--------------|---------|-------------------------|
| Slot | Region | Child | [Slot](https://vuejs.org/guide/components/slots) | Slot | Children | Block |
| Prop | Setting | Property | Prop | Attribute | Prop | Prop |

### Slots are "areas" for free renderables only, like other components.

Slots are used for unstructured data, such as:

- Drupal Render Arrays
- PHP objects implementing RenderableInterface, MarkupInterface, Stringable...
- Nested components
- Twig blocks
- HTML markup

By design, we are not able to know their type/structure in advance. So, we have no need to defined them with JSON schema and check their data.

They are not used for complicated UI logic in the template. We only know if they are empty or not, or multiple or not.

### Props are strictly typed data only, for some UI logic in the template.

Props have a defined structure for the data that will be passed to the component using the Javascript Object Notation (JSON) format of key:value pairs.

By default any configuration in the YAML file is not enforced and can simply be ignored by the Twig file, but with component data validation enabled (on a development server), the configuration of the JSON schema specified in the YAML file is enforced.

So then the YAML file could define for example that a certain key is required, that its range of allowed values is limited to x, y and z (using enums), or that its type is “array”, and a key or value that did not comply with the JSON schema constraints defined in the YAML file would throw an error when the page is loaded.

### Examples

#### Bootstrap's Alert component

2 slots & 2 props:

```yaml
name: Alert
slots:
  heading:
    title: Heading
  message:
    title: Message
props:
  type: object
  properties:
    dismissible:
      title: "Dismissible?"
      type: boolean
    heading_level:
      title: "Heading level"
      type: integer
      enum: [2, 3, 4, 5, 6]
```

No logic is applied on slots except checking if they are empty are not:

```twig
<div{{ attributes.addClass('alert').setAttribute('role', 'alert') }}>
  {% if heading %}
    {% set heading_level = heading_level|default(4) %}
    <h{{ heading_level }} class="alert-heading">{{ heading }}</h{{ heading_level }}>
  {% endif %}
  {{ message }}
  {% if dismissible %}
    {{ include('ui_suite_bootstrap:close_button', {
      attributes: {
        'data-bs-dismiss': 'alert',
      },
      aria_label: 'Close'|t,
    }, with_context = false) }}
  {% endif %}
</div>
```

## Modules and Tools that Extend Single-Directory Components

Below is a list of modules that extend or build upon the functionality of Single-Directory Components.

### Drupal 11.x

Use SDC components directly in Drupal admin UI:

- **SDC Display** - Allows site builders to leverage the components available in the site inside the Manage Display tabs of your entities. With SDC Display you will be able to configure what component an individual field uses, or what component a given view mode uses.
- **UI Patterns** (version >=2.0) - Automatically integrates components into Drupal within Manage Display, Layout Builder, Views, Block Layout...

Other tools:

- **SDC Devel** - Provides development aids to Single-Directory Components developers. Debugging helper and Component validator for best practices.
- **CL Devel** (version >=2.0) - Provides audit pages to view all components and identify any problems.
- **CL Editorial** (version >=2.0) - A helper module (for other modules) that standardizes (and can filter) the UI for when a user is selecting a SDC.
- **Drupal Atomic Builder (DAB)** - The Drupal Atomic Builder (DAB) module is designed for front-end developers, offering functionalities for both visualizing and creating components through the Single-Directory Component (SDC). It integrates smoothly with Drupal's admin interface for ease of use. The module allows developers to code their components without having to create full content.
- **SDC Styleguide** - The goal of this module is to provide a quick interface to test single-directory components (akin to Patternlab) without having to actually create content on the site. Automatically loads all SDC available on your site. Dynamically creates a form to input test data and render the component and allows you to predefined demos to test them

### Drupal 10.3, need patch for Drupal 11.x

- **SDC Block** - This module will auto-generate blocks out of a curated selection of components. Blocks are configurable based on the props schema and the declared slots for the component.

### Tools

- **Storybook SDC Addon** - This addon streamlines the integration of Drupal Single Directory Components (SDC) into Storybook, allowing YAML-configured components (e.g., `*.component.yml`) to be dynamically loaded as stories in Storybook.

### Deprecated, obsolete or not maintained

- **CL Generator** (version >=2.0) - This provides a Drush command to generate your component. Note: If you are using Drush 12 or later, the module is not needed - you can run the `drush generate sdc` command directly
- **CL Server** (version >=2.0) - Provides integration with Storybook (component library).
- **SDC Story Generator** - Provides a Drush command to generate Storybook `mycomponent.stories.yml` files from `mycomponent.component.yml` definitions. The `*.stories.yml` files can be consumed by Storybook to auto-generate documentation and editable live previews using CL Server.

## Frequently Asked Questions

### How is SDC different from Twig-based theming?

SDC can help with building a common design system with independent or combined UI elements following atomic design principles. These elements can then be used/reused in one or more themes.

### What is the advantage of using SDC for Drupal themes instead of the current approach?

The main advantage is that it allows frontend developers to create components without requiring them to learn Drupal specific theming concepts; however, someone will still need to understand Drupal concepts in order to utilize these components within templates.

### Is there a Drupal-9-compatible patch?

There is no specific Drupal 9 patch; however, there is a contrib module that supports utilizing SDC in Drupal 9.

### Can I start writing SDC style components now?

Yes! To get started check out the quickstart guide.

### How can I declare dependencies for my component?

Adding a dependency for a component can be done within the `*.component.yml` file by including a `libraryOverrides` key.

Also, because Drupal automatically generates libraries for SDCs, you can include an SDC library just like any other dependency.

Below is an example of a component utilizing several Drupal core libraries and another auto-generated theme component library.

```yaml
libraryOverrides:
  dependencies:
    - core/drupal
    - core/once
    - core/components.my-theme--another-component
```

### Can a module override components?

No, modules cannot override components. Only themes can.

### How do I override a component?

Only themes can override components, and there are two important requirements to do so:

1. Create a top level `replaces` key in the `*.component.yml` file of the component you want to override

   ```yaml
   replaces: 'sdc_module_test:my-component'
   ```

2. The component needs to have a defined schema.

It is important to note that modules cannot override components, and only components with a defined schema can replace and be replaced by others.

### Does SDC handle attributes, title_suffix, is_admin, etc?

By design, SDC renderables don't pass through the Theme Manager, so their templates don't receive the default attributes from `::getDefaultTemplateVariables()`:

- `attributes`
- `title_attributes`
- `content_attributes`
- `title_prefix`
- `title_suffix`
- `db_is_active`
- `is_admin`
- `logged_in`
- `directory`

However, SDC itself is automatically adding those variables:

- `attributes` (if missing): an `\Drupal\Core\Template\Attribute` object, like the Theme Manager is doing for other templates.
- `componentMetadata`: with some information useful for debugging:
  - path - The path to the component relative to the web root.
  - machineName - Machine name of the component
  - status - Status of the component. Defaults to stable.
  - name - Name of the component.
  - group- Group of the component. Defaults to "All Components "

### Is the YAML definition mandatory?

A component must have a correctly named YAML. By default (i.e., without component data validation), the content of the YAML file is not enforced and can be ignored by the Twig file. So, props and slots used in a component Twig file are not required to be defined in the YAML file, and would work just the same with an empty YAML file.

However the benefits of writing out a YAML file include:

- It provides a clear description of the component for developers.
- It is required if you want your components to be replaceable (the schema ensures that the two components are compatible).
- It allows your components to be integrated with:
  - site building tools like sdc_display or ui_patterns
  - external libraries such as Storybook

### Why are some PHP namespaces used in props schema?

You may find this in some SDC definitions:

```yaml
name: 'My component'
props:
  type: object
  properties:
    body_attributes:
      type: 'Drupal\Core\Template\Attribute'
```

This is a trick to avoid triggering the JSON schema validator. In March 2025, it is still useful for `\Drupal\Core\Template\Attribute` objects sent as props but:

- it is not necessary to add this for the `attributes` prop itself because it is automatically added to the template anyway
- it must be used for other kinds of props. Let's use standard JSON schema instead, in order not to skip the validation. In other words, except sometimes Attribute, never send a PHP object as a prop value.
- however, you can send PHP objects as slot values if they implement Stringable or RenderableInterface

### How can I attach additional CSS/JS to my component?

Adding additional libraries for a component can be done within the `*.component.yml` file by including a `libraryOverrides` key. Everything under the library overrides key follows standard Drupal structure.

```yaml
libraryOverrides:
  css:
    component:
      tabs.css: {}
      additional-styles.css: {}
  js:
    my-component.js: { attributes: { defer: true } }
    my-other-file.js: {}
```

### How can I override an upstream component’s libraries?

When using a component from an upstream theme or module, you can override its styles, JavaScript, or both. via your `THEME.info.yml`’s `libraries-override`.

To override or omit an entire library, you can do this:

```yaml
# Override the entire library:
libraries-override:
  core/components.some-theme--some-component: my-theme/my-library

# Omit the entire library:
libraries-override:
  core/components.some-theme--some-component: false
```

If you want to override or omit a specific file, you’ll need to find the path to that file relative to the `core/` directory. Then override it like any other library file:

```yaml
# Override a specific file:
libraries-override:
  core/components.some-theme--some-component:
    css:
      component:
        ../themes/contrib/some-theme/components/some-component/some-component.css: my-overrides/some-component.css

# Omit a specific file:
libraries-override:
  core/components.some-theme--some-component:
    css:
      component:
        ../themes/contrib/some-theme/components/some-component/some-component.css: false
```

### Are schemas mandatory when defining components?

Schemas are not mandatory when defining components in themes; however components without schema can not be overridden. In order to enforce that all components within a theme contain schema, add `enforce_prop_schemas: true` to your `theme.info.yml` file.

### What are the best practices?

We are currently in the process of determining that. All of the community testing and feedback help shape what best practices look like. These will continue to evolve as this module becomes more stable.

Some of them are currently being evaluated as a set of validation rules implemented in sdc_devel module.

### Can SDC be used inside of a module?

Yes, see for example sdc_examples.

### Can I organize my component in sub-directories?

Yes. Components within the `components` directory can be nested under arbitrary directories. For example, it is perfectly acceptable to have a `card` directory within a `molecules` directory.

### How can I pass arbitrary HTML into a component?

You should consider using a **slot.** Read the documentation to familiarize yourself with the differences between props and slots, which can be summarized as follows:

> Definitions of the component’s inputs take the form of **props** (for data whose type and structure is well defined) and **slots** (for data with an unknown structure, like nested components).

When using `include()` function, if you try to pass the markup directly, Twig will escape your string and the markup will be lost.

```twig
{% include 'mytheme:mycomponent' with {
  body: '<p><em>my</em> html</p>' <---- will get escaped, HTML will be lost.
}%
```

So you need to do this instead:

```twig
{% set body %}
  <p><em>Any</em> html will be passed along!</p>
{% endset %}

{{ include('mytheme:mycomponent', {
  body: body
}, with_context = false) }}
```

When using the `embed` tag (because you are printing slots with Twig blocks in your component template), you need to put the markup inside a Twig block:

```twig
{% embed 'mytheme:mycomponent' %}
  {% block body %}
    <p><em>Any</em> html will be passed along!</p>
  {% endblock %}
{% endembed %}
```

### Can I use composer packages in SDC?

No.

### Will SDC support variants?

This is under consideration. See #3390712.

Variants were added to 11.2 and up in Added component variants to SDC.

### How do I use the render element?

An SDC-based component can be rendered with a special render element described in the documentation under "Using Your Component through a Render Array", where you will also find an example code snippet.

### Can we preprocess variables with SDC?

No. SDC does not support preprocessing variables by design.

However, this is an on-going discussion. See #3321203.

### How would I use components within my node/user/media/field/block... template?

Use SDC components in a Twig template file using Twig's built-in `include` function and/or `embed` tag. See "Using your new single-directory component" for more information.

### How do I use components within other components?

You can combine and nest components within other components, similar to how you nest conventional Twig templates in Drupal using embed or include tags. See: "Using Your Component Through another Template."

However, instead of hardcoding components calls in component templates, instead of including like that:

```twig
<div class="card__actions">
 {{ include("my_theme:button", {...}, with_context_false) }}
 {{ include("my_theme:button", {...}, with_context_false) }}
</div>
```

Or like that if you use Twig blocks:

```twig
<div class="card__actions">
 {{ embed "my_theme:button" only %}... {% endembed %}
 {{ embed "my_theme:button" only %}... {% endembed %}
</div>
```

It is better to use slots and pass children component from the outside.

### What are props and slots in Drupal SDC theming (with examples)?

See this doc page.

### Can I use (attach) only the assets library (CSS/JS) of a component inside a Twig template?

Yes. For each component Drupal adds a library with the name "core/components.\[THEME_OR_MODULE_NAME\]--\[COMPONENT_NAME_WITH_DASHES\]".

For example, for a component with the name "**my-banner**" on theme "**my_theme**" the default CSS/JS library name is "**core/components.my_theme--my-banner**" so in a Twig template you can attach the library like this.

```twig
{{ attach_library('core/components.my_theme--my-banner') }}
```

Before SDC became stable, it used to be `sdc/my_theme--my-banner`.

You can do the same thing with any additional libraries defined on the sdc component.

### If a component is defined in a module, can I attach additional assets to that component in my theme?

Yes. As mentioned above, each component creates a library. So, you can use `libraries-extend`.

### Should I attach the CSS and JS for all components on all requests?

It may be a good idea to attach all the assets for your components on all requests. This will likely increase the cache hit ratio for the visitor's browser's cache. Depending on the setup, this can have a dramatic effect on your website's front-end performance.

To do so, add the library `core/components.all` as a dependency in your theme. If you are using the experimental version of SDC, you need to use `sdc/all` instead.

### My component doesn't have props, how do I write its schema?

Component schema is mandatory for validation, and for integration with display building modules like SDC Display or UI Patterns. The way to declare empty props is not by leaving them out but by actually saying they are empty. Perhaps a schema like this would work:

```yaml
$schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
name: Info Card

# Declare empty props.
props:
  type: object
  properties: {}

slots:
  card_content:
    title: Content
    required: true
```

### How does cl_components module fit in?

`cl_components` module (Component Libraries: Components) is obsolete. The functionality it provided is now in Drupal core.
