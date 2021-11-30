var bnfgen = require('bnfgen');

// Parse and load a grammar
bnfgen.loadGrammar(' <start> ::= <modified_competency>{20} ; <modified_competency> ::=  <process> ' ' <object_choice> ' ' <notation_object>{0,1} '.' <line_break> ; <process> ::= <formal_process> | <knowledge> ;<knowledge> ::= <knowledge_process> ' by'  <knowledge_subprocess> ;<object_choice> ::= <mathOp_object> | <specific_object> ;<mathOp_object> ::= <math_operation> ' ' <object> ;<formal_process> ::=  'read'  |  'recite'  |  'write'  |  'represent' ' '  'with'  ' ' <representation>  |  'randomly sample' ;<representation> ::= <models> | <realia> | <glyphs> ;<models> ::=  'images'  |  'sounds' |  'activities' ;<realia> ::=  'specimens'  |  'body parts' ;<glyphs> ::=  'words'  |  'symbols'  |  'drawings'  |  'graphs' ;<knowledge_process> ::=  'identifying'  |  'describing'  |  'comparing'  |  'understanding'  |  'representing'  |  'applying'  |  'relating'  |  'analyzing'  |  'interpreting'  |  'extending'  |  'classifying'  | 'measuring' |  'iterating'  |  'solving'  |  'converting'  |  'reasoning'  |  'computing'  |  'approximating'  |  'estimating'  | 'inferring' | 'grouping' |  'strategizing'  | 'explaining' |  'constructing' ; <knowledge_subprocess> ::=  ' putting together' | ' adding to' | ' taking apart' | ' taking from' ; <math_operation> ::=  'naming'  |  'sequencing'  |  'ordering'  |  'adding'  |  'subtracting' |  'multiplying'  |  'dividing'  |  'negating'  |  'exponentiating'  |  'grouping' ; <object> ::=  'Numbers' | 'Numerical Expressions' | 'Numerical Equations' | 'Terms' | 'Properties of Objects' | 'Properties of math_operations' | 'Patterns' | 'Factors' | ' Common Factors ' | 'Multiples' |'Common Multiples' | 'Place Value' | 'Attributes' | 'Standard Units' | 'SI Units' | 'Area' | 'Data' | 'Angles' | 'Volume' | 'Shapes' | 'Surface Area' | 'Realia' | 'Models' | 'Congruence' | 'Similarity' | 'Ratios' | 'Proportions' | 'Algebraic Expressions' | 'Variables' | 'Numerical Inequalities' | 'Algebraic Equations' | 'Lines' | 'Linear Equations' | 'Simultaneous Equations' | 'Functions' | 'Statistical Variability' | 'Distributions' | 'Populations' | 'Chance Processes' | 'Probability Models' | 'Bivariate Data' | 'Sets' | 'Elements' | 'Experiments' | 'Observations' | 'Dependent Variables' | 'Independent Variables' | 'Sum' | 'Difference' | 'Product' | 'Quotient' | 'Remainder' | 'Groups' | 'Length' | 'Width' | 'Depth or Height' | 'Qualitative Attributes' | 'Arrays' | 'Plane Figures' | 'Objects in Space' | 'Sample' | 'Random Sample' | 'Prisms and Cylinders' | 'Spheres' | 'Cones' | 
'Quantitative Stories' ; <specific_object> ::=  'Pythagorean Formula'  |  'Standard Algorithm for Multiplication' ; <scope_object> ::=   'Whole Numbers'   <sub_scope>  |  'Integers'  |  'Unit Fractions'  |  'Rational Numbers'  |  'Real Numbers'  |  'Imaginary Numbers'  |  'Complex Numbers'  |  'Vectors'  |  'Matrices'  |  'Infinite Numbers'  |  'Random Numbers'  |  'Expected Values'  |  'Probabilities'  |  'The Plane'  |  'Space'  |  'Algebraic Expressions'  |  'Numerical Expressions' ;<notation_object> ::=  'in' ' ' 'Fractional Notations'  | 'in' ' ' 'Decimal Notations'  | 'in' ' ' 'Proportional Notation'  | 'in' ' ' 'Addition Notation'  | 'in' ' ' 'Subtraction Notation'  | 'in' ' ' 'Multiplication Notations'  | 'in' ' ' 'Division Notations'  | 'in' ' ' 'Radical Notation'  | 'in' ' ' 'Exponential Notation'  | 'in' ' ' 'Scientific Notation'  | 'in' ' ' 'Base Ten'  ;<math_practice_competency> ::=  'Make Sense of Problems'  |  'Persevere in Solving Problems'  |  'Reason Abstractly'  |  'Reason Quantitatively'  |  'Construct Viable Arguments'  |  'Critique Reasoning'  |  'Model Problems'  |  'Use Tools Strategically'  |  'Attend to Precision'  |  'Look for Structure'  |  'Make Use of Structure'  |  'Look for Regularity in Repeated Reasoning'  |  'Express Regularity in Repeated Reasoning' ; <sub_scope> ::=  '0'  |  '1'  |  'to 2'  |  'to 3'  |  'to 4'  |  'to 5'  |  'within 10'  |  'within 20'  |  'within 100'  |  'within 120'  |  'within 1000' ;<line_break> ::= '\n'');

// Set symbol separator to space (default is '')
bnfgen.symbolSeparator = ' ';

// bnfgen.generate function requires a start symbol
bnfgen.generate('start') // generates "hello world" or "hi world"
bnfgen.generate('greeting') // generates "hello" or "hi"



//// Limits

// Maximum number of reductions you allow to perform
// (bnfgen will raise an error if it's exceeded)
// 0 means no limit
// bnfgen.maxReductions = 0

// Maximum number of reductions that don't produce any terminals
// maxNonproductiveReductions = 0

//// Debug options

// Log symbol reductions
// bnfgen.debug = false

// Also log current symbol stack at every
// bnfgen.dumpStack = false

// You can supply a custom logging function instead of the default console.log
// bnfgen.debugFunction = console.log
