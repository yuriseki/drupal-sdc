#### Analysis: Existing SDC Components

**Date**: Sat Jan 24 2026

**Scope**: Analyzed existing SDC components in the Drupal codebase for structure, naming conventions, and alignment with SDC standards. Identified patterns and inconsistencies.

**Findings**:

##### Existing Patterns
- All SDC components follow the single-directory structure with required .component.yml and .twig files.
- Optional .css files are named after the component and auto-loaded.
- Assets are stored in subdirectories (e.g., images/ for SVGs).
- Naming conventions: kebab-case directories, files match directory name.
- Schema includes $schema URL, name, status (experimental), props with JSON Schema validation.
- Some components use slots for flexible content (e.g., cta has custom_title, custom_subtitle, etc.).
- Twig templates use BEM classes, attributes variable, and conditional rendering.
- CSS uses BEM methodology, custom properties, and responsive design.

##### Reusable Code
- activity-chart: Card-based donut chart for finance dashboards, with props for title, month, data array, view_all_url.
- cta: Call-to-action component with title, subtitle, button, image, and slots for customization.
- Example components (button, card, chip, hero, input) in base-knowledge/sdc-examples/ provide basic patterns for buttons, cards, etc.

##### Recommendations
1. Use existing components as templates: Reuse cta for layout structure, card for container styles.
2. Follow naming conventions: kebab-case for directories, component-name for files.
3. Include proper schema: Define props with types, defaults, enums; use slots for flexible content.
4. Align with standards: Use libraryOverrides instead of library in YAML; ensure accessibility and responsiveness.
5. Fix inconsistencies: Update activity-chart.component.yml to use libraryOverrides.

**References**:
- web/themes/custom/mytheme/components/activity-chart/activity-chart.component.yml (lines 1-44)
- web/themes/custom/mytheme/components/cta/cta.component.yml (lines 1-45)
- base-knowledge/sdc-examples/button.component.yml (lines 1-12)
- base-knowledge/sdc-examples/card.component.yml (lines 1-12)
- base-knowledge/sdc-examples/chip.component.yml (lines 1-13)
- base-knowledge/sdc-examples/hero.component.yml (lines 1-12)
- base-knowledge/sdc-examples/input.component.yml (lines 1-16)
- base-knowledge/single-directory-components.md (lines 1-1063)
