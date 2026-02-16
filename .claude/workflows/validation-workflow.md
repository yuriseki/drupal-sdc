# Workflow: SDC Component Validation

This workflow validates existing or proposed SDC components against Drupal SDC standards and best practices.

## When to Use This Workflow

- Validating completed components before approval
- Reviewing components created outside the main workflow
- Auditing existing components for compliance
- Checking implementation instructions before coding
- Quality assurance before commits or deployments

## Validation Levels

### 1. Instruction Validation
Validate `code-instruction/NNN-component.md` files before implementation

### 2. Implementation Validation
Validate actual component code in `web/themes/custom/mytheme/components/`

### 3. Existing Component Audit
Comprehensive review of deployed components

## Workflow Steps

### Phase 1: Preparation

**Goal**: Gather component information and validation context

**Steps**:

1. **Identify Component**:
   - Component name
   - Location (instruction file or implemented files)
   - Purpose and requirements

2. **Load Standards**:
   - Read `base-knowledge/single-directory-components.md`
   - Review JSON Schema specifications
   - Check Drupal coding standards

3. **Gather Context**:
   - Original requirements (Figma URL, user request)
   - Related components or patterns
   - Expected usage scenarios

**Output**: Component scope and validation checklist

### Phase 2: Schema Validation (SDC Expert Role)

**Goal**: Ensure YAML schema follows SDC standards

#### 2.1 Component Metadata

**Check**:
```yaml
name: Component Name          # Required: Human-readable name
status: stable|experimental   # Optional but recommended
description: Purpose text     # Recommended
```

**Validation Rules**:
- [ ] `name` exists and is descriptive
- [ ] `status` is appropriate (use 'experimental' for new components)
- [ ] `description` explains purpose and usage
- [ ] Metadata is clear and helpful

#### 2.2 Props Schema

**Check**:
```yaml
props:
  type: object                # Must be 'object'
  required:                   # List required props
    - propName
  properties:
    propName:
      type: string            # Valid JSON Schema type
      title: Human Title      # Required
      description: Purpose    # Required
      enum: [val1, val2]     # For limited options
      default: value          # Optional default
```

**Validation Rules**:
- [ ] `props.type` is `object`
- [ ] All props have `type` specified
- [ ] Types are valid: null, boolean, object, array, number, string
- [ ] Each prop has `title` and `description`
- [ ] Required props are actually required for component to function
- [ ] Optional props have sensible defaults or handle null
- [ ] `enum` used for limited value sets
- [ ] Prop names follow camelCase convention
- [ ] No typos in property names

**Common Issues**:
- ❌ Using invalid types (e.g., 'text', 'integer')
- ❌ Missing titles or descriptions
- ❌ Marking props as required when they're optional
- ❌ Not using enum for limited value sets
- ❌ Inconsistent naming conventions

#### 2.3 Slots Schema

**Check**:
```yaml
slots:
  slotName:
    title: Human Title        # Required
    description: Purpose      # Required
```

**Validation Rules**:
- [ ] Each slot has `title` and `description`
- [ ] Slot names are semantic (e.g., 'content', 'header', 'footer')
- [ ] Slots are used for unstructured content (not data)
- [ ] Number of slots is reasonable (not over-engineered)

**Props vs Slots Decision**:
- Use **props** for: Typed data (strings, booleans, numbers, enums)
- Use **slots** for: HTML content, nested components, unstructured data

#### 2.4 Libraries

**Check**:
```yaml
# Auto-loading (preferred)
# component-name.css and component-name.js automatically loaded

# Or explicit libraries:
libraryOverrides:
  dependencies:
    - core/drupal
    - mytheme/base-styles
```

**Validation Rules**:
- [ ] Standard CSS/JS files named correctly for auto-loading
- [ ] libraryOverrides only used when needed
- [ ] Dependencies exist and are available
- [ ] No circular dependencies

**Output**: Schema validation report

### Phase 3: File Structure Validation

**Goal**: Ensure component directory follows SDC conventions

**Expected Structure**:
```
components/{component-name}/
├── {component-name}.component.yml    # Required
├── {component-name}.twig             # Required
├── {component-name}.css              # Optional
├── {component-name}.js               # Optional
├── README.md                         # Optional
└── assets/                           # Optional
    └── *.{png,jpg,svg}
```

