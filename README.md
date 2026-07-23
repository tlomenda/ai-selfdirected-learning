# My AI Self-Directed Learning

## Promptfoo Good Practices

- Always run `promptfoo eval` with `--no-cache` to ensure fresh evaluations

- Use CLI Providers Instead of API Keys

  Before configuring Promptfoo, copy the provider wrapper scripts from **[github.com/improving/promptfoo](https://github.com/improving/promptfoo)** into your project directory alongside your Promptfoo YAML files.

- ??

---

### Questions

Q. Using Promptfoo to Evaluate Prompts that output formats other than Markdown or JSON.

   - Documentation: (word, pdf, pptx, etc)
   - Diagrams/Models: (mermaid, excalidraw, draw.io, lucidchart, etc)

Q. Ways to "speed up" the evaluation process in Promptfoo? Things to watch out for, Rules-of-Thumb, Thresholds (number of assertions, tests, parallelization, etc)

Q. Are there Promptfoo Patterns that can be used to evaluate prompts that output formats other than Markdown or JSON?

---

### Insights from Daniel Scheuffler

He shared some good practices and patterns for using Promptfoo effectively - including a GitHub repo with examples and templated practices.

He also shared a working document on DLP - Embedded Engineer Playbook.

--- 

### My Practices

#### Evaluating Prompts That Results in Code or Multiple Outputs

In these situations a "prompt harness (wrapper prompt)" can be used to evaluate the output. See [./prompts/e5-implement-review/implement/eval-prompt-harness.js](./prompts/e5-implement-review/implement/eval-prompt-harness.js) as an example where code generation is consolidated into a single Markdown file for evaluation and review.

NOTE: another way to handle this is to Run Prompts Outside of Promptfoo and then Evaluate in Promptfoo (see below).

#### Evaluating Prompts Where Model Asks Questions Before Final Output

Generally a prompt with a hard constraint such as "Do NOT make assumptions, ask clarifying questions" will result in the model asking questions before providing a final output. 

In these cases, run Prompts Outside of Promptfoo and then Evaluate in Promptfoo (see below).

#### Running Prompts Outside of Promptfoo First, Then Evaluating in Promptfoo

Sometimes it's necessary to run a prompt outside of Promptfoo first, then evaluate the output in Promptfoo. This is useful when the prompt is complex and needs to be run multiple times with different inputs. In these cases it is often easier to run the prompts, save the outputs, and then evaluate them in Promptfoo.

For Markdown outputs, see [./prompts/evaluate-markdown.js](./prompts/evaluate-markdown.js) as way to inject and evaluate final Markdown output from a prompt.

NOTE: all prompts in [./prompts/](./prompts/) Promptfoo configs show how the `eval-markdown` prompt utility can be used to evaluate Markdown outputs.

