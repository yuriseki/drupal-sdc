# Figma to Drupal Single Directory Components Converter

This project develops a multi-agent system within the OpenCode framework to automate the extraction of components from Figma designs and transform them into Drupal Single Directory Components (SDCs). By leveraging the Figma API, AI-powered agents, and coordinated workflows, the project streamlines the design-to-implementation pipeline for Drupal 11, ensuring design-code parity, reusability, and adherence to SDC standards.

## Project Goal

To create a suite of autonomous agents that collaboratively:
- Extract component data from Figma files using the Figma REST API and MCP tools
- Parse design tokens, layouts, properties, and assets
- Generate fully compliant Drupal SDC structures (YAML, Twig, CSS, JS)
- Validate implementations against SDC guidelines and Drupal best practices
- Maintain a modular, scalable architecture for future enhancements

## Features

- **Multi-Agent Coordination**: Orchestrated workflow with specialized subagents for research, extraction, validation, and implementation
- **Figma Integration**: Automated extraction via Figma API and local MCP server
- **Design Token Extraction**: Parse colors, typography, spacing, and component variants
- **Automatic SDC Generation**: Create compliant component.yml, template.twig, styles.css, and script.js files
- **Props and Slots Support**: Handle dynamic content and component variations
- **Validation and Testing**: Built-in SDC compliance checks, linting, and Drupal integration testing
- **Inter-Agent Communication**: Shared `code-instruction/` folder for seamless collaboration

## Architecture

The system is built on the OpenCode framework and consists of:

- **sbc-core**: Primary orchestrator agent that manages the end-to-end workflow, delegates tasks, and ensures coordination
- **Subagents**:
  - **figma-expert**: Extracts design data and generates implementation instructions
  - **drupal-expert**: Researches Drupal best practices and APIs
  - **code-explorer**: Analyzes existing codebase for patterns and reusability
  - **sdc-expert**: Validates implementations against SDC standards
  - **code-implementer**: Executes code generation based on instructions

All agents reference `base-knowledge/single-directory-components.md` as the source-of-truth for SDC rules and collaborate via the `code-instruction/` directory for shared reports and instructions.

## Multi-Agent Workflow

1. **Request Intake**: User provides a Figma URL; sbc-core validates and delegates to figma-expert
2. **Design Extraction**: figma-expert extracts data and creates instruction files in `code-instruction/`
3. **Research & Analysis**: sbc-core delegates to drupal-expert and code-explorer for context
4. **Validation**: sdc-expert reviews plans against SDC standards
5. **Implementation**: code-implementer generates code, with final validation and user approval

This coordinated approach ensures quality, consistency, and error handling at each step.

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd drupal-11
   ```

2. Install dependencies:
   ```bash
   composer install
   ```

3. Set up the OpenCode environment (refer to OpenCode documentation)

4. Configure Figma API access token and MCP server (see Figma API docs)

5. Ensure `base-knowledge/single-directory-components.md` is populated with SDC guidelines

## Usage

Invoke the system via the sbc-core agent with a Figma component URL:

```
@sbc-core implement-component --figma-url https://www.figma.com/file/... --component-id ...
```

The agents will autonomously:
1. Extract Figma data
2. Research and analyze existing code
3. Validate against SDC standards
4. Generate and implement the SDC component
5. Request user approval for commits

Monitor progress via the `code-instruction/` folder, where agents log instructions, reports, and validation results.

## References

### Drupal Single Directory Components
- [Using Single-Directory Components | Drupal.org](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components)
- [How to Convert Regular Components into Single Directory Components](https://evolvingweb.com/blog/how-convert-regular-components-single-directory-components)

### Figma Integration
- [Figma REST API Documentation](https://www.figma.com/developers/api)
- [Anima (Figma to Code)](https://www.animaapp.com/)
- [TeleportHQ (Figma Plugin)](https://teleporthq.io/figma-export-to-html-plugin)

### Conversion Guides
- [Complete Guide: Figma MCP + Cursor + Drupal 11 UI Patterns Workflow](https://www.bonnici.co.nz/blog/figma-mcp-cursor-drupal-workflow)
- [Generating Drupal Components with Figma and AI](https://pgm-2425-itexploration.github.io/syllabus/tutorials/cms/drupal-figma-mcp.html)
- [Figma to Drupal Canvas in 4 Minutes](https://www.youtube.com/watch?v=Ml3csokdvW8)
- [From Figma to Drupal: Building Design Systems that Scale](https://www.mindsing.com/blog/design-experience/figma-to-drupal-design-systems)
- [Figma to Drupal Conversion: A Step-by-Step Guide](https://www.thedroptimes.com/42407/figma-drupal-conversion-step-step-guide-developers)

### OpenCode Framework
- Refer to `.opencode/` directory for agent configurations and tools

## Contributing

1. Follow OpenCode agent creation standards
2. Test agents against sample Figma files and Drupal installations
3. Ensure SDC compliance via sdc-expert validation
4. Update `base-knowledge/` with new guidelines or examples
5. Contribute to the `code-instruction/` workflow documentation

## License

This project is licensed under the GPL-2.0-or-later (same as Drupal).

## Roadmap

- [x] Develop multi-agent system (sbc-core orchestrator and subagents)
- [x] Implement Figma API integration (figma-expert)
- [x] Create SDC validation and compliance checking (sdc-expert)
- [ ] Enhance design token parsing for complex variants
- [ ] Add automated testing integration (e.g., Drupal test suites)
- [ ] Support for Layout Builder block generation (block-implementer extension)
- [ ] Expand to full design system synchronization