**Validation Rules**:
- [ ] Component name uses lowercase and hyphens only
- [ ] Directory name matches component name
- [ ] `.component.yml` exists and is named correctly
- [ ] `.twig` file exists and is named correctly
- [ ] CSS file named correctly (if present)
- [ ] JS file named correctly (if present)
- [ ] No extra or misnamed files
- [ ] Assets organized appropriately

**Common Issues**:
- ❌ CamelCase or snake_case names
- ❌ Inconsistent naming between directory and files
- ❌ Multiple CSS/JS files (should consolidate or use libraries)
- ❌ Unorganized asset files

**Output**: File structure compliance report

### Phase 4: Twig Template Validation

**Goal**: Ensure template follows Drupal and SDC patterns

#### 4.1 Template Structure

**Check**:
```twig
{# Set CSS classes #}
{%
  set classes = [
    'component-name',
    props.modifier ? 'component-name--' ~ props.modifier,
  ]
%}

{# Output wrapper with attributes #}
<div{{ attributes.addClass(classes) }}>
  {# Content using props and slots #}
  {{ props.propertyName }}
  {{ slots.slotName }}
</div>
```

**Validation Rules**:
- [ ] Sets classes array for component and modifiers
- [ ] Uses `attributes.addClass()` for wrapper
- [ ] Props accessed via `props.propertyName`
- [ ] Slots accessed via `slots.slotName`
- [ ] Includes appropriate HTML structure
- [ ] No hardcoded values that should be props
- [ ] Handles missing/optional props gracefully

#### 4.2 BEM Methodology

**Check**:
- Block: `.component-name`
- Element: `.component-name__element`
- Modifier: `.component-name--modifier`

**Validation Rules**:
- [ ] Base class matches component name
- [ ] Elements use double underscore
- [ ] Modifiers use double dash
- [ ] Classes are semantic
- [ ] No deeply nested BEM structures
- [ ] Consistent naming throughout

#### 4.3 Accessibility

**Validation Rules**:
- [ ] Semantic HTML elements used
- [ ] ARIA attributes where needed
- [ ] Labels for interactive elements
- [ ] Keyboard accessibility considered
- [ ] Focus management appropriate
- [ ] Color contrast requirements met (check with design)
- [ ] Alt text for images (via props or slots)

#### 4.4 Twig Best Practices

**Validation Rules**:
- [ ] No business logic in templates
- [ ] Comments explain complex sections
- [ ] Proper indentation and formatting
- [ ] No inline styles (use CSS)
- [ ] No inline scripts (use JS file)
- [ ] Filters used appropriately (|escape, |raw, etc.)
- [ ] Trans filter for translatable strings

**Output**: Twig template validation report

### Phase 5: CSS Validation

**Goal**: Ensure styles follow best practices

#### 5.1 CSS Structure

**Check**:
```css
/* Component base styles */
.component-name {
  /* Layout */
  /* Visual */
}

/* Component elements */
.component-name__element {
  /* Styles */
}

/* Component modifiers */
.component-name--modifier {
  /* Variations */
}

/* Component states */
.component-name.is-active {
  /* State styles */
}

/* Responsive */
@media (min-width: 768px) {
  .component-name {
    /* Tablet styles */
  }
}
```

**Validation Rules**:
- [ ] BEM structure followed
- [ ] Styles scoped to component
- [ ] No global selector pollution
- [ ] Responsive breakpoints defined
- [ ] Mobile-first approach
- [ ] No !important (unless absolutely necessary)
- [ ] Properties organized logically
- [ ] Comments for complex rules

#### 5.2 Design System

**Validation Rules**:
- [ ] Uses CSS variables/design tokens
- [ ] Consistent spacing scale
- [ ] Consistent typography scale
- [ ] Color palette from design system
- [ ] Reuses common patterns

#### 5.3 Performance

**Validation Rules**:
- [ ] No overly complex selectors
- [ ] Efficient CSS (no redundancy)
- [ ] Appropriate use of transitions/animations
- [ ] No large background images in CSS (use img tags)

**Output**: CSS validation report

### Phase 6: JavaScript Validation

**Goal**: Ensure scripts follow Drupal patterns

#### 6.1 Drupal Behaviors

