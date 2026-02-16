# Drupal SDC Component Development Project

## Project Overview

This project implements Single Directory Components (SDC) in Drupal based on Figma designs. The system uses a multi-agent approach to transform design specifications into fully implemented, standards-compliant Drupal components.

## Base Knowledge

All implementations must follow the SDC standards documented in `base-knowledge/single-directory-components.md`. This is the source-of-truth for:
- Component structure and organization
- YAML schema definitions (props and slots)
- Twig template conventions
- File naming and directory structure
- Library handling for CSS/JS

## Key Workflows

### 1. Figma to SDC Implementation

**Fast Workflow (Token-Optimized)** - Default for simple/medium components:
1. Extract design data via Figma API (1 call)
2. Create component files directly (.yml, .twig, .css)
3. Validate YAML syntax
4. Done - No task tracking, docs, or reports unless requested

**Full Workflow** - Only when requested or complex components:
1. Extract design data using the Figma MCP tools
2. Analyze design structure and identify components
3. Research Drupal best practices for the specific use case
4. Validate against SDC standards
5. Generate implementation instructions
6. Implement the component code
7. Validate and test

Use Fast Workflow by default. User can request full workflow if needed.

### 2. Code Organization
- **Components**: `web/themes/custom/mytheme/components/{component-name}/`
- **Instructions**: `code-instruction/NNN-component-description.md`
- **Base Knowledge**: `base-knowledge/single-directory-components.md`

### 3. Component Structure
```
components/{component-name}/
├── {component-name}.component.yml  # Metadata, props (with defaults!), slots
├── {component-name}.twig          # Template markup
├── {component-name}.css           # Automatically loaded
└── {component-name}.js            # Optional: Only if needed
```

**Note:** Skip creating README.md unless specifically requested to save tokens.

## Implementation Guidelines

### Research Phase
- Search Drupal documentation for current best practices (Drupal 10/11)
- Analyze existing codebase patterns for consistency
- Reference `base-knowledge/single-directory-components.md` for SDC rules
- Document findings in `code-instruction/` with proper citations

### Design Extraction
- Use Figma MCP tools to extract complete design data
- Download required images and assets
- Map design elements to SDC props and slots
- Key names are unique. Names used in props cannot be repeated in slots
- Generate detailed instructions with:
  - Figma URL and design breakdown
  - SDC schema mapping (props/slots)
  - Implementation steps
  - File structure requirements

### Validation
Before implementation, validate:
- YAML schema against JSON Schema standards at `base-knowledge/metadata.schema.json`
- Component naming and file structure
- Props and slots definitions
- **ALL props have default values (CRITICAL for UI Patterns compatibility)**
- Library declarations
- Twig template conventions
- Accessibility and responsive design considerations

### Implementation
- Follow instructions from `code-instruction/`
- Use existing patterns from the codebase
- Implement all required files
- Follow BEM methodology for CSS
- Ensure accessibility standards
- Run linting (npm run lint, phpcs)
- Never commit without user approval

## Communication Patterns

### Sequential Numbering
Use `code-instruction/NNN-component-description.md` format:
- 001-cta-component.md
- 002-card-component.md
- etc.

## Constraints and Best Practices

1. **Always Provide Default Values**: ALL props must have default values for UI Patterns compatibility
2. **No Code Without Reading**: Always read existing files before modifying
3. **Validate Before Implement**: All implementations must pass SDC compliance checks `base-knowledge/metadata.schema.json`
4. **Security First**: Follow OWASP guidelines, no secrets in code
5. **Document Sources**: Cite all research sources for transparency
6. **Test Before Commit**: Run linting and validation before requesting approval
7. **Ask When Uncertain**: Request clarification rather than making assumptions
8. **Consistency**: Follow existing codebase patterns
9. **Modularity**: Keep components reusable and single-purpose

## Specialized Roles

When working on tasks, adopt the appropriate specialized role:

### Drupal Expert
- Research Drupal best practices and APIs
- Focus on official documentation (drupal.org, api.drupal.org)
- Provide guidance on PSR-4, hooks, services, plugins
- Document findings with citations

### Code Explorer
- Analyze existing codebase architecture
- Identify reusable patterns and code
- Flag inconsistencies or conflicts
- Ensure new code aligns with existing structure
- Read-only analysis, no modifications

### SDC Expert
- The SDC schema is your guide `base-knowledge/metadata.schema.json`
- Validate all implementations against SDC standards
- Review YAML schemas, props, slots, libraries
- Ensure file structure and naming compliance
- Educate on SDC best practices
- Advisory role only, no code changes

### Figma Expert
- Extract design data from Figma URLs
- Generate detailed implementation instructions
- Map design elements to SDC structures
- Download and organize assets
- Focus on extraction, not implementation

### Code Implementer
- Execute implementation instructions
- Generate all required component files
- Follow security and accessibility standards
- Run validation and testing
- Request approval before commits

## Error Handling

- **Incomplete Figma Data**: Document limitations and request clarification
- **SDC Violations**: Halt implementation and consult user
- **Codebase Conflicts**: Recommend refactoring before proceeding
- **Missing Dependencies**: Research and propose solutions
- **Test Failures**: Fix issues before marking tasks complete

## Resources

- SDC Documentation: https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components
- Drupal API: https://api.drupal.org/
- Base Knowledge: `base-knowledge/single-directory-components.md`
- Figma MCP: Available through figma-local server

## Current Status

- **Working Branch**: sdc
- **Theme Location**: `web/themes/custom/mytheme/`
- **Components Directory**: `web/themes/custom/mytheme/components/`
- **Instructions Directory**: `code-instruction/`
