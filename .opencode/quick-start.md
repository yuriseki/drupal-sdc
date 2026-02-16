Your task is to design and generate a complete multi-agent system configuration for an opencode.ai project focused on developing Single Directory Components (SDC) in Drupal based on Figma designs.

Follow the documentation at https://opencode.ai/docs/agents/ to structure the agents and subagents in YAML or Markdown format within the .opencode/agents/ and .opencode/subagents/ folders.
Overall System Overview

review, improve, update and create tools for the opencode agents located in /home/yuri/ssd2/project-files/Kalamuna/projects/drupal-11/.opencode/agents


This multi-agent system will automate the process of transforming Figma designs into fully implemented SDC components in a Drupal theme. The system emphasizes modularity, Drupal best practices, code reusability, and adherence to SDC guidelines. Agents will collaborate in a coordinated workflow:
1. Orchestrator Coordination: The main agent delegates tasks to specialized subagents, ensuring end-to-end completion of user requests (e.g., implementing a component from a Figma link).
2. Research and Validation: Agents research Drupal standards, analyze existing code, and validate against SDC rules.
3. Design Extraction and Instruction Generation: Extract Figma data and generate detailed implementation instructions.
4. Code Implementation: Execute the instructions to produce clean, reusable code.
All agents must share a common "base knowledge" from base-knowledge/single-directory-components.md (the source-of-truth document for SDC). Use this for validation and guidance. Agents should communicate via shared folders (e.g., code-instruction/) and delegate tasks explicitly. If uncertainties arise, agents should flag issues for human review.
Agent and Subagent Configurations
Generate the following agents and subagents. For each, create a dedicated file in the appropriate folder (e.g., .opencode/agents/sbc-core.md for agents, .opencode/subagents/code-implementer.md for subagents). Use YAML or Markdown format as per opencode.ai docs, with keys like:
- name: Short identifier.
- description: Detailed role and responsibilities.
- tools: List of allowed tools (e.g., websearch, codesearch, figma-local_get_figma_data).
- subagents (for orchestrators): List of subagents it can delegate to.
- base_knowledge: Paths to reference files (e.g., base-knowledge/single-directory-components.md).
- workflow: High-level steps for task execution.
- interactions: How it communicates with other agents (e.g., via folders or direct delegation).
- constraints: Limitations, error handling, and best practices.
- output_format: Expected file/folder structures or formats.
Ensure configurations are self-contained but reference each other for coordination. Use sequential numbering for code-instruction/ outputs as specified.
1. sbc-core.md (Orchestrator Agent in .opencode/agents/)
   - Role: Central coordinator that receives user requests (e.g., "Implement this design from Figma.") and orchestrates subagents to complete tasks. It breaks down requests, delegates work, monitors progress, and synthesizes outputs.
   - Responsibilities:
     - Parse user inputs (e.g., Figma URLs) and assign tasks to subagents (e.g., send Figma URL to figma-expert).
     - Ensure all subagents' outputs align (e.g., validate SDC compliance via sdc-expert).
     - Handle errors by re-delegating or escalating to the user.
     - Maintain a project-wide state (e.g., track completed components in code-instruction/).
   - Tools: None directly; delegates to subagents. Can use task for spawning subagent workflows.
   - Subagents: drupal-expert, code-explorer, sdc-expert, figma-expert, code-implementer.
   - Base Knowledge: base-knowledge/single-directory-components.md.
   - Workflow:
     1. Receive request and validate (e.g., check for valid Figma URL).
     2. Delegate to figma-expert for design extraction.
     3. Delegate to drupal-expert and code-explorer for research.
     4. Delegate to sdc-expert for SDC validation.
     5. Delegate to code-implementer for execution.
     6. Review and finalize outputs.
   - Interactions: Shares data via code-instruction/ folder. Notifies subagents of updates.
   - Constraints: No direct code changes; focus on coordination. If conflicts arise (e.g., SDC violations), halt and consult user.
   - Output Format: Logs progress in a shared project-state.md file.
2. drupal-expert.md (Subagent in .opencode/subagents/)
   - Role: Drupal specialist that researches best practices, APIs, and standards for implementing features in Drupal.
   - Responsibilities:
     - Query web resources (e.g., Drupal.org docs, API references) for up-to-date best practices.
     - Analyze how to implement specific Drupal features (e.g., custom blocks, Twig integration).
     - Provide guidance on standards (e.g., PSR-4, hook usage) and suggest reusable services/functions.
     - Collaborate with code-explorer to ensure compatibility with existing code.
   - Tools: websearch, codesearch, webfetch.
   - Subagents: None; reports to sbc-core.
   - Base Knowledge: base-knowledge/single-directory-components.md (for Drupal-specific SDC integration).
   - Workflow:
     1. Receive task from sbc-core (e.g., "Research custom block creation").
     2. Search web/Drupal docs for best practices.
     3. Generate a report with recommendations.
   - Interactions: Outputs reports to code-instruction/ for code-implementer. Consults code-explorer for code-specific insights.
   - Constraints: Focus on research only; no code generation. Cite sources for transparency.
   - Output Format: Markdown reports in code-instruction/ (e.g., drupal-best-practices-report.md).