**Check**:
```javascript
(function (Drupal) {
  'use strict';

  Drupal.behaviors.componentName = {
    attach: function (context, settings) {
      // Component logic
      // Use context for scoping
    },
    detach: function (context, settings, trigger) {
      // Cleanup if needed
    }
  };
})(Drupal);
```

**Validation Rules**:
- [ ] Uses Drupal behaviors pattern
- [ ] Wrapped in IIFE
- [ ] Uses 'use strict'
- [ ] Respects context parameter
- [ ] Handles multiple attach calls
- [ ] Cleans up in detach (if needed)
- [ ] No global variable pollution

#### 6.2 Progressive Enhancement

**Validation Rules**:
- [ ] Works without JavaScript
- [ ] Enhances existing functionality
- [ ] Graceful degradation
- [ ] No critical functionality JS-only

#### 6.3 JavaScript Best Practices

**Validation Rules**:
- [ ] Clear, semantic code
- [ ] Appropriate comments
- [ ] Error handling
- [ ] Performance optimized
- [ ] Accessibility maintained
- [ ] No console.log statements

**Output**: JavaScript validation report

### Phase 7: Integration Validation

**Goal**: Ensure component works in context

**Validation Rules**:
- [ ] Can be included via Twig include
- [ ] Props passed correctly
- [ ] Slots render correctly
- [ ] CSS loads appropriately
- [ ] JS attaches correctly
- [ ] No conflicts with other components
- [ ] Works in various contexts (blocks, pages, etc.)

**Test Pattern**:
```twig
{{ include('mytheme:component-name', {
  props: {
    prop1: 'value',
    prop2: true
  },
  slots: {
    content: '<p>Slot content</p>'
  }
}) }}
```

**Output**: Integration test report

### Phase 8: Security & Performance

**Goal**: Ensure component is secure and performant

#### Security Checklist
- [ ] No XSS vulnerabilities
- [ ] Proper output escaping in Twig
- [ ] No SQL injection risks
- [ ] No insecure external resources
- [ ] No hardcoded secrets
- [ ] Sanitizes user input

#### Performance Checklist
- [ ] CSS is optimized
- [ ] JS is optimized
- [ ] Images are optimized
- [ ] No unnecessary HTTP requests
- [ ] Appropriate caching
- [ ] No render-blocking resources

**Output**: Security and performance report

### Phase 9: Generate Validation Report

**Goal**: Compile comprehensive validation results

**Report Structure**:

```markdown
# SDC Validation Report: {Component Name}

**Component**: {component-name}
**Validation Date**: {YYYY-MM-DD}
**Validator**: SDC Expert
**Overall Status**: ✅ Approved | ⚠️ Needs Revision | ❌ Non-Compliant

## Executive Summary

{2-3 sentence summary of validation results}

## Validation Results

### Schema Validation: ✅ | ⚠️ | ❌

#### Props Schema
- ✅ Props type is object
- ✅ All props have type, title, description
- ⚠️ Issue: {specific issue}

#### Slots Schema
- ✅ All slots have title and description
- ✅ Slots appropriately defined

#### Metadata
- ✅ Name, description present
- ⚠️ Status not specified (recommend adding)

### File Structure: ✅ | ⚠️ | ❌

- ✅ Directory structure correct
- ✅ Files named correctly
- ✅ No extra files

### Twig Template: ✅ | ⚠️ | ❌

- ✅ Uses attributes.addClass()
- ✅ BEM classes correct
- ⚠️ Issue: {specific issue}
- ✅ Accessibility requirements met

### CSS: ✅ | ⚠️ | ❌

- ✅ BEM structure followed
- ✅ Responsive styles included
- ⚠️ Issue: {specific issue}

### JavaScript: ✅ | ⚠️ | ❌ | N/A

- ✅ Drupal behaviors pattern used
- ✅ Progressive enhancement
- ✅ No global pollution

### Integration: ✅ | ⚠️ | ❌

- ✅ Include pattern works
- ✅ Props pass correctly
- ✅ Slots render correctly

### Security: ✅ | ⚠️ | ❌

- ✅ No XSS vulnerabilities
- ✅ Proper escaping
- ✅ No hardcoded secrets

### Performance: ✅ | ⚠️ | ❌

- ✅ CSS optimized
- ✅ JS optimized
- ⚠️ Issue: {specific issue}

## Issues Found

### Critical Issues (Must Fix)
1. **Issue**: Description
   - **Location**: File/line
   - **Fix**: What needs to change
   - **Reference**: Link to documentation

### Warnings (Should Fix)
1. **Issue**: Description
   - **Location**: File/line
   - **Recommendation**: Suggested improvement

### Suggestions (Nice to Have)
1. **Suggestion**: Enhancement idea
   - **Benefit**: Why it would help

## Recommendations

### Immediate Actions
1. {Action needed before approval}
2. {Action needed before approval}

### Future Improvements
1. {Enhancement for later}
2. {Enhancement for later}

## Compliance Summary

| Area | Status | Notes |
|------|--------|-------|
| Schema | ✅ | Fully compliant |
| File Structure | ✅ | Correct |
| Twig | ⚠️ | Minor issues |
| CSS | ✅ | Compliant |
| JS | ✅ | N/A |
| Integration | ✅ | Works correctly |
| Security | ✅ | No issues |
| Performance | ⚠️ | See recommendations |

## Code Examples

### Corrected YAML Schema
\`\`\`yaml
{Show corrected version if issues found}
\`\`\`

### Corrected Twig
\`\`\`twig
{Show corrected version if issues found}
\`\`\`

## References

- SDC Documentation: base-knowledge/single-directory-components.md
- JSON Schema: https://json-schema.org/
- Drupal Coding Standards: https://www.drupal.org/docs/develop/standards
- WCAG Guidelines: https://www.w3.org/WAI/WCAG21/quickref/

## Approval Status

- ✅ **APPROVED**: Component meets all requirements and is ready for use
- ⚠️ **CONDITIONAL**: Approved with minor issues to address in future iteration
- ❌ **NOT APPROVED**: Critical issues must be fixed before implementation/deployment

## Next Steps

1. {What should happen next}
2. {What should happen next}

---

**Validation completed by**: Claude SDC Expert
**Report generated**: {timestamp}
```

