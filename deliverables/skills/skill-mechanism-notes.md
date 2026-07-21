Devin's skill mechanism is documented in the CLI docs under extensibility/skills. Here's a brief summary:

## Skill discovery and loading

Skills are loaded from SKILL.md files inside named directories under 

project-specific paths like: 
- .devin/skills/<name>/SKILL.md 
- .windsurf/skills/<name>/SKILL.md

as well as global paths such as:
 - ~/.config/devin/skills/<name>/SKILL.md
 - ~/.codeium/<channel>/skills/<name>/SKILL.md. 
 
 The directory name becomes the skill's identifier used for slash-command invocation.


## How the model decides to invoke a skill

A skill can be triggered by the user (/skill-name) or by the model itself when triggers: model is set (the default is both user and model). The model uses the skill's name and description frontmatter to decide whether the skill is relevant to the current context, and injects the skill's prompt content into the conversation when invoked.


## Signals that influence triggering

The main signals are the directory name (used for /skill-name), the name field, and especially the description, which is shown in completions and helps the model match the skill to the task. Other frontmatter fields like triggers, allowed-tools, model, subagent, and permissions further constrain when and how a skill runs.


## Observing skill invocations

You can list and inspect skills with devin skills list, devin skills show <name>, and devin skills paths, and filter by trigger type with devin skills list --trigger user|model. The documentation does not mention a dedicated audit log of skill invocations, so the primary observability is via the CLI listings and the visible /skill-name calls in the conversation.