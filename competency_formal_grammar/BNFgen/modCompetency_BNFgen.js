var bnfgen = require('bnfgen');

// Parse and load a grammar
bnfgen.loadGrammar('<start> ::= <greeting> "world"; <greeting> = "hello" | "hi"');

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
