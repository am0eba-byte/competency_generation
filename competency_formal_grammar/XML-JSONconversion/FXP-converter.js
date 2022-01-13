const {XMLParser} = require('fast-xml-parser');

const exXmlData = `<root a="nice" checked><a>wow</a></root>`;

const xmlData = require(`./inputXML/numericExpNestedOutput.xml`)

const options = {
    ignoreAttributes: false,
    attributeNamePrefix : "@_"
};
const parser = new XMLParser(options);
const output = parser.parse(xmlDataStr);

console.log(output)