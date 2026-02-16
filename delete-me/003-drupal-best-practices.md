#### Research: Drupal SDC Best Practices for Finance Dashboard Components like Activity Charts

**Date**: January 24, 2026

**Question/Goal**: What are the best practices for implementing finance dashboard components, such as activity charts, using Drupal's Single Directory Components (SDC)? This includes guidelines on theming, accessibility (WCAG compliance), responsive design, data handling, and integration with Layout Builder or other Drupal features, referencing official Drupal documentation and community standards.

**Findings**:

##### Current Best Practices
- **Component Organization**: Place SDC components in the theme or module's `components/` directory, with subdirectories for organization (e.g., `components/charts/activity-chart`). Each component must include a `component-name.component.yml` file and a `component-name.twig` template. Optional CSS and JS files (named after the component) are auto-loaded.
- **Schema Definition**: Always define JSON Schema in the `.component.yml` for props to enable validation, overriding, and future UI generation. For themes, enforce schemas with `enforce_prop_schemas: true` in `info.yml`.
- **Security and Performance**: Use Twig's auto-escaping for output. Avoid inline JS; use libraries. Leverage Drupal's caching for performance.
- **Reusability**: Design components with props for customization, slots for flexible content, and schemas for type safety.

##### Relevant APIs
- **Single Directory Components API**: Provides automatic library generation, schema validation, and integration with Drupal's render system. Use `libraryOverrides` in `.component.yml` for custom dependencies.
- **Render API**: SDC integrates with Drupal's Render API, allowing components to be invoked via `{{ include('component-name', { props }) }}` in Twig or render arrays.
- **Theme System**: Use breakpoints for responsive design via `*.breakpoints.yml`. Integrate with Layout Builder by creating blocks that render SDC components.
- **Plugin System**: For custom blocks or fields, use Block plugins to encapsulate SDC components.

##### Integration Recommendations
1. **Layout Builder Integration**: Create a custom Block plugin that renders the SDC component. Use the Block's `build()` method to pass data to the component via props. This allows placing chart components in Layout Builder sections without custom entities.
2. **Data Handling**: Pass chart data (e.g., arrays of values, labels) via props with JSON Schema validation. Sanitize data in preprocess functions using Drupal's security APIs. For dynamic data, use AJAX or REST APIs to fetch from endpoints, ensuring CSRF protection.
3. **Responsive Design**: Define breakpoints in `theme.breakpoints.yml` and use CSS media queries in component styles. For charts, use responsive JS libraries that adapt to container sizes.
4. **Accessibility**: Follow WCAG 2.1 guidelines: Use semantic HTML (e.g., `<figure>` for charts), ARIA attributes (e.g., `role="img"`, `aria-label`), and provide text alternatives. Ensure keyboard navigation and screen reader support in JS.
5. **Theming**: Use CSS variables for theming colors, fonts. Override components in sub-themes by defining `replaces` in `.component.yml`.

**Sources**:
- [Using Single-Directory Components](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components) - Official Drupal guide on SDC basics, creation, and benefits.
- [Annotated example component.yml](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components/annotated-example-componentyml) - Detailed schema examples for props and slots.
- [Working with breakpoints in Drupal](https://www.drupal.org/docs/develop/theming-drupal/working-with-breakpoints-in-drupal) - Guidelines for responsive design using breakpoints.
- [Accessibility](https://www.drupal.org/docs/accessibility) - Drupal's accessibility resources, including WCAG best practices and review processes.
- [API Reference for SDC](https://api.drupal.org/api/drupal/11.x/search/single_directory_components) - Technical API details for SDC integration.

**Recommendations for Implementation**:
1. **Create the Component Structure**: In your theme's `components/charts/`, create `activity-chart.component.yml` with props for data (array of objects with labels/values), title, and options. Define schema for validation.
2. **Implement Twig Template**: Use `<canvas>` or `<svg>` for charts, with slots for legends. Include ARIA labels and ensure semantic markup.
3. **Add JS/CSS**: Use a library like Chart.js via `libraryOverrides`. Attach JS to initialize charts with passed props data, ensuring accessibility (e.g., data tables fallback).
4. **Responsive Handling**: In CSS, use media queries based on theme breakpoints. In JS, make charts responsive to container width.
5. **Data Security**: In the Block plugin's `build()`, fetch and sanitize data from entities or APIs. Use `Xss::filter()` for user inputs.
6. **Layout Builder Setup**: Implement a Block plugin that includes the SDC via `{{ include('activity-chart', props) }}`. Configure block forms for user input.
7. **Testing**: Enable assertions for schema validation. Perform accessibility audits using tools like WAVE or Axe, ensuring WCAG AA compliance.
8. **Override and Extend**: For sub-themes, use `replaces` to customize chart styles or add features.