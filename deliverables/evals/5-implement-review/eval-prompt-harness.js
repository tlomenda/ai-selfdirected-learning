module.exports = async function ({ vars }) {
  // 1. Define the Outer Base Prompt
  const basePrompt = `
    ## Role
    
    You are a Senior Software Engineer using Promptfoo to evaluate the implementation of a story 
    (code, tests, project structure).

    ## Task
    
    Execute the given implement story prompt and use the output to evaluate the implementation of the story.

    You MUST write the project structure, completion report, implementation details, and 
    all deliverable code source and test files output into a SINGLE detailed markdown file response. 

    ## Context

    **Frontend Coding Guidelines:** {{frontend_code}}
    **Backend Coding Guidelines:** {{backend_code}}
    **Database Coding Guidelines:** {{db_code}}

    ## Constraints

    - All code files must be complete and code represented in a markdown code block
    - Ensure every code file is complete and ready for me to copy-paste.

    - DO NOT split the code into multiple responses or use tools to write actual files
    - DO NOT create a separate file structure, do not truncate code
    - DO NOT use placeholders like '// code goes here'. Write out every file completely

    Every code file follows this exact format:

    File: [folder_name/filename.ext]
    [language]
    [code markdown block]

    ---

    **Implement Story Prompt:**
    {{implement_story_prompt}}
`;

  // 2.Inject the variables into the final prompt
  var finalPrompt = basePrompt.replace("{{implement_story_prompt}}", vars.implement_story_prompt);

  finalPrompt = basePrompt.replace("{{story}}", vars.story);
  finalPrompt = basePrompt.replace("{{technical_plan}}", vars.technical_plan);
  finalPrompt = basePrompt.replace("{{frontend_code}}", vars.frontend_code);
  finalPrompt = basePrompt.replace("{{backend_code}}", vars.implement_backend_codestory_prompt);
  finalPrompt = basePrompt.replace("{{db_code}}", vars.db_code);

  // 3. Return the built prompt object to Promptfoo
  return {
    prompt: finalPrompt,
    config: { temperature: 0.2 },
  };
};
