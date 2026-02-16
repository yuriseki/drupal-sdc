### Summary of What We Did So Far

We analyzed the current Drupal codebase located at `/home/yuri/ssd2/project-files/Kalamuna/projects/drupal-11` for existing Single Directory Components (SDC), theming patterns, and alignment with SDC standards. The focus was on finance/dashboard-related components, and we provided insights for integrating a new `activity-chart` component (a card-based donut chart for displaying activity breakdowns, suitable for finance dashboards).

Key findings from our analysis (saved in `code-instruction/002-codebase-analysis.md`):
- **Existing SDC Components**: Found one custom component (`cta` - a call-to-action component with title, subtitle, button, and image) in the `mytheme` theme. Example components (button, card, chip, hero, input) exist in `base-knowledge/sdc-examples/`. The UI Patterns module provides additional test components like complex cards with variants.
- **Theming Structure**: The `mytheme` theme uses BEM naming conventions (e.g., `cta__title`), CSS organized by component/base/layout/theme, and automatic library generation for SDC assets. Libraries are defined in `mytheme.libraries.yml`, and themes can override component libraries.
- **Patterns and Standards**: Components follow SDC best practices (props/slots via JSON Schema, Twig templates with `attributes` variable, optional CSS/JS). The `base-knowledge/single-directory-components.md` document serves as the source-of-truth for SDC guidelines. No existing finance/dashboard-specific components were found.
- **Finance/Dashboard Context**: The `activity-chart` component (from `001-component-description.md`) is the first such component. It requires a card-based structure with donut chart visualization, suitable for finance dashboards.
- **Integration Insights**: The new `activity-chart` should be placed in `web/themes/custom/mytheme/components/activity-chart/`, follow existing patterns (e.g., props/slots, BEM classes), and use the `card` example as a base. Required files include `activity-chart.component.yml`, `activity-chart.twig`, `activity-chart.css`, and SVG icons. No JS needed for static display, but interactivity (e.g., dropdown) could be added later. The component aligns with SDC standards and can be used via Twig `include()` or render arrays.

We completed the analysis and saved the comprehensive report, providing a foundation for implementing the `activity-chart` component.

### Detailed Prompt for Continuing the Conversation

**System Prompt for AI Continuation:**

You are a Drupal development assistant specializing in Single Directory Components (SDC). A previous session analyzed the Drupal codebase at `/home/yuri/ssd2/project-files/Kalamuna/projects/drupal-11` for existing SDC components, theming patterns, and SDC alignment, with a focus on finance/dashboard components. The analysis was saved to `code-instruction/002-codebase-analysis.md` and revealed:

- One existing custom SDC (`cta` component in `web/themes/custom/mytheme/components/cta/`) with props/slots, Twig template, CSS, and BEM classes.
- Example SDC components in `base-knowledge/sdc-examples/` (e.g., `card`, `button`) following SDC standards from `base-knowledge/single-directory-components.md`.
- Theming structure uses BEM, automatic library generation, and libraries defined in `mytheme.libraries.yml`.
- No finance/dashboard components exist; the new `activity-chart` component (detailed in `code-instruction/001-component-description.md`) is a card-based donut chart for finance dashboards, requiring integration insights.
- Key integration recommendations: Place in `web/themes/custom/mytheme/components/activity-chart/`, use `card` example as base, create required files (`activity-chart.component.yml`, `activity-chart.twig`, `activity-chart.css`), copy SVGs from `code-instruction/images/`, align with SDC standards (props/slots via JSON Schema, optional CSS/JS), and enable usage via Twig `include()` or render arrays.

The current task is to implement the `activity-chart` SDC component based on the Figma design in `001-component-description.md` and the analysis in `002-codebase-analysis.md`. We have not yet started implementation—only analysis is complete.

**What we did**: Completed codebase analysis and documented findings in `002-codebase-analysis.md`.

**What we're doing**: Preparing to implement the `activity-chart` component following SDC standards and existing patterns.

**Which files we're working on**: 
- Reference: `code-instruction/001-component-description.md` (design specs), `code-instruction/002-codebase-analysis.md` (analysis), `base-knowledge/single-directory-components.md` (standards), `base-knowledge/sdc-examples/card.*` (template).
- Target: New directory `web/themes/custom/mytheme/components/activity-chart/` with files `activity-chart.component.yml`, `activity-chart.twig`, `activity-chart.css`, and SVG assets from `code-instruction/images/`.

**What we're going to do next**: 
1. Create the component directory structure.
2. Implement the YAML schema with props (title, month, data array with labels/percentages/colors, view_all_url) and slots (none, per analysis).
3. Create the Twig template using card-like structure with chart rendering (simplified CSS for donut effect, no JS initially).
4. Add CSS replicating Figma styles (dark background, rounded corners, responsive layout, BEM classes).
5. Copy SVG icons and integrate into template/CSS.
6. Test component usage via Twig include in a template (e.g., dashboard page).
7. Validate against SDC standards and ensure it follows existing patterns (e.g., from `cta` and `card` examples).
8. Consider future enhancements (e.g., JS for interactivity, chart library integration).

**Continue the implementation**: Start by creating the component directory and files, ensuring alignment with SDC best practices and the provided design specs. If uncertainties arise, reference `base-knowledge/single-directory-components.md` and the analysis report. Output any new files or changes, and update progress in `code-instruction/` with sequential numbering (e.g., `003-component-implementation.md`).