# Workflow: Drupal SDC Research

This workflow focuses on researching best practices, patterns, and solutions for SDC component development without implementing code.

## When to Use This Workflow

- Exploring how to implement a feature before starting
- Understanding Drupal APIs and patterns
- Investigating best practices for specific scenarios
- Answering "how should I..." questions
- Learning about SDC capabilities and limitations

## Workflow Steps

### Phase 1: Define Research Scope (User + Orchestrator)

**Goal**: Clearly define what needs to be researched

**Steps**:
1. Identify the research question or goal
2. Determine research areas:
   - Drupal APIs and patterns
   - SDC-specific capabilities
   - Accessibility requirements
   - Performance considerations
   - Security best practices
   - Integration patterns
3. Identify deliverables (report, recommendations, examples)

**Example Research Questions**:
- "How should we implement responsive images in SDC components?"
- "What's the best way to integrate SDC with Layout Builder?"
- "How do we handle dynamic data in SDC components?"
- "What accessibility patterns should we follow for card components?"

**Output**: Clear research objective and scope

### Phase 2: Drupal Documentation Research (Drupal Expert Role)

**Goal**: Gather information from official Drupal sources

**Primary Sources**:
- https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components
- https://api.drupal.org/
- Drupal core change records
- Drupal.org community documentation

**Steps**:
1. Search official Drupal documentation
2. Review relevant API documentation
3. Check change records for recent updates
4. Look for official examples in Drupal core
5. Review coding standards if applicable

**Focus Areas**:
- Current best practices (Drupal 10/11)
- Official API patterns
- Security considerations
- Accessibility requirements
- Performance recommendations

**Output**: Official documentation findings

### Phase 3: Codebase Analysis (Code Explorer Role)

**Goal**: Understand how similar problems are solved in the existing codebase

**Steps**:

1. **Search for Similar Patterns**:
   ```bash
   # Find existing components
   ls web/themes/custom/mytheme/components/

   # Search for specific patterns
   grep -r "pattern" web/themes/custom/mytheme/components/
   ```

2. **Analyze Existing Components**:
   - Review `.component.yml` files for schema patterns
   - Examine Twig templates for markup patterns
   - Check CSS for styling conventions
   - Look at JavaScript for interaction patterns

3. **Identify Reusable Elements**:
   - CSS variables and mixins
   - Twig macros and includes
   - JavaScript utilities
   - Common prop/slot patterns

4. **Document Patterns**:
   - File structure conventions
   - Naming patterns
   - Code organization
   - Dependency patterns

**Output**: Codebase pattern analysis

### Phase 4: Community Research (Drupal Expert Role)

**Goal**: Learn from community solutions and contributed modules

**Sources**:
- Drupal.org project pages
- Contributed modules with SDC examples
- Community discussions and blog posts
- Stack Exchange / Stack Overflow
- GitHub repositories

**Steps**:
1. Search for contributed modules addressing similar needs
2. Review community discussions about the topic
3. Find blog posts or tutorials from trusted sources
4. Check GitHub for example implementations
5. Evaluate quality and currency of sources

**Evaluation Criteria**:
- Is it current (Drupal 10/11)?
- Is the source authoritative?
- Does it follow best practices?
- Is it actively maintained?

**Output**: Community solutions and alternatives

### Phase 5: SDC Standards Review (SDC Expert Role)

**Goal**: Ensure recommendations align with SDC standards

**Steps**:
1. Review `base-knowledge/single-directory-components.md`
2. Check research findings against SDC rules:
   - Schema requirements (props/slots)
   - File structure constraints
   - Naming conventions
   - Library handling
   - Twig template patterns
3. Identify any conflicts or limitations
4. Note SDC-specific considerations

**Key SDC Standards**:
- Props must use JSON Schema types
- Slots for unstructured content
- Auto-loading of `.css` and `.js` files
- Component namespacing
- YAML schema validation
- Twig template requirements

**Output**: SDC compliance notes

### Phase 6: Synthesis & Recommendations

**Goal**: Compile findings into actionable recommendations

**Report Structure**:

