module.exports = async function ({ vars }) {

  const renderTemplate = (template, values) => {
    const coding_guidelines = values.frontend_code + "\n\n" + values.backend_code + "\n\n" + values.db_code;
    return template
      .replace(/{{tech_stack}}/g, values.tech_stack)
      .replace(/{{story}}/g, values.story)
      .replace(/{{technical_plan}}/g, values.technical_plan)
      .replace(/{{coding_guidelines}}/g, coding_guidelines);
  };
 
  const implementStoryPrompt = renderTemplate(vars.implement_story_prompt, vars);
 
  // 1. Define the Harness Prompt with containing the implement story prompt + coding guidelines
  const harnessPrompt = `
    Execute the given Implement Story Prompt.

    **IMPORTANT:** 
    You MUST write the project structure, completion report, implementation details, and 
    all deliverable code source and test files output into a SINGLE detailed markdown file response. The
    SINGLE markdown file will contain the following sections:
    1. Project Structure
    2. Completion Report
    3. Implementation Details
    4. Code Block for All Code Source and Test Files (each with File: header, and language tag)

    **CODE BLOCK SPECIFICATIONS:**
    - All code must be complete and code represented in a markdown code block
    - Ensure every code block is complete and ready for me to copy-paste.

    - DO NOT split the code into multiple responses or use tools to write actual files
    - DO NOT create a separate file structure, do not truncate code
    - DO NOT use placeholders like '// code goes here'. Write out every code block completely

    - Every code file follows this exact format:
      File: [folder_name/filename.ext]
      [language]
      [code markdown block]

    ---

    **Implement Story Prompt:**
    ${implementStoryPrompt}
  `;

  // 3. Return the built prompt object to Promptfoo
  return {
    prompt: harnessPrompt,
    config: { temperature: 0.2 },
  };
};
