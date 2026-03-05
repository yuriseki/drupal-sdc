# Workflow: Figma Design to SDC Component

This workflow guides the complete process of transforming a Figma design into a fully implemented SDC component in Drupal.

## Prerequisites

- Valid Figma URL with design specifications
- Access to Figma MCP server (configured in claude.json)
- Drupal theme with components directory
- Base knowledge loaded (base-knowledge/single-directory-components.md)
- Schema for YML file loaded (base-knowledge/metadata.schema.json)

## Workflow Steps

### Phase 1: Design Extraction (Figma Expert Role)

**Goal**: Extract complete design data and generate implementation instructions

**Steps**:
1. Validate the Figma URL format
2. Use `figma-local_get_figma_data` to extract design information
3. Analyze design structure:
   - Component hierarchy
   - Layout and spacing
   - Colors and typography
   - Interactive elements
   - Responsive behavior
4. Download required assets using `figma-local_download_figma_images`
5. Store assets in `mytheme/assets/figma/{component-name}/`

**Output**: Raw design data and downloaded assets

### Phase 2: Research & Analysis (Drupal Expert + Code Explorer Roles)

**Goal**: Understand how this component fits into the existing architecture

**Drupal Expert Tasks**:
1. Research relevant Drupal APIs and patterns
2. Search in mytheme the for similar component implementations
3. Identify best practices for:
   - Responsive images (if applicable)
   - Accessibility requirements
   - Performance considerations
   - Integration patterns
4. Document findings with citations

**Code Explorer Tasks**:
1. Scan existing components for patterns:
   ```bash
   ls web/themes/custom/mytheme/components/
   ```
2. Identify reusable:
   - CSS patterns and variables
   - Twig macros and includes
   - JavaScript utilities
   - YAML structure patterns
3. Check for naming conflicts
4. Analyze component dependencies

**Output**:
- `code-instruction/NN-drupal-research--{component-name}.md`
- `code-instruction/NN-code-architecture-analysis--{component-name}.md`

Where `nn` is a sequential number related to the component number you are working.

Example:
- code-instruction/01-drupal-research--CTA.md
- code-instruction/01-code-architecture-analysis--CTA.md


### Phase 3: Instruction Generation (Figma Expert Role)

**Goal**: Create detailed, actionable implementation instructions

**Steps**:
1. Determine next sequential number in `code-instruction/`
2. Map design elements to SDC structures:
   - Identify props (typed data: colors, sizes, booleans)
   - Identify slots (unstructured content areas)
   - Map CSS classes and BEM structure
   - Plan JavaScript interactions
3. Generate instruction file: `code-instruction/NN-{component-name}.md`

**Instruction File Structure**:
```markdown
# Component: {Component Name}

## Figma URL
{Complete Figma design URL}

## Design Breakdown

### Visual Structure
- Layout description
- Grid/flex structure
- Spacing system

### Content Elements
- Text content areas
- Images/media
- Interactive elements

### Design Tokens
- Colors used (with hex values)
- Typography (fonts, sizes, weights)
- Spacing values
- Border radius, shadows, etc.

## SDC Mapping

### Component Metadata
- Name: {component-name}
- Description: {Purpose and usage}
- Status: {stable/experimental}

### Props Schema
\`\`\`yaml
props:
  type: object
  required:
    - {required-prop}
  properties:
    {prop-name}:
      type: {string|boolean|number|object|array}
      title: {Human readable title}
      description: {What this controls}
      default: {default-value}  # REQUIRED: Always provide defaults for UI Patterns compatibility
      enum: [{allowed-values}]  # if applicable
\`\`\`

**IMPORTANT**: Always provide `default` values for ALL props, especially required ones. This ensures:
- UI Patterns can auto-render components without errors
- Component previews work in pattern libraries
- Better developer experience with fallback values
- Compatibility with auto-discovery tools

**MANDATORY: Check string length for every string prop**

Drupal's `textfield` defaults to `#maxlength: 128`. String defaults longer than 128 chars cause a validation error. For every string prop, count the default value and add `maxLength` if needed:

```yaml
# Short text (≤128 chars) — no maxLength needed
heading:
  type: string
  title: Heading
  default: Agency Name

# Long text (>128 chars) — maxLength REQUIRED
description:
  type: string
  title: Description
  maxLength: 1000   # ← REQUIRED when len(default) > 128
  default: Full paragraph text from Figma that exceeds 128 characters...

# Rules:
# len(default) > 128 → add maxLength
# Paragraphs / body text → maxLength: 1000
# Summaries / subtitles → maxLength: 500
# Titles / labels / URLs → no maxLength needed
```