**Output**: Save to `code-instruction/sdc-validation-{component-name}.md`

## Validation Checklist Summary

Use this quick checklist for validation:

```markdown
## SDC Validation Checklist

### Schema (YAML)
- [ ] Metadata: name, description, status
- [ ] Props: type=object, properties defined
- [ ] Each prop: type, title, description
- [ ] Required props appropriate
- [ ] Enums for limited values
- [ ] Slots: title, description
- [ ] Libraries correct (if used)

### File Structure
- [ ] Directory: lowercase-with-hyphens
- [ ] Files: {name}.component.yml, {name}.twig
- [ ] Optional: {name}.css, {name}.js
- [ ] Naming consistent

### Twig Template
- [ ] Classes array with BEM
- [ ] attributes.addClass(classes)
- [ ] Props via props.name
- [ ] Slots via slots.name
- [ ] Semantic HTML
- [ ] Accessibility attributes
- [ ] No inline styles/scripts

### CSS
- [ ] BEM methodology
- [ ] Scoped to component
- [ ] Responsive breakpoints
- [ ] Design tokens used
- [ ] Optimized

### JavaScript (if present)
- [ ] Drupal behaviors pattern
- [ ] Uses context
- [ ] Progressive enhancement
- [ ] No global pollution
- [ ] Optimized

### Integration
- [ ] Include pattern works
- [ ] Props pass correctly
- [ ] Slots render correctly
- [ ] No conflicts

### Security
- [ ] No XSS vulnerabilities
- [ ] Proper escaping
- [ ] No secrets

### Performance
- [ ] Assets optimized
- [ ] No unnecessary requests
- [ ] Efficient code
```

## Common Validation Scenarios

### Scenario 1: Pre-Implementation Validation

User provides implementation instructions → Validate before coding

**Focus**: Schema correctness, design completeness, feasibility

### Scenario 2: Post-Implementation Validation

Component code complete → Validate before approval

**Focus**: Full compliance check, integration testing, security

### Scenario 3: Existing Component Audit

Review deployed components → Identify technical debt

**Focus**: Standards compliance, optimization opportunities, modernization

### Scenario 4: Rapid Validation

Quick check before commit → Fast validation

**Focus**: Critical issues only (schema, file structure, security)

## Related Workflows

- `figma-to-sdc.md` - Includes validation as Phase 4
- `research-workflow.md` - Research to inform validation criteria
- `.claude/instructions/project-context.md` - Overall validation standards
