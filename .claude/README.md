# Claude Code Configuration for Drupal SDC Development

This directory contains Claude Code configuration for developing Single Directory Components (SDC) in Drupal based on Figma designs.

## Quick Start

### Implement a Figma Design (Fast)

```
You: "Implement this design from Figma. [URL]"
```

Claude will:
1. Extract design data from Figma API
2. Create component files (.yml, .twig, .css)
3. Validate and confirm completion
4. (~10k tokens, ~30 seconds)

### Implement with Full Documentation

```
You: "Implement this design from Figma with full documentation. [URL]"
```

Claude will:
1. Follow complete workflow from `.claude/workflows/figma-to-sdc.md`
2. Create instruction files, test reports, README
3. Task tracking and detailed validation
4. (~75k tokens, ~2 minutes)

## Workflows

### Fast Workflow (Default) - Token Optimized
- **File:** `.claude/workflows/figma-to-sdc-fast.md`
- **Use for:** Simple/medium components, rapid prototyping
- **Token usage:** ~10,000 tokens (~87% savings)
- **Skips:** Task tracking, documentation files, test reports, README
- **Creates:** Component files only

### Full Workflow - Comprehensive
- **File:** `.claude/workflows/figma-to-sdc.md`
- **Use for:** Complex components, team review, documentation needed
- **Token usage:** ~75,000 tokens
- **Creates:** All documentation, instructions, reports

## Configuration

### MCP Servers
- **Figma**: Configured with API key for design extraction
- Falls back to direct Figma REST API if MCP tools unavailable

### Project Files
- **Instructions:** `.claude/instructions/project-context.md`
- **Base Knowledge:** `base-knowledge/single-directory-components.md`
- **Schema:** `base-knowledge/metadata.schema.json`

## Key Principles

1. **Always provide default values** for all props (UI Patterns compatibility)
2. **Use fast workflow by default** unless documentation requested
3. **BEM methodology** for CSS classes
4. **WCAG AA compliance** for accessibility
5. **Mobile-first** responsive design

## Directory Structure

```
.claude/
├── claude.json                    # Main configuration
├── README.md                      # This file
├── instructions/
│   └── project-context.md        # Project-wide context
└── workflows/
    ├── figma-to-sdc-fast.md      # Token-optimized workflow (DEFAULT)
    ├── figma-to-sdc.md           # Comprehensive workflow
    ├── research-workflow.md      # Research-only flow
    └── validation-workflow.md    # Validation-only flow
```

## Component Output Locations

- **Components:** `web/themes/custom/mytheme/components/{name}/`
- **Instructions:** `code-instruction/` (only with full workflow)
- **Base Knowledge:** `base-knowledge/`

## Examples

### Fast Implementation (Recommended)
```
User: "Implement this Figma card design. [URL]"
Claude: [Extracts → Creates files → Validates]
Claude: "✅ Card component created at web/themes/custom/mytheme/components/card/"
```

### With Documentation
```
User: "Implement this with full documentation. [URL]"
Claude: [Full workflow with tasks, instructions, reports]
Claude: [Detailed summary with all files created]
```

### Research Only
```
User: "Research best practices for image carousels in Drupal"
Claude: [Searches, analyzes, documents findings]
```

## Token Usage Comparison

| Workflow | Tokens | Time | Output |
|----------|--------|------|--------|
| Fast | ~10k | 30s | Component files only |
| Full | ~75k | 2min | All docs + component files |

**Recommendation:** Use fast workflow for 90% of components.

## Troubleshooting

### Component Validation Errors
- Ensure all props have `default` values
- Run `drush cr` after component changes
- Check YAML syntax with `python3 -c "import yaml; yaml.safe_load(open('file.yml'))"`

### Figma API Issues
- Check API key in `claude.json`
- Verify Figma file/node permissions
- Claude falls back to REST API if MCP unavailable

### UI Patterns Errors
- All props MUST have defaults
- Clear cache: `vendor/bin/drush cr`
- Check that required props have default values

## Version History

- **v2.0** - Added fast workflow for token optimization
- **v1.0** - Initial Claude Code configuration based on OpenCode.ai setup