### Slots Schema
\`\`\`yaml
slots:
  {slot-name}:
    title: {Title}
    description: {Purpose}
\`\`\`

### Libraries
- CSS: {component-name}.css
- JS: {component-name}.js (if needed)
- Dependencies: {list any required libraries}

## Implementation Steps

### 1. Create Component Directory
\`\`\`bash
mkdir -p web/themes/custom/mytheme/components/{component-name}
\`\`\`

### 2. Component YAML
Create `{component-name}.component.yml` with:
- Metadata (name, description, status)
- Props schema
- Slots schema
- Libraries (if additional assets needed)

### 3. Twig Template
Create `{component-name}.twig` with:
- Set CSS classes array
- Output wrapper with attributes
- Render props as needed
- Render slots with default content
- Follow BEM methodology

### 4. CSS Stylesheet
Create `{component-name}.css` with:
- Component styles
- Responsive breakpoints
- State variations (hover, active, disabled)
- BEM structure

### 5. JavaScript (if needed)
Create `{component-name}.js` with:
- Drupal behaviors
- Component interactions
- Progressive enhancement

## Validation Checklist
- [ ] YAML validates against JSON Schema at `base-knowledge/metadata.schema.json`
- [ ] Props follow naming conventions
- [ ] **ALL props have default values (CRITICAL for UI Patterns compatibility)**
- [ ] **Every string prop default is checked: if `len(default) > 128`, `maxLength` is set**
- [ ] Slots are properly defined
- [ ] Props and Slots have unique keys. The keys are not repeated across Props and Slots.
- [ ] Twig template follows SDC patterns
- [ ] CSS follows BEM methodology
- [ ] Accessibility requirements met
- [ ] Responsive design implemented
- [ ] Assets properly referenced

## Assets
List of downloaded assets and their intended use

## Notes
Any special considerations or limitations
```

**Output**: `code-instruction/NN-{component-name}.md`

### Phase 4: SDC Validation (SDC Expert Role)

**Goal**: Ensure instructions follow SDC standards before implementation

**Steps**:
1. Read the instruction file
2. Review against `base-knowledge/single-directory-components.md`
3. Revire against `base-knowledge/metadata.schema.json`
4. Check:
   - Schema structure and types
   - Required vs optional props
   - Slot definitions
   - File naming conventions
   - Library declarations
   - Twig patterns
5. Generate validation report

**Validation Checklist**:
- ✅ Component name follows conventions (lowercase, hyphens)
- ✅ Props schema uses valid JSON Schema types
- ✅ Required props are appropriate
- ✅ **ALL props have default values (REQUIRED for UI Patterns)**
- ✅ **Every string prop: count `len(default)` — if > 128, `maxLength` is set**
- ✅ Enum values are specified where needed
- ✅ Slots have clear purposes
- ✅ Libraries section correctly formatted
- ✅ File structure matches SDC standards
- ✅ BEM methodology planned
- ✅ Accessibility considerations included

**Output**: `code-instruction/NN-sdc-validation-{component-name}.md`

**If validation fails**: Return to Phase 3 to revise instructions

### Phase 5: Implementation (Code Implementer Role)

**Goal**: Create all component files based on validated instructions

**Steps**:

1. **Read Instructions**:
   ```
   Read: code-instruction/NN-{component-name}.md
   ```

2. **Create Directory Structure**:
   ```bash
   mkdir -p web/themes/custom/mytheme/components/{component-name}
   ```

3. **Implement Component YAML**:
   - Copy schema from instructions
   - Add metadata
   - Define libraries if needed
   ```yaml
   $schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
   name: {Component Name}
   status: stable
   description: {Description}
   props:
     # Props schema from instructions
   slots:
     # Slots schema from instructions
   libraryOverrides:  # Only if needed
     dependencies:
       - core/drupal
   ```

4. **Implement Twig Template**:
   ```twig
   {%
     set classes = [
       '{component-name}',
       # Additional classes based on props
     ]
   %}
   <div{{ attributes.addClass(classes) }}>
     {# Implement structure from instructions #}
     {# Use {{ props.propertyName }} for prop values #}
     {# Use {{ slots.slotName }} for slot content #}
   </div>
   ```

5. **Implement CSS**:
   ```css
   /* BEM structure from instructions */
   .{component-name} {
     /* Styles from design tokens */
   }

   .{component-name}__element {
     /* Element styles */
   }

   .{component-name}--modifier {
     /* Modifier styles */
   }

   /* Responsive breakpoints */
   @media (min-width: 768px) {
     /* Tablet styles */
   }
   ```

