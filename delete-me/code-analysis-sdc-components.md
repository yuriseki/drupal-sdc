# Analysis: SDC Components and Patterns

**Date**: 2026-01-23

**Scope**: Analysis of existing SDC components, reusable patterns, button styles, and theming approaches in the Drupal codebase, focusing on components similar to CTA (buttons, headings, layout structures).

## Findings

### Existing Patterns
- **Button Component**: Simple link-based button with text and URL props. Uses BEM classes (.button). Includes hover effects. Located in base-knowledge/sdc-examples/button.*.
- **Hero Component**: Layout section with title and subtitle. Uses BEM classes (hero, hero__title, hero__subtitle). Includes gradient background. Located in base-knowledge/sdc-examples/hero.*.
- **Card Component**: Content container with optional title and body. Uses BEM classes (card, card__title, card__body). Located in base-knowledge/sdc-examples/card.*.
- **Chip Component**: Small label element with optional remove functionality. Uses BEM classes (chip, chip__label, chip__remove). Located in base-knowledge/sdc-examples/chip.*.
- **Input Component**: Form input with label, placeholder, and type. Located in base-knowledge/sdc-examples/input.*.
- **UI Patterns Button**: Complex button with variants (primary, secondary, etc.), sizes (sm, lg), and states (disabled). Supports both link and button elements. Located in web/modules/contrib/ui_patterns/modules/ui_patterns_legacy/tests/modules/ui_patterns_legacy_test/components/button/*.

### Reusable Code
- **Twig Patterns**: Conditional rendering with {% if %}, attributes.addClass() for dynamic classes, set classes variable for BEM.
- **PHP Classes**: No custom PHP classes found; components are template-based.
- **CSS Patterns**: BEM methodology (block__element--modifier), utility classes, CSS variables in Claro theme.
- **Component Structure**: Props for typed data (string, boolean), slots not used in examples but available.

### Architecture Notes
- **Directory Structure**: Examples are flat files in base-knowledge/sdc-examples/, not proper single directories. Theme has empty components/ directory.
- **Naming Conventions**: Simple names (Button, Hero), lowercase filenames.
- **Library Dependencies**: Automatic library generation for CSS/JS files.
- **Base Theme**: Claro uses extensive button styles (.button, .button--primary, etc.) with CSS variables.
- **Heading Styles**: Claro provides heading styles with CSS variables (--font-size-h1, etc.).

### Recommendations
1. **Reuse Button Component**: Base new CTA component on the example button component, extending with additional props like variant, size.
2. **Follow BEM**: Use BEM methodology for new components as seen in examples.
3. **Leverage Claro Styles**: Reuse Claro's button and heading classes for consistency.
4. **Implement Single Directories**: Create proper component directories with .component.yml, .twig, .css files.
5. **Add Variants**: Consider adding variants to components for different styles (primary, secondary).
6. **Use Slots for Flexibility**: Implement slots for content areas in layout components.

## References
- base-knowledge/sdc-examples/button.component.yml (lines 1-12)
- base-knowledge/sdc-examples/button.twig (lines 1-1)
- base-knowledge/sdc-examples/button.css (lines 1-12)
- base-knowledge/sdc-examples/hero.component.yml (lines 1-12)
- base-knowledge/sdc-examples/hero.twig (lines 1-6)
- base-knowledge/sdc-examples/hero.css (lines 1-17)
- base-knowledge/sdc-examples/card.component.yml (lines 1-12)
- base-knowledge/sdc-examples/card.twig (lines 1-8)
- base-knowledge/sdc-examples/chip.component.yml (lines 1-13)
- base-knowledge/sdc-examples/chip.twig (lines 1-6)
- base-knowledge/sdc-examples/input.component.yml (lines 1-16)
- web/modules/contrib/ui_patterns/modules/ui_patterns_legacy/tests/modules/ui_patterns_legacy_test/components/button/button.component.yml (lines 1-122)
- web/modules/contrib/ui_patterns/modules/ui_patterns_legacy/tests/modules/ui_patterns_legacy_test/components/button/button.twig (lines 1-35)
- web/core/themes/claro/css/components/button.css (lines 35-50)
- web/core/themes/claro/css/components/button.pcss.css (lines 27-50)

## Compatibility Notes
- Example components comply with SDC standards but are not in proper directory structure.
- UI Patterns components are legacy but provide extensive variant examples.
- Claro theme provides comprehensive button and heading styles that can be leveraged.
- No conflicts identified; examples are reference materials.
