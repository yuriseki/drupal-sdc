#### Component: activity-chart

**Status**: ⚠️ Needs Revision

**Summary**: The SDC implementation instructions for the `activity-chart` component generally align with Drupal SDC standards, including proper schema definition, file structure, and Twig conventions. However, there are significant issues with accessibility, responsive design, data handling accuracy, and chart implementation that require revision to ensure compliance with WCAG guidelines, best practices for finance dashboards, and robust data visualization.

**Detailed Findings**:

##### Schema Validation
- ✅ The YAML schema uses the correct `$schema` URL from `metadata.schema.json`.
- ✅ Props are defined with valid JSON Schema: `title` (string), `month` (string), `data` (array of objects with `label`, `percentage`, `color`), and `view_all_url` (string). Defaults are provided where appropriate.
- ✅ No slots are defined, which is acceptable for a self-contained component, but consider adding a `chart` slot for future extensibility (e.g., custom SVG rendering).
- ✅ Status is set to `experimental`, appropriate for new components.
- ⚠️ The `data` prop's `percentage` is typed as `integer`, but percentages should ideally be validated to sum to 100 or less. Add a `maximum: 100` constraint for each item.

##### File Structure and Naming Conventions
- ✅ Directory structure follows SDC standards: `themes/custom/YOUR_THEME/components/activity-chart/` with files `activity-chart.component.yml`, `activity-chart.twig`, `activity-chart.css`, and SVG assets in `images/`.
- ✅ Naming conventions are consistent (component name matches file prefixes).
- ✅ Library definition in YAML is correct, using `libraryOverrides` for CSS.

##### YAML Configuration (Props, Slots, Libraries)
- ✅ Props schema is well-defined and matches the component's needs.
- ✅ No slots, as specified.
- ✅ Library includes CSS, with potential for JS if interactivity is added.

##### Twig Templates and Conventions
- ✅ Template uses BEM classes (e.g., `activity-chart__title`) consistent with existing patterns in `mytheme`.
- ✅ Variables from props are correctly referenced (e.g., `{{ title }}`, loops over `data`).
- ✅ Uses `{{ attributes }}` implicitly via class additions, but the template lacks `{{ attributes }}` on the root element—add `<div class="activity-chart"{{ attributes }}>`.
- ✅ Image paths use `{{ base_path ~ directory }}/images/...`, which is correct for SDC (the `directory` variable points to the component directory).
- ⚠️ The total percentage calculation (`{{ data|length ? (data|map(item => item.percentage)|sum) : 0 }}%`) assumes data completeness, but in the example (75% central vs. 55% + 20% = 75%), it works, but ensure data validation in preprocess or JS to prevent mismatches.

##### Component Organization and Reusability
- ✅ Component is organized as a card-based chart, reusable for finance dashboards.
- ✅ Follows existing patterns from `cta` and `card` examples (e.g., props for data, no slots).
- ✅ Can be used via `{{ include('mytheme:activity-chart', props) }}` or render arrays.

##### Accessibility
- ❌ **Violation**: The chart lacks semantic HTML and ARIA attributes. Charts conveying data must be accessible. Use `<figure>` for the chart container, `<figcaption>` for the title, and `aria-label` or `role="img"` on the chart with descriptive text (e.g., summarizing percentages). Segments should have `aria-label` describing their data.
- ❌ **Violation**: Images (`<img>`) for SVGs lack `alt` text. Add descriptive `alt` attributes (e.g., `alt="Dropdown arrow"`).
- ❌ **Violation**: No keyboard navigation or screen reader support for interactive elements like the dropdown (if made interactive).
- **Recommendation**: Follow WCAG 2.1 AA guidelines. Provide a text alternative for the chart (e.g., a hidden `<table>` with data or `aria-describedby`).

##### Responsive Design
- ❌ **Violation**: CSS uses fixed dimensions (`width: 374px; height: 415px`), not responsive. No media queries.
- **Recommendation**: Use relative units (e.g., `max-width: 374px`, `width: 100%`), flexbox for layout, and media queries for breakpoints (e.g., reduce size on mobile). Reference `*.breakpoints.yml` in the theme.

##### Data Handling
- ⚠️ Twig calculates total percentage dynamically, which is fine but error-prone if data doesn't sum correctly. Validate in PHP preprocess or add JS to ensure accuracy.
- ✅ Data is passed via props, sanitized via schema.
- **Recommendation**: For dynamic data, consider AJAX fetching with CSRF protection, as per best practices.

##### Integration
- ✅ Aligns with Layout Builder integration via custom blocks or render arrays.
- ✅ No conflicts with existing components.

**Recommendations**
1. **Accessibility Fixes**: Wrap the chart in `<figure>`, add `aria-label` to `.activity-chart__circle` (e.g., `aria-label="Activity breakdown: {{ data|map(item => item.label ~ ' ' ~ item.percentage ~ '%')|join(', ') }}"`), and add `alt` to images.
2. **Responsive Design**: Change fixed widths to `max-width: 374px; width: 100%;`, add media queries (e.g., `@media (max-width: 480px) { .activity-chart { padding: 8px; } .activity-chart__circle { width: 200px; height: 200px; } }`).
3. **Chart Implementation**: Replace CSS segments with SVG or `conic-gradient` for accurate donut rendering. Use `background: conic-gradient({{ data|map(item => item.color ~ ' ' ~ (item.percentage / 100 * 360) ~ 'deg')|join(', ') }});` on `.activity-chart__circle`.
4. **Data Validation**: Add schema constraints for percentages (e.g., `minimum: 0, maximum: 100`). Ensure total sums to 100 in preprocess.
5. **Interactivity**: If dropdown is interactive, add JS with Drupal behaviors and keyboard support.
6. **Testing**: Enable schema validation assertions. Audit with WAVE or Axe for accessibility. Test in Layout Builder.
7. **Best Practices**: Reference `003-drupal-best-practices.md` for semantic HTML and ARIA. Use `Xss::filter()` if user data is involved.

This component has strong foundational compliance but requires enhancements for production use in accessible, responsive finance dashboards. Approve with revisions.