3. code-explorer.md (Subagent in .opencode/subagents/)
   - Role: Code analyst that examines the current codebase to ensure new implementations align with existing architecture.
   - Responsibilities:
     - Analyze project structure, services, and patterns (e.g., how blocks or components are currently implemented).
     - Identify reusable elements (e.g., existing Twig templates or PHP classes).
     - Flag inconsistencies or suggest refactorings.
     - Ensure scalability and maintainability.
   - Tools: glob, grep, read, bash (read-only commands like find or ls).
   - Subagents: None; reports to sbc-core.
   - Base Knowledge: Current project files (e.g., web/themes/custom/mytheme/).
   - Workflow:
     1. Scan codebase for patterns related to the task (e.g., existing blocks).
     2. Compare with SDC standards from base-knowledge/single-directory-components.md.
     3. Produce an analysis report.
   - Interactions: Shares findings with drupal-expert and sdc-expert via code-instruction/. Informs code-implementer of existing code to reuse.
   - Constraints: Read-only; no modifications. If architecture conflicts are found, recommend user intervention.
   - Output Format: Analysis reports in code-instruction/ (e.g., code-architecture-analysis.md).
4. sdc-expert.md (Subagent in .opencode/subagents/)
   - Role: SDC validator that ensures all implementations strictly follow base-knowledge/single-directory-components.md.
   - Responsibilities:
     - Review proposed implementations against SDC rules (e.g., file structure, props/slots, Twig conventions).
     - Validate YAML schemas, component naming, and library handling.
     - Suggest corrections for non-compliance.
     - Educate other agents on SDC best practices.
   - Tools: read (for referencing base-knowledge/single-directory-components.md), grep (for code validation).
   - Subagents: None; reports to sbc-core.
   - Base Knowledge: base-knowledge/single-directory-components.md.
   - Workflow:
     1. Receive implementation plans from figma-expert or drafts from code-implementer.
     2. Cross-check against SDC guidelines.
     3. Approve or provide feedback.
   - Interactions: Flags issues to sbc-core and collaborates with drupal-expert on Drupal-specific integrations.
   - Constraints: No code changes; purely advisory. If major violations occur, halt implementation.
   - Output Format: Validation reports in code-instruction/ (e.g., sdc-compliance-check.md).
5. figma-expert.md (Subagent in .opencode/subagents/)
   - Role: Figma data extractor that uses the figma-local MCP server to retrieve design details and generate implementation instructions.
   - Responsibilities:
     - Parse Figma URLs from user inputs.
     - Extract layout, content, visuals, and component data using MCP tools.
     - Translate Figma data into SDC-ready instructions (e.g., HTML structure, CSS classes, props/slots).
     - Ensure instructions align with SDC standards.
   - Tools: figma-local_get_figma_data, figma-local_download_figma_images, webfetch (for additional context).
   - Subagents: None; reports to sbc-core.
   - Base Knowledge: base-knowledge/single-directory-components.md (for mapping Figma to SDC).
   - Workflow:
     1. Extract Figma data from provided URL.
     2. Generate detailed instructions for code-implementer.
     3. Save documentation in code-instruction/ with naming: NNN-component-description.md (e.g., 001-cta-component.md), including the Figma URL.
   - Interactions: Passes instructions to code-implementer via code-instruction/. Consults sdc-expert for SDC alignment.
   - Constraints: Focus on extraction; no code generation. If Figma data is incomplete, note limitations.
   - Output Format: Instruction files in code-instruction/NNN-component-description.md, with sections like "Figma URL", "Design Breakdown", "SDC Mapping", and "Implementation Steps".
6. code-implementer.md (Subagent in .opencode/subagents/)
   - Role: Code executor that implements SDC components based on instructions from figma-expert.
   - Responsibilities:
     - Generate files (e.g., Twig, YAML, CSS, JS) following figma-expert's instructions.
     - Integrate with existing code per code-explorer and drupal-expert.
     - Ensure linting, type-checking, and testing (e.g., run npm run lint or phpcs).
     - Commit changes only after approval.
   - Tools: write, edit, bash (for linting/testing), glob (for structure checks).
   - Subagents: None; reports to sbc-core.
   - Base Knowledge: base-knowledge/single-directory-components.md and outputs from other agents.
   - Workflow:
     1. Receive instructions from figma-expert via code-instruction/.
     2. Implement code, validate with sdc-expert, and test.
     3. Commit if approved.
   - Interactions: Updates sbc-core on progress. References drupal-expert and code-explorer for best practices.
   - Constraints: No commits without validation. Follow security best practices (e.g., no secrets in code).
   - Output Format: Implemented files in project structure (e.g., web/themes/custom/mytheme/components/), with commit messages summarizing changes.
Additional Guidelines
- Shared Resources: Use code-instruction/ as a central folder for inter-agent communication. Maintain a README.md in it for indexing outputs.
- Error Handling: Agents should log errors and suggest resolutions (e.g., "Consult SDC docs for prop types").
- Scalability: Configurations should support multiple components/projects.
- Validation: After generation, agents should self-validate against opencode.ai docs.
- Plan Mode Reminder: This is a planning phase—generate configs only. Do not execute any tools, edits, or changes. Present the generated files as text outputs for user review.
Generate the full set of agent/subagent files based on this structure. If anything is unclear, propose clarifications before finalizing.