6. **Implement JavaScript** (if needed):
   ```javascript
   (function (Drupal) {
     'use strict';

     Drupal.behaviors.{componentName} = {
       attach: function (context, settings) {
         // Component behavior
       }
     };
   })(Drupal);
   ```

7. **Move Assets**:
   - Copy downloaded images to component directory
   - Update paths in CSS/templates

**Output**: All component files created

### Phase 6: Testing & Validation (Code Implementer + SDC Expert Roles)

**Goal**: Ensure implementation works and meets standards

**Steps**:

1. **Lint Code**:
   ```bash
   npm run lint
   phpcs web/themes/custom/mytheme/components/{component-name}/
   ```

2. **Validate YAML**:
   - Ensure YAML is valid, see `base-knowledge/metadata.schema.json`
   - Check schema structure
   - Verify types and required fields

3. **Test Template**:
   - Verify Twig syntax
   - Check variable access
   - Test with sample data

4. **SDC Compliance Check**:
   - Review against base-knowledge/single-directory-components.md
   - Verify file structure
   - Check naming conventions
   - Validate schema

5. **Generate Test Report**:
   ```markdown
   # Test Report: {component-name}

   ## Linting: ✅ PASS / ❌ FAIL
   - CSS: {result}
   - JS: {result}
   - PHP: {result}

   ## Schema Validation: ✅ PASS / ❌ FAIL
   - YAML structure: {result}
   - Props types: {result}
   - Slots definition: {result}

   ## SDC Compliance: ✅ PASS / ❌ FAIL
   - File structure: {result}
   - Naming conventions: {result}
   - Twig patterns: {result}

   ## Issues Found
   {List any issues}

   ## Recommendations
   {Suggested improvements}
   ```

**If tests fail**: Fix issues and repeat validation

**Output**: Test report and validated component

### Phase 7: Documentation & Finalization

**Goal**: Document the component and prepare for commit

**Steps**:

1. **Usage Documentation**:
   Create README.md file in the component folder:
   ```markdown
   ## Usage Example

   \`\`\`twig
   {{ include('mytheme:{component-name}', {
     props: {
       color: 'primary',
       size: 'large'
     },
     slots: {
       content: 'Button Text'
     }
   }) }}
   \`\`\`
   ```

2. **Update Project State**:
   - Add component to inventory
   - Update any relevant documentation
   - Note any dependencies or special requirements

3. **Prepare Commit Message**:
   ```
   Add {component-name} SDC component

   - Implemented based on Figma design: {URL}
   - Props: {list key props}
   - Slots: {list slots}
   - Features: {key features}

   Validated against SDC standards and linting passed.

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

4. **Request User Approval**:
   Present summary of:
   - Files created
   - Validation results
   - Usage example
   - Ask permission to commit

**Output**: Ready-to-commit component with documentation

## Error Handling

### Common Issues

**Figma Data Incomplete**:
- Document what's missing
- Request manual input for missing data
- Note limitations in instructions

**SDC Validation Failures**:
- Provide specific violations
- Reference relevant SDC documentation
- Suggest corrections
- Do not proceed to implementation

**Existing Component Conflict**:
- Check for naming conflicts
- Review existing similar components
- Suggest renaming or consolidation
- Consult user before proceeding

**Test Failures**:
- Document exact errors
- Fix and re-validate
- Do not request commit approval until passing

**Missing Dependencies**:
- Identify required libraries
- Check if available in project
- Document in component YAML
- Test library loading

## Best Practices

1. **Always provide default values**: ALL props must have defaults for UI Patterns compatibility
2. **Always read before writing**: Never modify existing files without reading them first
3. **Follow existing patterns**: Match the structure and style of existing components
4. **Validate early**: Check SDC compliance before implementation, not after
5. **Document thoroughly**: Clear instructions prevent implementation errors
6. **Test completely**: All linting and validation must pass
7. **Ask when uncertain**: Better to clarify than implement incorrectly
8. **Security first**: Never commit secrets or sensitive data
9. **Accessibility always**: WCAG compliance is required, not optional

## Workflow Summary

```
User Request → Design Extraction → Research & Analysis → Instruction Generation
    ↓
SDC Validation ← (loop if fails)
    ↓
Implementation
    ↓
Testing & Validation ← (loop if fails)
    ↓
Documentation & Approval
    ↓
Commit (only with user approval)
```

## Time Estimates

Note: Claude Code doesn't provide time estimates. This workflow should be followed step-by-step with validation at each phase.

## Related Workflows

- `research-workflow.md` - For research-only tasks
- `validation-workflow.md` - For validating existing components
- `.claude/instructions/project-context.md` - Overall project context
