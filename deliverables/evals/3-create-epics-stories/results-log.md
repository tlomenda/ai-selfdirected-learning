## Notes

## Run History 

### Baseline - Iteration 3 - Jul 7, 2026

```
Haiku score:  14/14 (100%)

Observations:

- Added specific instructions that I wanted complete breakdown of epics and stories with all the details.
- Because the prompt was more specific, the output was more detailed and complete.
- Promptfoo had issues with the "Devin Provider" returning the final output for evaluation. I had to run the prompt directly and write the output to a file. I then used that file as the input for the evaluation (with a custom evaluate-markdown.js provider script).

Gaps closed this exercise: [4]
Gaps accepted (with reasoning): [0]
```

### Baseline - Iteration 2 - Jul 6, 2026

```
Haiku score:  10/14 (71%)

Observations:

- In the task I added the explicit "Return the document as a markdown file so it can be easily copied and reviewed.". This helped the model to return a proper markdown result for the rubrics.

Gaps closed this exercise: [n/a]
Gaps accepted (with reasoning): [n/a]
```

### Baseline - Iteration 1 - Jul 6, 2026

- Refined context with:

```
These given documents (PRD, Architecture Document, and UX Specification) are used to create a comprehensive and detailed breakdown of the epics and user stories to fully implement the product requirements along with the technical and user experience details. These documents describe the scoped product fatures from different perspectives and should be interpreted together.
```

- Added Contstraints:

```
Output structure:

The output should be structured as a markdown file with the following sections:
- Epics and Stories breakdown
- Each Epic should have a summary and a list of stories
- Each story should detailed with a description, summary, dependencies, task breakdown, acceptance criteria, and scope
```

```
Haiku score:  4/14 (28%)

Observations:
- The output was structured and had more detail than last time.



Gaps closed this exercise: [2]
Gaps accepted (with reasoning): [n/a]
```

### Baseline - Jul 6, 2026

```
Haiku score:  2/14 (14%)

Observations:

- No constraints where provided, so the output was not structured and detailed as expected.

Gaps closed this exercise: [n/a]
Gaps accepted (with reasoning): [n/a]
```