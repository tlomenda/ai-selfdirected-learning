# Create Architecture

## Role
You are a Senior Solutions Architect who produces clear, implementation-ready architecture documents.

## Task
Given a PRD, write an Architecture Document describing the technical approach for implementing the described system or application. 

Return the document as a markdown file so it can be easily copied and reviewed.

## Context

The architecture document, commonly known as a Solution Design Document (SDD), is a technical document that describes how a system or application will be designed. It uses the PRD as a foundation on what needs to be built and provides an architectural blueprint that guides the development process.

It models the system using C4 modeling approach - a developer-friendly framework and lightweight standard for visualizing and documenting software architecture. it also leverages Domain-Driven Design (DDD) principles to ensure the architecture aligns with business domains and bounded contexts.

The architecture document will be used by technical leads, architects, and development team to understand how everything fits together - services, components, containers, modules, databases, APIs and integrations - without choosing specific tools.

To be a useful document, architecture diagrams (C4, DDD Context Map, ERD, Data Flow) using mermaid syntax markdown blocks are to be included.

This document includes:
- High-Level Architecture
- System Context Map
- System Breakdown using C4 modeling
    - Context Diagrams
    - Container Diagrams
    - Component Diagrams
- Conceptual DB Design
    - Entity-Relationship Diagrams (ERDs)
    - Data Flow Diagrams
- Integrations - internal and external systems and services
  - API Interface Overview
  - Integration Pattern for external systems
- Security Considerations

The document also addresses quality attributes - known as '*-bilities' - based on the non-functional requirements from the PRD. These qualities may include:
- Operational: Scalability, Reliability, Performance, Security
- Development: Maintainability, Extensibility, Deployability, Portability
- System: Modularity

Consider key architectural decisions (ADRs), trade-offs, or areas that require further clarification.

## Constraints

- DO NOT just provide an architectural summary, ALSO include diagrams and details explaining the architecture.

- The Product Description and PRD MUST BE used as the primary source of information for the architecture.

- Tech Stack MUST BE used as the primary technology stack for the architecture (replacing any technology choices from the PRD or product description).

---

After producing the ARCHITECTURE document, write a file called `arch-sentinel.json` in the same directory as instructed to write the ARCHITECTURE document. The file must contain:

- `sections_present`: an array of the section names that appear in the ARCHITECTURE output
- `word_count`: the approximate word count of the ARCHITECTURE body
- `has_system_context_map`: true if the ARCHITECTURE contains a system context map; false otherwise
- `has_c4_system_context_diagram`: true if the ARCHITECTURE contains a C4 system context diagram; false otherwise
- `has_c4_container_diagram`: true if the ARCHITECTURE contains a C4 container diagram; false otherwise
- `has_c4_component_diagram`: true if the ARCHITECTURE contains a C4 component diagram; false otherwise
- `has_flow_diagram`: true if the ARCHITECTURE contains a flow diagram; false otherwise
- `has_integrations`: true if the ARCHITECTURE contains integrations; false otherwise
- `has_integration_patterns`: true if the ARCHITECTURE contains integration patterns; false otherwise
- `has_quality_attributes`: true if the ARCHITECTURE contains quality attributes (performance, reliability, availability, scalability, maintainability); false otherwise
- `has_deployment`: true if the ARCHITECTURE contains deployment; false otherwise
- `has_security_considerations`: true if the ARCHITECTURE contains security considerations; false otherwise
- `has_architecture_decisions`: true if the ARCHITECTURE contains architecture decisions; false otherwise

---

**Product Description:**
{{product_description}}

**PRD:**
{{product_prd}}

**Tech Stack:**
{{tech_stack}}

---

