# Claude Code Quick Reference - Drupal SDC Development

Quick reference for using Claude Code with the Drupal SDC configuration.

## Common Commands

### Starting Claude Code

```bash
# From project root
cd /home/yuri/ssd2/project-files/Kalamuna/projects/drupal-11
claude
```

Configuration in `.claude/claude.json` loads automatically.

## Request Templates

### Complete Figma to SDC Implementation

```
Implement this design from Figma. [FIGMA_URL]

Follow the complete workflow:
1. Extract design data
2. Research Drupal patterns
3. Generate implementation instructions
4. Validate against SDC standards
5. Implement the component
6. Test and validate
7. Request approval before committing
```

### Research Only

```
Research how to [SPECIFIC TOPIC] in Drupal SDC components.

Focus on:
- Official Drupal documentation
- Current best practices
- Existing codebase patterns
- Provide recommendations with citations
```

### Validate Existing Component

```
Validate the [COMPONENT-NAME] component against SDC standards.

Check:
- Schema compliance
- File structure
- Twig template patterns
- CSS/JS best practices
- Accessibility and security
```

### Implement from Instructions

```
Implement the component described in code-instruction/[NNN]-[component-name].md

Follow the instructions exactly and validate before requesting approval.
```

### Analyze Codebase

```
Analyze how [SPECIFIC FEATURE] is implemented in the existing codebase.

Review web/themes/custom/mytheme/components/ and document:
- Existing patterns
- Reusable elements
- Naming conventions
- Integration approaches
```

### Create Implementation Instructions

```
Create implementation instructions for a [COMPONENT TYPE] based on this Figma design: [URL]

Generate code-instruction/[NNN]-[component-name].md with:
- Design breakdown
- SDC schema mapping
- Implementation steps
- Validation checklist
```

## Specialized Role Requests

### As Figma Expert

```
Act as Figma Expert: Extract design data from [FIGMA_URL] and generate implementation instructions
```

### As Drupal Expert

```
Act as Drupal Expert: Research best practices for [TOPIC] and provide recommendations
```

### As Code Explorer

```
Act as Code Explorer: Analyze the existing component architecture and identify reusable patterns
```

### As SDC Expert

```
Act as SDC Expert: Validate [COMPONENT] against base-knowledge/single-directory-components.md
```

### As Code Implementer

```
Act as Code Implementer: Implement the component from code-instruction/[FILE].md
```

## Figma MCP Commands

The Figma MCP server provides these tools:

```
# Claude has access to:
- figma-local_get_figma_data: Extract design data
- figma-local_download_figma_images: Download assets
```

Just reference the Figma URL in your request - Claude will use the appropriate tools.

## File Locations

### Configuration
- `.claude/claude.json` - Main configuration
- `.claude/instructions/project-context.md` - Project context
- `.claude/workflows/*.md` - Workflow templates

### Project Files
- `web/themes/custom/mytheme/components/` - Implemented components
- `code-instruction/` - Instructions and reports
- `base-knowledge/single-directory-components.md` - SDC standards
- `assets/figma/` - Downloaded Figma assets

## Component Structure Reference

```
web/themes/custom/mytheme/components/{component-name}/
├── {component-name}.component.yml    # Required: Metadata and schema
├── {component-name}.twig             # Required: Template
├── {component-name}.css              # Optional: Auto-loaded styles
└── {component-name}.js               # Optional: Auto-loaded scripts
```

## YAML Schema Template

```yaml
name: Component Name
status: stable
description: What this component does

props:
  type: object
  required:
    - requiredProp
  properties:
    myProp:
      type: string
      title: My Property
      description: What this controls
      enum: [option1, option2]  # For limited values
      default: option1          # Optional default

slots:
  content:
    title: Content
    description: Main content area
```

## Twig Template Pattern

```twig
{%
  set classes = [
    'component-name',
    props.modifier ? 'component-name--' ~ props.modifier,
  ]
%}
<div{{ attributes.addClass(classes) }}>
  <div class="component-name__element">
    {{ props.title }}
  </div>
  <div class="component-name__content">
    {{ slots.content }}
  </div>
</div>
```

## CSS BEM Pattern

```css
/* Block */
.component-name {
  /* Base styles */
}

/* Element */
.component-name__element {
  /* Element styles */
}

/* Modifier */
.component-name--large {
  /* Variation styles */
}

/* State */
.component-name.is-active {
  /* State styles */
}

/* Responsive */
@media (min-width: 768px) {
  .component-name {
    /* Tablet+ styles */
  }
}
```

## JavaScript Pattern

```javascript
(function (Drupal) {
  'use strict';

  Drupal.behaviors.componentName = {
    attach: function (context, settings) {
      const components = context.querySelectorAll('.component-name');
      components.forEach(function(component) {
        // Component logic
      });
    }
  };
})(Drupal);
```

## Usage Example

```twig
{{ include('mytheme:component-name', {
  props: {
    title: 'My Title',
    color: 'primary'
  },
  slots: {
    content: '<p>Content here</p>'
  }
}) }}
```

## Workflow Selection

