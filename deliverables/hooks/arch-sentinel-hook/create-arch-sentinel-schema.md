## ARCHITECTURE Sentinel File Schema

### Purpose
This sentinel file is a **structural and basic completeness gate** that runs immediately after the create-architecture.md prompt completes. It catches obvious failures (missing sections, insufficient content, malformed markdown) before the output is passed to promptfoo for detailed rubric evaluation. The hook uses this schema to:

- Verify all required sections are present and in the correct order
- Halt the workflow if critical sections are missing or empty

This is a **fast, deterministic check** that prevents obviously broken ARCHITECTURE documents from reaching the evaluation layer.

### Schema
```json
{
  "sections_present": ["High-Level Architecture", "System Context Map", "System Breakdown using C4 Modeling", "Conceptual DB Design", "Integrations", "Security Considerations"],
  "word_count": 1000,
  "has_system_context_map": true,
  "has_c4_system_context_diagram": true,
  "has_c4_container_diagram": true,
  "has_c4_component_diagram": true,
  "has_flow_diagram": true,
  "has_integrations": true,
  "has_integration_patterns": true,
  "has_quality_attributes": true,
  "has_deployment": true,
  "has_security_considerations": true,
  "has_architecture_decisions": true
}

```

### Required Properties
| Property | Type | Required Value | On Failure |
|----------|------|---------------|------------|
| sections_present | array | must include all sections | **halt workflow** |
| word_count | number | ≥ 1000 words | **warn** (allow continuation, but flag for review) |
| has_system_context_map | boolean | true | **halt workflow** |
| has_c4_system_context_diagram | boolean | true | **halt workflow** |
| has_c4_container_diagram | boolean | true | **halt workflow** |
| has_c4_component_diagram | boolean | true | **halt workflow** |
| has_flow_diagram | boolean | true | **halt workflow** |
| has_integrations | boolean | true | **halt workflow** |
| has_integration_patterns | boolean | true | **halt workflow** |
| has_quality_attributes | boolean | true (attributes: performance, reliability, availability, scalability, maintainability) | **halt workflow** |
| has_deployment | boolean | true | **halt workflow** |
| has_security_considerations | boolean | true | **halt workflow** |
| has_architecture_decisions | boolean | true | **halt workflow** |

### What This Does NOT Validate
This sentinel file **cannot and should not** validate:

1. **Quality of content** — Whether the High Level Architecture is well-written, clear, and comprehensive. Promptfoo handles this with LLM-rubric assertions.

2. **Completeness of architecture** — Whether all required diagrams are present and correctly formatted. This is validated by the sentinel file.

3. **Quality of architecture diagrams** — Whether the C4 diagrams are clear, well-labeled, and follow C4 modeling conventions. This is validated by the sentinel file.

4. **Quality of integration patterns** — Whether the integration patterns are well-defined, clear, and follow best practices. This is validated by the sentinel file.

6. **Quality of quality attributes** — Whether the quality attributes are well-defined, measurable, and aligned with the system's goals. This is validated by the sentinel file.

7. **Quality of deployment considerations** — Whether the deployment considerations are well-defined, clear, and follow best practices. This is validated by the sentinel file.

8. **Quality of security considerations** — Whether the security considerations are well-defined, clear, and follow best practices. This is validated by the sentinel file.

9. **Quality of architecture decisions** — Whether the architecture decisions are well-defined, clear, and follow best practices. This is validated by the sentinel file.