```markdown
# Research Report: {Topic}

**Date**: {YYYY-MM-DD}
**Researcher**: {Role}
**Status**: {Draft | Final}

## Research Question

{Clear statement of what we're trying to understand}

## Executive Summary

{2-3 sentence summary of key findings and recommendations}

## Findings

### Official Drupal Best Practices

{What the official documentation recommends}

#### Relevant APIs

- **API Name**: Purpose and how to use
  - Methods: `methodName()` - description
  - Example: Code snippet
  - Source: [Link](URL)

#### Drupal Core Examples

{Examples from core that demonstrate the pattern}

### SDC-Specific Considerations

{How SDC impacts the approach}

- Schema requirements
- File structure implications
- Library handling
- Template patterns

### Existing Codebase Patterns

{How similar problems are solved in our codebase}

- Pattern 1: Description and location
- Pattern 2: Description and location

#### Reusable Elements

- Element: Location and usage
- Element: Location and usage

### Community Solutions

{What the community is doing}

#### Contributed Modules

- **Module Name** ({project-link}): What it does and how it helps
  - Pros: {advantages}
  - Cons: {disadvantages}

#### Alternative Approaches

1. **Approach Name**: Description
   - When to use: {scenarios}
   - Pros: {advantages}
   - Cons: {disadvantages}

## Analysis

### Recommended Approach

{Specific recommendation with rationale}

**Why this approach**:
- Reason 1
- Reason 2
- Reason 3

**Implementation overview**:
1. Step 1
2. Step 2
3. Step 3

### Trade-offs

| Approach | Pros | Cons | Best For |
|----------|------|------|----------|
| Approach A | ... | ... | ... |
| Approach B | ... | ... | ... |

### Alternatives Considered

**Alternative 1: {Name}**
- Description: {what it is}
- Why not: {reasons}

## Implementation Guidance

### Prerequisites

- Required modules or libraries
- Drupal version requirements
- Theme requirements

### File Structure

\`\`\`
{Relevant file structure}
\`\`\`

### Key Code Patterns

\`\`\`yaml
# YAML example if relevant
\`\`\`

\`\`\`twig
{# Twig example if relevant #}
\`\`\`

\`\`\`css
/* CSS example if relevant */
\`\`\`

### Accessibility Considerations

- WCAG requirement 1
- WCAG requirement 2
- Testing approach

### Performance Considerations

- Performance tip 1
- Performance tip 2

### Security Considerations

- Security requirement 1
- Security requirement 2

## Next Steps

1. {Actionable next step}
2. {Actionable next step}
3. {Actionable next step}

## Open Questions

- Question 1: {What we still need to clarify}
- Question 2: {What requires user decision}

## Sources

### Official Documentation
- [Title](URL) - Description
- [Title](URL) - Description

### Community Resources
- [Title](URL) - Description

### Code References
- File: `path/to/file.ext` - What it demonstrates

## Appendix

### Related Research
- {Links to related research reports}

### Additional Examples
{Extended code examples or detailed explanations}
```

**Output**: Comprehensive research report in `code-instruction/drupal-research-{topic}.md`

## Research Best Practices

### 1. Prioritize Official Sources
- Always start with Drupal.org official documentation
- Reference API documentation for technical details
- Check change records for recent updates
- Official docs trump community solutions

### 2. Verify Currency
- Focus on Drupal 10/11 information
- Flag deprecated approaches
- Note version-specific differences
- Check when sources were last updated

### 3. Document Everything
- Cite all sources with URLs
- Include code examples with context
- Note version requirements
- Record date of research

### 4. Consider Context
- How does it fit our codebase?
- Does it align with our patterns?
- What's the learning curve?
- What's the maintenance burden?

### 5. Think Holistically
- Accessibility implications
- Performance impact
- Security considerations
- Maintainability
- Developer experience

### 6. Provide Options
- Present multiple viable approaches
- Explain trade-offs clearly
- Recommend a default option
- Let users make informed decisions

## Example Research Flows

### Example 1: Component Integration

**Question**: "How should we integrate SDC components with Layout Builder?"

**Steps**:
1. Research Layout Builder plugin API
2. Review SDC Layout Builder integration docs
3. Analyze existing Layout Builder plugins in codebase
4. Find contrib modules that bridge SDC and Layout Builder
5. Document approaches with pros/cons
6. Recommend approach with implementation guide

### Example 2: Responsive Patterns

**Question**: "What's the best way to handle responsive images in SDC?"

**Steps**:
1. Review Drupal's Responsive Image module docs
2. Study SDC schema capabilities for image props
3. Check how core components handle images
4. Analyze existing image handling in our components
5. Research accessibility requirements for images
6. Provide responsive image pattern with examples

### Example 3: Dynamic Data

**Question**: "How do we fetch and display dynamic data in SDC components?"

**Steps**:
1. Research Drupal's data fetching patterns (services, controllers)
2. Review SDC limitations (components are render-time)
3. Study preprocessor and template patterns
4. Analyze existing dynamic components
5. Document approaches (preprocessors, custom plugins, etc.)
6. Recommend pattern with security considerations

## Common Research Topics

### SDC Architecture
- Component composition patterns
- Nesting strategies
- Shared dependencies
- Library management

### Data Handling
- Props vs slots decisions
- Schema design patterns
- Default values
- Validation

### Integration Patterns
- Blocks
- Fields
- Paragraphs
- Layout Builder
- Views

### Styling Approaches
- CSS architecture
- Theme integration
- Design tokens
- Responsive patterns

### JavaScript Integration
- Drupal behaviors
- Component lifecycle
- Progressive enhancement
- Third-party libraries

### Accessibility
- ARIA patterns
- Keyboard navigation
- Screen reader support
- Focus management

### Performance
- Asset optimization
- Lazy loading
- Caching strategies
- Critical CSS

## Research Checklist

Before completing research:

- [ ] Consulted official Drupal documentation
- [ ] Reviewed SDC-specific docs
- [ ] Checked API documentation
- [ ] Analyzed existing codebase patterns
- [ ] Reviewed community solutions
- [ ] Validated against SDC standards
- [ ] Considered accessibility
- [ ] Considered performance
- [ ] Considered security
- [ ] Cited all sources
- [ ] Provided code examples
- [ ] Recommended specific approach
- [ ] Documented trade-offs
- [ ] Listed next steps
- [ ] Flagged open questions

## Output Location

All research reports should be saved to:
```
code-instruction/drupal-research-{topic-slug}.md
```

## Related Workflows

- `figma-to-sdc.md` - Full implementation workflow that includes research phase
- `validation-workflow.md` - For validating research recommendations
- `.claude/instructions/project-context.md` - Overall project guidelines