| Task | Workflow |
|------|----------|
| Figma → Component | `figma-to-sdc.md` |
| Research topic | `research-workflow.md` |
| Validate component | `validation-workflow.md` |

## Quick Validation Checklist

```
Schema:
☐ Props type=object with properties
☐ Each prop has type, title, description
☐ Required props appropriate
☐ Slots have title, description

Files:
☐ {name}.component.yml exists
☐ {name}.twig exists
☐ Files named correctly
☐ Directory structure correct

Twig:
☐ Uses attributes.addClass()
☐ BEM classes correct
☐ Props via props.name
☐ Slots via slots.name
☐ Semantic HTML
☐ Accessibility attributes

CSS:
☐ BEM methodology
☐ Responsive design
☐ Scoped to component

Security:
☐ No XSS vulnerabilities
☐ Proper escaping
☐ No secrets
```

## Common Pitfalls

### ❌ Don't Do

```yaml
# Wrong: Invalid type
props:
  type: object
  properties:
    count:
      type: integer  # ❌ Use 'number'
```

```twig
{# Wrong: Direct access #}
{{ title }}  {# ❌ Use props.title #}
```

```css
/* Wrong: Not scoped */
.button {  /* ❌ Use .component-name */
  color: red;
}
```

### ✅ Do This

```yaml
# Correct: Valid type
props:
  type: object
  properties:
    count:
      type: number  # ✅ Valid JSON Schema type
```

```twig
{# Correct: Via props #}
{{ props.title }}  {# ✅ Correct access #}
```

```css
/* Correct: Scoped */
.component-name {  /* ✅ Scoped to component */
  color: red;
}
```

## Testing Commands

```bash
# Lint CSS/JS
npm run lint

# PHP CodeSniffer
phpcs web/themes/custom/mytheme/components/

# Git status (before commit)
git status

# Git diff (check changes)
git diff
```

## MCP Server Troubleshooting

### Check if MCP server is configured:

```bash
# View configuration
cat .claude/claude.json
```

### Test Figma MCP manually:

```bash
npx -y figma-developer-mcp --figma-api-key=YOUR_KEY --stdio
```

### Common issues:
- API key invalid → Update in claude.json
- Node.js not installed → Install Node.js
- MCP not loading → Restart Claude Code

## Getting Help

### In Claude Code:

```
# View project context
Show me the project context from .claude/instructions/project-context.md

# View workflow
Show me the workflow for [figma-to-sdc | research | validation]

# Check configuration
What configuration is loaded from .claude/?

# List available MCP tools
What Figma tools are available?
```

### Documentation:

- **SDC Standards**: `base-knowledge/single-directory-components.md`
- **Project Context**: `.claude/instructions/project-context.md`
- **Workflows**: `.claude/workflows/*.md`
- **Configuration**: `.claude/README.md`

### External Resources:

- Drupal SDC: https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components
- Drupal API: https://api.drupal.org/
- Claude Code: https://docs.anthropic.com/claude/docs/claude-code

## Tips & Tricks

### 1. Be Specific

❌ "Make a button"
✅ "Create a button SDC component from this Figma design: [URL]"

### 2. Reference Workflows

❌ "Do the thing"
✅ "Follow the figma-to-sdc workflow for this component"

### 3. Request Validation

✅ "Validate before implementing"
✅ "Check against SDC standards"

### 4. Leverage Roles

✅ "As Code Explorer, analyze existing patterns first"
✅ "As SDC Expert, validate this schema"

### 5. Provide Context

✅ "This component will be used in Layout Builder"
✅ "This needs to work with the existing card component"

### 6. Ask for Citations

✅ "Research with sources"
✅ "Cite Drupal documentation"

### 7. Iterative Validation

✅ "Validate the schema before implementing"
✅ "Test after implementation"

## Keyboard Shortcuts

(Claude Code specific - check Claude Code documentation)

```
Ctrl+C - Cancel current operation
Ctrl+D - Exit Claude Code
↑/↓ - Navigate history
```

## Environment Variables (Optional)

For better security, use environment variables:

```bash
# In your shell profile (.bashrc, .zshrc)
export FIGMA_API_KEY="your-key-here"

# Update .claude/claude.json
"--figma-api-key=${FIGMA_API_KEY}"
```

## Version Info

- Configuration Version: 1.0
- Based on: `.opencode/` configuration
- Claude Model: Sonnet 4.5
- Drupal Version: 10.1+ (SDC built-in from 10.3+)

## Next Steps After Setup

1. Test the configuration:
   ```
   claude
   > "Show me the project context"
   ```

2. Try a simple request:
   ```
   > "Analyze the existing component structure"
   ```

3. Run a complete workflow:
   ```
   > "Implement [FIGMA_URL] following the figma-to-sdc workflow"
   ```

## Support

- Configuration issues: Review `.claude/README.md`
- Workflow questions: Check `.claude/workflows/*.md`
- SDC questions: Read `base-knowledge/single-directory-components.md`
- Claude Code help: `claude --help` or https://docs.anthropic.com/

---

**Last Updated**: 2026-02-08
**Configuration**: `.claude/claude.json`
